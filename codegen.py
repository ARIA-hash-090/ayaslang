from llvmlite import ir
from ayasparser import (NumberNode, FloatNode, StringNode, IdentifierNode,
                        LetNode, AssignNode, ShowNode, UnaryOpNode, BinaryOpNode,
                        CompareNode, WhenNode, RepeatTimesNode, RepeatInNode,
                        FunNode, CallNode, GiveBackNode)

int_type   = ir.IntType(64)
float_type = ir.DoubleType()
bool_type  = ir.IntType(1)
void_type  = ir.VoidType()

# vec2/vec3/vec4 are LLVM vector types of doubles. Using real LLVM vectors
# (rather than structs) means [+ - * /] become single fadd/fsub/fmul/fdiv
# instructions across all components, and the optimizer can map them to
# SIMD registers directly. This is the only "type" addition for now —
# kept deliberately minimal per the games-only / no-bloat scope.
VECTOR_TYPES = {
    "vec2": ir.VectorType(float_type, 2),
    "vec3": ir.VectorType(float_type, 3),
    "vec4": ir.VectorType(float_type, 4),
}

# A 4x4 matrix is stored as 4 rows, each row a vec4 — i.e. an array of 4
# vec4s. Row-major: mat4[i] is row i, mat4[i][j] is row i, column j.
MAT4_TYPE = ir.ArrayType(VECTOR_TYPES["vec4"], 4)

# Maps the type names usable in `fun foo(a: vec3)` annotations to their
# LLVM types. "number" (the default) is i64, "float" is a double.
TYPE_NAMES = {
    "number": int_type,
    "int":    int_type,
    "float":  float_type,
    "vec2":   VECTOR_TYPES["vec2"],
    "vec3":   VECTOR_TYPES["vec3"],
    "vec4":   VECTOR_TYPES["vec4"],
    "mat4":   MAT4_TYPE,
}

class Codegen:
    def __init__(self):
        self.module    = ir.Module(name="ayas")
        self.builder   = None
        self.vars      = {}
        self.functions = {}
        self.setup_printf()

    def alloca(self, typ, name=""):
        """alloca, but capped at 16-byte alignment. By default LLVM gives
        vec4/mat4 (32-byte values) 32-byte alignment, which forces the
        function to dynamically realign its stack (`and rsp, -32`). On
        Windows this can produce a function whose prologue/unwind info is
        broken, crashing the moment the function is entered — before any
        of its code (including the very first `show`) ever runs. Capping
        at 16 avoids that entirely; 16-byte-unaligned access to doubles
        has no correctness cost on x86-64."""
        ptr = self.builder.alloca(typ, name=name)
        ptr.align = 16
        return ptr

    def setup_printf(self):
        voidptr_ty  = ir.IntType(8).as_pointer()
        printf_ty   = ir.FunctionType(ir.IntType(32), [voidptr_ty], var_arg=True)
        self.printf = ir.Function(self.module, printf_ty, name="printf")

        fflush_ty   = ir.FunctionType(ir.IntType(32), [voidptr_ty])
        self.fflush = ir.Function(self.module, fflush_ty, name="fflush")
        self.voidptr_ty = voidptr_ty

        # sin/cos for mat4_rotate_x/y/z. Declared as the standard LLVM
        # intrinsics (rather than calling out to a hand-named "sin"/"cos"
        # function) so the backend lowers them itself — on x86-64 this
        # becomes a real call to the platform's libm/CRT sin/cos, the same
        # functions a C compiler would emit for `sin()`/`cos()`. Using the
        # intrinsic form means we don't have to know in advance which C
        # runtime symbol name is correct on a given target.
        trig_ty   = ir.FunctionType(float_type, [float_type])
        self.llvm_sin = ir.Function(self.module, trig_ty, name="llvm.sin.f64")
        self.llvm_cos = ir.Function(self.module, trig_ty, name="llvm.cos.f64")

    def flush_stdout(self):
        """Force any buffered printf output to actually appear right now —
        otherwise if the program crashes later, output already produced
        can be lost entirely (looking like 'no output at all')."""
        null_ptr = ir.Constant(self.voidptr_ty, None)
        self.builder.call(self.fflush, [null_ptr])

    def generate(self, statements):
        fun_nodes       = [s for s in statements if isinstance(s, FunNode)]
        main_statements = [s for s in statements if not isinstance(s, FunNode)]

        # Work out each function's parameter types from its `: type`
        # annotations (a bare param with no annotation defaults to "number",
        # i.e. i64 — same as before).
        fn_param_types = {}
        for fn in fun_nodes:
            fn_param_types[fn.name] = [
                TYPE_NAMES.get(t, int_type) for t in fn.param_types
            ]

        # Return types aren't annotated — they're inferred from whatever
        # `give back` produces. A function's return type can depend on
        # what other functions it calls, so we infer in two passes:
        # pass 1 assumes every call returns a number (i64), pass 2 redoes
        # inference using pass 1's results. This covers normal call chains
        # (a function calling helper functions) without needing the user
        # to write any type annotations on return values.
        fn_return_types = {fn.name: int_type for fn in fun_nodes}
        for _ in range(2):
            for fn in fun_nodes:
                fn_return_types[fn.name] = self.infer_function_return_type(
                    fn, fn_param_types[fn.name], fn_return_types)

        # Pass 1: declare every function's signature first, so calls work
        # regardless of declaration order (and recursion works too).
        for fn in fun_nodes:
            fn_ty   = ir.FunctionType(fn_return_types[fn.name], fn_param_types[fn.name])
            ir_func = ir.Function(self.module, fn_ty, name=fn.name)
            self.functions[fn.name] = ir_func

        # Pass 2: generate each function's body with its own fresh scope.
        for fn in fun_nodes:
            self.gen_function(fn)

        # Generate main from whatever's left over at the top level.
        main_ty   = ir.FunctionType(ir.IntType(32), [])
        main_func = ir.Function(self.module, main_ty, name="main")
        block     = main_func.append_basic_block(name="entry")
        self.builder = ir.IRBuilder(block)
        self.vars = {}

        for stmt in main_statements:
            self.gen_statement(stmt)

        if not self.builder.block.is_terminated:
            self.builder.ret(ir.Constant(ir.IntType(32), 0))

        return self.module

    def gen_function(self, fn):
        ir_func = self.functions[fn.name]
        block   = ir_func.append_basic_block(name="entry")
        self.builder = ir.IRBuilder(block)
        self.vars = {}
        self.current_return_type = ir_func.function_type.return_type

        for i, param_name in enumerate(fn.params):
            arg = ir_func.args[i]
            arg.name = param_name
            ptr = self.alloca(arg.type, name=param_name)
            self.builder.store(arg, ptr)
            self.vars[param_name] = ptr

        for stmt in fn.body:
            self.gen_statement(stmt)

        if not self.builder.block.is_terminated:
            self.builder.ret(self.zero_value(self.current_return_type))

    def zero_value(self, t):
        """A reasonable 'nothing happened' default value for a type —
        used as the implicit return when a function falls off the end
        without a `give back`."""
        if isinstance(t, ir.VectorType):
            return ir.Constant(t, [ir.Constant(float_type, 0.0)] * t.count)
        if t == MAT4_TYPE:
            return ir.Constant(MAT4_TYPE, [self.zero_value(VECTOR_TYPES["vec4"])] * 4)
        return ir.Constant(t, 0)

    # ------------------------------------------------------------------
    # Type inference for function return types
    # ------------------------------------------------------------------
    # These mirror the *type rules* of gen_expr/gen_statement without
    # generating any IR — just figuring out what LLVM type a function's
    # `give back` expression(s) will produce, given its parameter types.

    def infer_function_return_type(self, fn, param_types, fn_return_types):
        type_env = dict(zip(fn.params, param_types))
        result   = self.infer_walk(fn.body, type_env, fn_return_types)
        return result if result is not None else int_type

    def infer_walk(self, body, type_env, fn_return_types):
        """Walks statements (mutating type_env for `let`s, like gen_statement
        mutates self.vars), returning the type of the first `give back`
        found, or None if this body never returns."""
        for stmt in body:
            if isinstance(stmt, LetNode):
                type_env[stmt.name] = self.infer_expr_type(stmt.value, type_env, fn_return_types)
            elif isinstance(stmt, GiveBackNode):
                return self.infer_expr_type(stmt.value, type_env, fn_return_types)
            elif isinstance(stmt, WhenNode):
                for _, branch_body in stmt.branches:
                    result = self.infer_walk(branch_body, type_env, fn_return_types)
                    if result is not None:
                        return result
                if stmt.otherwise is not None:
                    result = self.infer_walk(stmt.otherwise, type_env, fn_return_types)
                    if result is not None:
                        return result
            elif isinstance(stmt, RepeatTimesNode):
                result = self.infer_walk(stmt.body, type_env, fn_return_types)
                if result is not None:
                    return result
            elif isinstance(stmt, RepeatInNode):
                type_env[stmt.var_name] = int_type
                result = self.infer_walk(stmt.body, type_env, fn_return_types)
                if result is not None:
                    return result
        return None

    def infer_expr_type(self, node, type_env, fn_return_types):
        if isinstance(node, NumberNode):
            return int_type
        elif isinstance(node, FloatNode):
            return float_type
        elif isinstance(node, IdentifierNode):
            return type_env.get(node.name, int_type)
        elif isinstance(node, UnaryOpNode):
            return self.infer_expr_type(node.operand, type_env, fn_return_types)
        elif isinstance(node, BinaryOpNode):
            left  = self.infer_expr_type(node.left, type_env, fn_return_types)
            right = self.infer_expr_type(node.right, type_env, fn_return_types)
            if left == MAT4_TYPE and right == MAT4_TYPE:
                return MAT4_TYPE
            if left == MAT4_TYPE and right == VECTOR_TYPES["vec4"]:
                return VECTOR_TYPES["vec4"]
            if isinstance(left, ir.VectorType):
                return left
            if isinstance(right, ir.VectorType):
                return right
            if left == float_type or right == float_type:
                return float_type
            return int_type
        elif isinstance(node, CallNode):
            if node.name in VECTOR_TYPES:
                return VECTOR_TYPES[node.name]
            if node.name in ("mat4", "mat4_identity", "mat4_translate", "mat4_scale",
                             "mat4_rotate_x", "mat4_rotate_y", "mat4_rotate_z"):
                return MAT4_TYPE
            return fn_return_types.get(node.name, int_type)
        else:
            return int_type

    def gen_statement(self, node):
        if isinstance(node, LetNode):
            value = self.gen_expr(node.value)
            # alloca the type of whatever the expression produced — i64 for
            # ints, double for floats. This is how variable "type" is
            # tracked: there's no separate type table, the IR value's own
            # type (and therefore the alloca's pointee type) carries it.
            ptr = self.alloca(value.type, name=node.name)
            self.builder.store(value, ptr)
            self.vars[node.name] = ptr

        elif isinstance(node, AssignNode):
            ptr = self.vars.get(node.name)
            if ptr is None:
                raise Exception(f"Cannot assign to undeclared variable: '{node.name}' — use 'let {node.name} be ...' first")
            value = self.gen_expr(node.value)
            self.builder.store(value, ptr)

        elif isinstance(node, ShowNode):
            self.gen_show(node)

        elif isinstance(node, WhenNode):
            self.gen_when(node)

        elif isinstance(node, RepeatTimesNode):
            self.gen_repeat_times(node)

        elif isinstance(node, RepeatInNode):
            self.gen_repeat_in(node)

        elif isinstance(node, GiveBackNode):
            value = self.gen_expr(node.value)
            value = self.coerce_to(value, self.current_return_type)
            self.builder.ret(value)

        elif isinstance(node, CallNode):
            # Called as a standalone statement — evaluate for side effects,
            # discard the returned value.
            self.gen_expr(node)

    DECIMAL_PLACES = 4
    DECIMAL_SCALE  = 10 ** DECIMAL_PLACES

    def get_global_string(self, text, name):
        """Returns an i8* to a null-terminated global string constant,
        creating it once per unique name."""
        full_text = text + "\0"
        if name not in self.module.globals:
            c_str = ir.Constant(ir.ArrayType(ir.IntType(8), len(full_text)),
                                 bytearray(full_text.encode("utf8")))
            g = ir.GlobalVariable(self.module, c_str.type, name=name)
            g.linkage         = "internal"
            g.global_constant = True
            g.initializer     = c_str
        return self.builder.bitcast(self.module.globals[name], ir.IntType(8).as_pointer())

    def print_text(self, text, name):
        """printf with no extra arguments — just a literal string (must
        not contain '%')."""
        ptr = self.get_global_string(text, name)
        self.builder.call(self.printf, [ptr])
        self.flush_stdout()

    def print_int_fmt(self, value, fmt, name):
        """printf with a single i64 argument. Only ever passes integers
        to printf — never doubles (see gen_show_double)."""
        ptr = self.get_global_string(fmt, name)
        self.builder.call(self.printf, [ptr, value])
        self.flush_stdout()

    def gen_show(self, node):
        value = self.gen_expr(node.value)

        if isinstance(value.type, ir.VectorType):
            self.gen_show_vector(value)
            return

        if value.type == MAT4_TYPE:
            for i in range(4):
                row = self.builder.extract_value(value, i)
                self.gen_show_vector(row)
            return

        if value.type == float_type:
            self.gen_show_double(value)
            self.print_text("\n", "str_newline")
            return

        self.print_int_fmt(value, "%lld\n\0", "fmt_int")

    def gen_show_vector(self, value):
        """Print a vec2/vec3/vec4 as (x, y, z)."""
        size = value.type.count
        self.print_text("(", "str_lparen")
        for i in range(size):
            comp = self.builder.extract_element(value, ir.Constant(ir.IntType(32), i))
            self.gen_show_double(comp)
            if i < size - 1:
                self.print_text(", ", "str_comma_space")
        self.print_text(")\n", "str_rparen_nl")

    def gen_show_double(self, value):
        """Prints a double with DECIMAL_PLACES decimal digits, e.g.
        '1.5000' or '-2.0000', using ONLY integer printf calls plus plain
        string literals — never passing a `double` to printf's varargs.
        That's the part that's notoriously fragile on Windows x64 when the
        IR is hand-written rather than produced by a C compiler."""
        is_neg = self.builder.fcmp_ordered("<", value, ir.Constant(float_type, 0.0))
        with self.builder.if_then(is_neg):
            self.print_text("-", "str_minus")

        abs_value  = self.builder.select(is_neg, self.builder.fneg(value), value)
        int_part   = self.builder.fptosi(abs_value, int_type)
        int_part_f = self.builder.sitofp(int_part, float_type)
        frac       = self.builder.fsub(abs_value, int_part_f)

        scaled_f = self.builder.fmul(frac, ir.Constant(float_type, float(self.DECIMAL_SCALE)))
        scaled_f = self.builder.fadd(scaled_f, ir.Constant(float_type, 0.5))
        scaled   = self.builder.fptosi(scaled_f, int_type)

        # Rounding can carry the fractional part all the way up to
        # DECIMAL_SCALE (e.g. 1.99996 -> int=1, frac scaled=10000).
        # In that case bump the integer part instead and zero the frac.
        scale_const = ir.Constant(int_type, self.DECIMAL_SCALE)
        overflow = self.builder.icmp_signed(">=", scaled, scale_const)
        int_part = self.builder.select(overflow, self.builder.add(int_part, ir.Constant(int_type, 1)), int_part)
        scaled   = self.builder.select(overflow, ir.Constant(int_type, 0), scaled)

        self.print_int_fmt(int_part, "%lld\0", "fmt_int_plain")
        self.print_text(".", "str_dot")
        self.print_int_fmt(scaled, f"%0{self.DECIMAL_PLACES}lld\0", "fmt_frac")

    def gen_when(self, node):
        func  = self.builder.block.function
        merge = func.append_basic_block("merge")

        for i, (condition, body) in enumerate(node.branches):
            body_block = func.append_basic_block(f"when_body_{i}")
            if i + 1 < len(node.branches):
                next_block = func.append_basic_block(f"when_check_{i+1}")
            elif node.otherwise is not None:
                next_block = func.append_basic_block("otherwise")
            else:
                next_block = merge

            cond_val = self.gen_compare(condition)
            self.builder.cbranch(cond_val, body_block, next_block)

            self.builder.position_at_end(body_block)
            for stmt in body:
                self.gen_statement(stmt)
            if not self.builder.block.is_terminated:
                self.builder.branch(merge)

            self.builder.position_at_end(next_block)

        if node.otherwise is not None:
            for stmt in node.otherwise:
                self.gen_statement(stmt)
            if not self.builder.block.is_terminated:
                self.builder.branch(merge)

        self.builder.position_at_end(merge)

    def gen_repeat_times(self, node):
        func = self.builder.block.function

        counter_ptr = self.alloca(int_type, name="repeat_counter")
        self.builder.store(ir.Constant(int_type, 0), counter_ptr)

        check_block = func.append_basic_block("repeat_check")
        body_block  = func.append_basic_block("repeat_body")
        end_block   = func.append_basic_block("repeat_end")

        self.builder.branch(check_block)

        self.builder.position_at_end(check_block)
        counter_val = self.builder.load(counter_ptr, name="counter")
        limit_val   = ir.Constant(int_type, int(node.count))
        cond        = self.builder.icmp_signed("<", counter_val, limit_val)
        self.builder.cbranch(cond, body_block, end_block)

        self.builder.position_at_end(body_block)
        for stmt in node.body:
            self.gen_statement(stmt)

        if not self.builder.block.is_terminated:
            counter_val = self.builder.load(counter_ptr, name="counter")
            next_val    = self.builder.add(counter_val, ir.Constant(int_type, 1))
            self.builder.store(next_val, counter_ptr)
            self.builder.branch(check_block)

        self.builder.position_at_end(end_block)

    def gen_repeat_in(self, node):
        func = self.builder.block.function

        # Set up the loop variable like a normal `let`-declared variable
        var_ptr   = self.alloca(int_type, name=node.var_name)
        start_val = self.gen_expr(node.start)
        self.builder.store(start_val, var_ptr)
        self.vars[node.var_name] = var_ptr

        # Evaluate the end bound once, before the loop starts
        end_val = self.gen_expr(node.end)

        check_block = func.append_basic_block("repeat_in_check")
        body_block  = func.append_basic_block("repeat_in_body")
        end_block   = func.append_basic_block("repeat_in_end")

        self.builder.branch(check_block)

        self.builder.position_at_end(check_block)
        current_val = self.builder.load(var_ptr, name=node.var_name)
        cond        = self.builder.icmp_signed("<", current_val, end_val)
        self.builder.cbranch(cond, body_block, end_block)

        self.builder.position_at_end(body_block)
        for stmt in node.body:
            self.gen_statement(stmt)

        if not self.builder.block.is_terminated:
            current_val = self.builder.load(var_ptr, name=node.var_name)
            next_val    = self.builder.add(current_val, ir.Constant(int_type, 1))
            self.builder.store(next_val, var_ptr)
            self.builder.branch(check_block)

        self.builder.position_at_end(end_block)

    def promote_to_common_type(self, left, right):
        """If one side is i64 and the other is double, convert the i64 side
        to double (sitofp) so both operands match. Returns
        (left, right, is_float)."""
        if left.type == right.type:
            return left, right, (left.type == float_type)
        if left.type == int_type and right.type == float_type:
            return self.builder.sitofp(left, float_type), right, True
        if left.type == float_type and right.type == int_type:
            return left, self.builder.sitofp(right, float_type), True
        raise Exception(f"Cannot combine incompatible types {left.type} and {right.type}")

    def gen_compare(self, node):
        left  = self.gen_expr(node.left)
        right = self.gen_expr(node.right)
        left, right, is_float = self.promote_to_common_type(left, right)

        op = node.op
        if op == "is":
            cmp_op = "=="
        elif op == "is not":
            cmp_op = "!="
        elif op in (">", "<", ">=", "<="):
            cmp_op = op
        else:
            raise Exception(f"Unknown comparison operator: {op}")

        if is_float:
            return self.builder.fcmp_ordered(cmp_op, left, right)
        return self.builder.icmp_signed(cmp_op, left, right)

    def gen_expr(self, node):
        if isinstance(node, NumberNode):
            return ir.Constant(int_type, int(node.value))

        elif isinstance(node, FloatNode):
            return ir.Constant(float_type, float(node.value))

        elif isinstance(node, IdentifierNode):
            ptr = self.vars.get(node.name)
            if ptr is None:
                raise Exception(f"Unknown variable: {node.name}")
            return self.builder.load(ptr, name=node.name)

        elif isinstance(node, UnaryOpNode):
            value = self.gen_expr(node.operand)
            if node.op == "-":
                if value.type == int_type:
                    return self.builder.neg(value)
                elif value.type == float_type or isinstance(value.type, ir.VectorType):
                    return self.builder.fneg(value)
                else:
                    raise Exception(f"Cannot negate value of type {value.type}")
            else:
                raise Exception(f"Unknown unary operator: {node.op}")

        elif isinstance(node, BinaryOpNode):
            left  = self.gen_expr(node.left)
            right = self.gen_expr(node.right)

            if left.type == MAT4_TYPE or right.type == MAT4_TYPE:
                return self.gen_mat4_binop(left, right, node.op)

            if isinstance(left.type, ir.VectorType) or isinstance(right.type, ir.VectorType):
                return self.gen_vector_binop(left, right, node.op)

            left, right, is_float = self.promote_to_common_type(left, right)

            if node.op == "+":
                return self.builder.fadd(left, right) if is_float else self.builder.add(left, right)
            elif node.op == "-":
                return self.builder.fsub(left, right) if is_float else self.builder.sub(left, right)
            elif node.op == "*":
                return self.builder.fmul(left, right) if is_float else self.builder.mul(left, right)
            elif node.op == "/":
                return self.builder.fdiv(left, right) if is_float else self.builder.sdiv(left, right)
            else:
                raise Exception(f"Unknown binary operator: {node.op}")

        elif isinstance(node, CallNode):
            if node.name in VECTOR_TYPES:
                return self.gen_vector_constructor(node)

            if node.name == "mat4":
                return self.gen_mat4_constructor(node)
            if node.name == "mat4_identity":
                return self.gen_mat4_identity(node)
            if node.name == "mat4_translate":
                return self.gen_mat4_translate(node)
            if node.name == "mat4_scale":
                return self.gen_mat4_scale(node)
            if node.name == "mat4_rotate_x":
                return self.gen_mat4_rotate_x(node)
            if node.name == "mat4_rotate_y":
                return self.gen_mat4_rotate_y(node)
            if node.name == "mat4_rotate_z":
                return self.gen_mat4_rotate_z(node)

            func = self.functions.get(node.name)
            if func is None:
                raise Exception(f"Unknown function: '{node.name}'")
            if len(node.args) != len(func.args):
                raise Exception(f"Function '{node.name}' expects {len(func.args)} argument(s), got {len(node.args)}")
            arg_vals = [self.coerce_to(self.gen_expr(arg), param.type)
                        for arg, param in zip(node.args, func.args)]
            return self.builder.call(func, arg_vals)

    def coerce_to(self, value, target_type):
        """Converts a value to match an expected type where that's a sane,
        lossless-ish thing to do (number <-> float). Used for `give back`
        values and function-call arguments, so e.g. passing a plain `0`
        where a function expects `: float` just works."""
        if value.type == target_type:
            return value
        if value.type == int_type and target_type == float_type:
            return self.builder.sitofp(value, float_type)
        if value.type == float_type and target_type == int_type:
            return self.builder.fptosi(value, int_type)
        raise Exception(f"Type mismatch: got {value.type}, expected {target_type}")

    def to_float(self, value):
        """Coerces a number (int or float) to a double — used for the
        x/y/z arguments of mat4_translate/mat4_scale."""
        if value.type == int_type:
            return self.builder.sitofp(value, float_type)
        if value.type == float_type:
            return value
        raise Exception(f"Expected a number, got {value.type}")

    def gen_vector_constructor(self, node):
        """vec2(x, y) / vec3(x, y, z) / vec4(x, y, z, w) — builds an LLVM
        vector value lane by lane. Integer arguments are promoted to
        doubles since vec2/3/4 are always vectors of doubles."""
        vtype = VECTOR_TYPES[node.name]
        size  = vtype.count

        if len(node.args) != size:
            raise Exception(f"{node.name}(...) expects {size} argument(s), got {len(node.args)}")

        result = ir.Constant(vtype, ir.Undefined)
        for i, arg in enumerate(node.args):
            val = self.gen_expr(arg)
            if val.type == int_type:
                val = self.builder.sitofp(val, float_type)
            elif val.type != float_type:
                raise Exception(f"{node.name}(...) arguments must be numbers, got {val.type}")
            result = self.builder.insert_element(result, val, ir.Constant(ir.IntType(32), i))
        return result

    def splat(self, scalar, vtype):
        """Broadcast a scalar value into every lane of a vector of type
        vtype — used so `[pos * 2]` and `[2 * pos]` work for scaling."""
        if scalar.type == int_type:
            scalar = self.builder.sitofp(scalar, float_type)
        elif scalar.type != float_type:
            raise Exception(f"Cannot use {scalar.type} as a vector component")

        result = ir.Constant(vtype, ir.Undefined)
        for i in range(vtype.count):
            result = self.builder.insert_element(result, scalar, ir.Constant(ir.IntType(32), i))
        return result

    def gen_vector_binop(self, left, right, op):
        """[+ - * /] between two vectors (component-wise) or between a
        vector and a scalar (the scalar is broadcast to every lane —
        e.g. `[pos * 2]` scales every component)."""
        left_is_vec  = isinstance(left.type, ir.VectorType)
        right_is_vec = isinstance(right.type, ir.VectorType)

        if left_is_vec and right_is_vec:
            if left.type != right.type:
                raise Exception(f"Cannot combine vectors of different sizes: {left.type} and {right.type}")
        elif left_is_vec:
            right = self.splat(right, left.type)
        elif right_is_vec:
            left = self.splat(left, right.type)

        if op == "+":
            return self.builder.fadd(left, right)
        elif op == "-":
            return self.builder.fsub(left, right)
        elif op == "*":
            return self.builder.fmul(left, right)
        elif op == "/":
            return self.builder.fdiv(left, right)
        else:
            raise Exception(f"Unknown vector operator: {op}")

    # ------------------------------------------------------------------
    # mat4 — a 4x4 matrix stored as 4 rows of vec4, row-major.
    # Used for game/engine transforms (move, scale, rotate, project).
    # ------------------------------------------------------------------

    def identity_mat4_constant(self):
        """Returns the constant 4x4 identity matrix — the 'do nothing'
        transform, and the standard starting point for building others."""
        rows = []
        for i in range(4):
            comps = [ir.Constant(float_type, 1.0 if i == j else 0.0) for j in range(4)]
            rows.append(ir.Constant(VECTOR_TYPES["vec4"], comps))
        return ir.Constant(MAT4_TYPE, rows)

    def gen_mat4_constructor(self, node):
        """mat4(row0, row1, row2, row3) — builds a matrix from 4 vec4 rows.
        Mostly useful if you want to build a custom matrix by hand; for
        everyday use, mat4_identity()/mat4_translate()/mat4_scale() are
        easier."""
        if len(node.args) != 4:
            raise Exception("mat4(...) expects 4 rows (each a vec4)")

        result = ir.Constant(MAT4_TYPE, ir.Undefined)
        for i, arg in enumerate(node.args):
            row = self.gen_expr(arg)
            if row.type != VECTOR_TYPES["vec4"]:
                raise Exception(f"mat4(...) row {i} must be a vec4, got {row.type}")
            result = self.builder.insert_value(result, row, i)
        return result

    def gen_mat4_identity(self, node):
        """mat4_identity() — the 'do nothing' transform. Start here when
        building up a transform, e.g.:
            let m be mat4_identity()
        """
        if len(node.args) != 0:
            raise Exception("mat4_identity() takes no arguments")
        return self.identity_mat4_constant()

    def gen_mat4_translate(self, node):
        """mat4_translate(x, y, z) — a matrix that moves a point by
        (x, y, z) when multiplied with it: [m * vec4(px, py, pz, 1)]."""
        if len(node.args) != 3:
            raise Exception("mat4_translate(x, y, z) expects 3 numbers")

        result = self.identity_mat4_constant()
        for i, arg in enumerate(node.args):
            val = self.to_float(self.gen_expr(arg))
            row = self.builder.extract_value(result, i)
            row = self.builder.insert_element(row, val, ir.Constant(ir.IntType(32), 3))
            result = self.builder.insert_value(result, row, i)
        return result

    def gen_mat4_scale(self, node):
        """mat4_scale(x, y, z) — a matrix that scales a point's x/y/z
        components by these factors when multiplied with it."""
        if len(node.args) != 3:
            raise Exception("mat4_scale(x, y, z) expects 3 numbers")

        result = self.identity_mat4_constant()
        for i, arg in enumerate(node.args):
            val = self.to_float(self.gen_expr(arg))
            row = self.builder.extract_value(result, i)
            row = self.builder.insert_element(row, val, ir.Constant(ir.IntType(32), i))
            result = self.builder.insert_value(result, row, i)
        return result

    def sincos(self, angle):
        """Returns (sin(angle), cos(angle)) as doubles, computed via the
        llvm.sin.f64/llvm.cos.f64 intrinsics declared in setup_printf."""
        angle = self.to_float(angle)
        s = self.builder.call(self.llvm_sin, [angle])
        c = self.builder.call(self.llvm_cos, [angle])
        return s, c

    def build_mat4_from_rows(self, rows):
        """Builds a constant-shaped mat4 IR value, lane by lane, from 4
        lists of 4 scalar IR values each (row-major) — used by the
        rotation matrices, whose entries are runtime sin/cos values and
        so can't be folded into an ir.Constant the way identity/translate/
        scale's mostly-constant entries can."""
        result = ir.Constant(MAT4_TYPE, ir.Undefined)
        for i, row_vals in enumerate(rows):
            row = ir.Constant(VECTOR_TYPES["vec4"], ir.Undefined)
            for j, val in enumerate(row_vals):
                row = self.builder.insert_element(row, val, ir.Constant(ir.IntType(32), j))
            result = self.builder.insert_value(result, row, i)
        return result

    def gen_mat4_rotate_x(self, node):
        """mat4_rotate_x(angle) — rotates around the X axis by `angle`
        radians (right-handed: Y rotates toward Z). X is left fixed."""
        if len(node.args) != 1:
            raise Exception("mat4_rotate_x(angle) expects 1 argument")

        s, c = self.sincos(self.gen_expr(node.args[0]))
        zero = ir.Constant(float_type, 0.0)
        one  = ir.Constant(float_type, 1.0)
        neg_s = self.builder.fneg(s)

        rows = [
            [one,  zero, zero,  zero],
            [zero, c,    neg_s, zero],
            [zero, s,    c,     zero],
            [zero, zero, zero,  one],
        ]
        return self.build_mat4_from_rows(rows)

    def gen_mat4_rotate_y(self, node):
        """mat4_rotate_y(angle) — rotates around the Y axis by `angle`
        radians (right-handed: Z rotates toward X). Y is left fixed."""
        if len(node.args) != 1:
            raise Exception("mat4_rotate_y(angle) expects 1 argument")

        s, c = self.sincos(self.gen_expr(node.args[0]))
        zero = ir.Constant(float_type, 0.0)
        one  = ir.Constant(float_type, 1.0)
        neg_s = self.builder.fneg(s)

        rows = [
            [c,    zero, s,    zero],
            [zero, one,  zero, zero],
            [neg_s, zero, c,   zero],
            [zero, zero, zero, one],
        ]
        return self.build_mat4_from_rows(rows)

    def gen_mat4_rotate_z(self, node):
        """mat4_rotate_z(angle) — rotates around the Z axis by `angle`
        radians (right-handed: X rotates toward Y). Z is left fixed."""
        if len(node.args) != 1:
            raise Exception("mat4_rotate_z(angle) expects 1 argument")

        s, c = self.sincos(self.gen_expr(node.args[0]))
        zero = ir.Constant(float_type, 0.0)
        one  = ir.Constant(float_type, 1.0)
        neg_s = self.builder.fneg(s)

        rows = [
            [c,   neg_s, zero, zero],
            [s,   c,     zero, zero],
            [zero, zero, one,  zero],
            [zero, zero, zero, one],
        ]
        return self.build_mat4_from_rows(rows)

    def gen_dot(self, a, b):
        """Dot product of two same-size vectors -> a single double."""
        prod  = self.builder.fmul(a, b)
        size  = a.type.count
        total = self.builder.extract_element(prod, ir.Constant(ir.IntType(32), 0))
        for i in range(1, size):
            comp  = self.builder.extract_element(prod, ir.Constant(ir.IntType(32), i))
            total = self.builder.fadd(total, comp)
        return total

    def gen_mat4_vec_mul(self, m, v):
        """mat4 * vec4 -> vec4 — transforms a point/direction by a matrix.
        Each output component is the dot product of a matrix row with v."""
        result = ir.Constant(VECTOR_TYPES["vec4"], ir.Undefined)
        for i in range(4):
            row = self.builder.extract_value(m, i)
            d   = self.gen_dot(row, v)
            result = self.builder.insert_element(result, d, ir.Constant(ir.IntType(32), i))
        return result

    def gen_mat4_mat_mul(self, m1, m2):
        """mat4 * mat4 -> mat4 — combines two transforms. result[i][j] is
        the dot product of m1's row i with m2's column j."""
        # Gather m2's columns first (m2 is stored as rows).
        cols = []
        for j in range(4):
            col = ir.Constant(VECTOR_TYPES["vec4"], ir.Undefined)
            for i in range(4):
                row_i = self.builder.extract_value(m2, i)
                elem  = self.builder.extract_element(row_i, ir.Constant(ir.IntType(32), j))
                col   = self.builder.insert_element(col, elem, ir.Constant(ir.IntType(32), i))
            cols.append(col)

        result = ir.Constant(MAT4_TYPE, ir.Undefined)
        for i in range(4):
            row_i      = self.builder.extract_value(m1, i)
            result_row = ir.Constant(VECTOR_TYPES["vec4"], ir.Undefined)
            for j in range(4):
                d = self.gen_dot(row_i, cols[j])
                result_row = self.builder.insert_element(result_row, d, ir.Constant(ir.IntType(32), j))
            result = self.builder.insert_value(result, result_row, i)
        return result

    def gen_mat4_binop(self, left, right, op):
        if op != "*":
            raise Exception(f"mat4 only supports '*' (got '{op}')")

        if left.type == MAT4_TYPE and right.type == MAT4_TYPE:
            return self.gen_mat4_mat_mul(left, right)
        if left.type == MAT4_TYPE and right.type == VECTOR_TYPES["vec4"]:
            return self.gen_mat4_vec_mul(left, right)

        raise Exception("mat4 can be multiplied with another mat4, or with a vec4")