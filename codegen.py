from llvmlite import ir
from ayasparser import (NumberNode, FloatNode, StringNode, IdentifierNode,
                        LetNode, AssignNode, ShowNode, UnaryOpNode, BinaryOpNode,
                        CompareNode, WhenNode, RepeatTimesNode, RepeatInNode,
                        FunNode, CallNode, GiveBackNode,
                        ThingNode, FieldAccessNode, FieldAssignNode,
                        ArrayLiteralNode, IndexAccessNode, IndexAssignNode,
                        MethodCallNode)

int_type   = ir.IntType(64)
float_type = ir.DoubleType()
bool_type  = ir.IntType(1)
void_type  = ir.VoidType()

VECTOR_TYPES = {
    "vec2": ir.VectorType(float_type, 2),
    "vec3": ir.VectorType(float_type, 3),
    "vec4": ir.VectorType(float_type, 4),
}

MAT4_TYPE = ir.ArrayType(VECTOR_TYPES["vec4"], 4)

STRING_TYPE = ir.IntType(8).as_pointer()

ARRAY_ELEM_SIZE = 8
ARRAY_INIT_CAP  = 4

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
        self.module          = ir.Module(name="ayas")
        self.builder         = None
        self.vars            = {}
        self.functions       = {}
        self.things          = {}
        self.var_thing_types = {}
        self.string_literals = {}
        self.var_array_elem_types     = {}
        self._pending_array_elem_type = None
        self.setup_printf()
        self.setup_arena()
        self.ARRAY_HEADER_TYPE = ir.LiteralStructType([int_type, int_type, self.voidptr_ty])

    def alloca(self, typ, name=""):
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
        trig_ty   = ir.FunctionType(float_type, [float_type])
        self.llvm_sin = ir.Function(self.module, trig_ty, name="llvm.sin.f64")
        self.llvm_cos = ir.Function(self.module, trig_ty, name="llvm.cos.f64")

    ARENA_CAPACITY_BYTES = 1024 * 1024

    def setup_arena(self):
        malloc_ty  = ir.FunctionType(self.voidptr_ty, [int_type])
        self.malloc = ir.Function(self.module, malloc_ty, name="malloc")
        free_ty    = ir.FunctionType(void_type, [self.voidptr_ty])
        self.free  = ir.Function(self.module, free_ty, name="free")

        self.arena_buf_global = ir.GlobalVariable(self.module, self.voidptr_ty, name="ayas_arena_buf")
        self.arena_buf_global.linkage     = "internal"
        self.arena_buf_global.initializer = ir.Constant(self.voidptr_ty, None)

        self.arena_offset_global = ir.GlobalVariable(self.module, int_type, name="ayas_arena_offset")
        self.arena_offset_global.linkage     = "internal"
        self.arena_offset_global.initializer = ir.Constant(int_type, 0)

        memcpy_ty = ir.FunctionType(void_type, [
            self.voidptr_ty, self.voidptr_ty, int_type, bool_type
        ])
        self.llvm_memcpy = ir.Function(self.module, memcpy_ty,
                                       name="llvm.memcpy.p0i8.p0i8.i64")

    def gen_arena_init(self):
        size = ir.Constant(int_type, self.ARENA_CAPACITY_BYTES)
        buf  = self.builder.call(self.malloc, [size])
        self.builder.store(buf, self.arena_buf_global)
        self.builder.store(ir.Constant(int_type, 0), self.arena_offset_global)

    def gen_arena_shutdown(self):
        buf = self.builder.load(self.arena_buf_global)
        self.builder.call(self.free, [buf])

    def gen_arena_alloc(self, node):
        if len(node.args) != 1:
            raise Exception("arena_alloc(size) expects 1 argument")
        size = self.gen_expr(node.args[0])
        if size.type != int_type:
            raise Exception(f"arena_alloc(size) expects a number, got {size.type}")
        offset     = self.builder.load(self.arena_offset_global)
        buf        = self.builder.load(self.arena_buf_global)
        new_offset = self.builder.add(offset, size)
        self.builder.store(new_offset, self.arena_offset_global)
        result_ptr = self.builder.gep(buf, [offset])
        return self.builder.ptrtoint(result_ptr, int_type)

    def gen_arena_reset(self, node):
        if len(node.args) != 0:
            raise Exception("arena_reset() takes no arguments")
        self.builder.store(ir.Constant(int_type, 0), self.arena_offset_global)
        return ir.Constant(int_type, 0)

    def gen_peek_i64(self, node):
        if len(node.args) != 1:
            raise Exception("peek_i64(addr) expects 1 argument")
        addr = self.gen_expr(node.args[0])
        ptr  = self.builder.inttoptr(addr, int_type.as_pointer())
        return self.builder.load(ptr)

    def gen_poke_i64(self, node):
        if len(node.args) != 2:
            raise Exception("poke_i64(addr, value) expects 2 arguments")
        addr  = self.gen_expr(node.args[0])
        value = self.gen_expr(node.args[1])
        ptr   = self.builder.inttoptr(addr, int_type.as_pointer())
        self.builder.store(value, ptr)
        return ir.Constant(int_type, 0)

    def gen_thing(self, node):
        field_types = [TYPE_NAMES.get(t, int_type) for t in node.field_types]
        struct_type = ir.LiteralStructType(field_types)
        self.things[node.name] = {
            "type":        struct_type,
            "fields":      node.fields,
            "field_types": field_types,
        }

    def gen_thing_constructor(self, node):
        info   = self.things[node.name]
        stype  = info["type"]
        ftypes = info["field_types"]
        if len(node.args) != len(ftypes):
            raise Exception(f"{node.name}(...) expects {len(ftypes)} argument(s), got {len(node.args)}")
        result = ir.Constant(stype, ir.Undefined)
        for i, arg in enumerate(node.args):
            val = self.coerce_to(self.gen_expr(arg), ftypes[i])
            result = self.builder.insert_value(result, val, i)
        return result

    def get_field_index(self, struct_name, field_name):
        thing_name = self.var_thing_types.get(struct_name)
        if thing_name is None:
            raise Exception(f"'{struct_name}' is not a struct instance")
        info = self.things[thing_name]
        if field_name not in info["fields"]:
            raise Exception(f"'{thing_name}' has no field '{field_name}'")
        return info, info["fields"].index(field_name)

    def gen_field_access(self, node):
        ptr = self.vars.get(node.name)
        if ptr is None:
            raise Exception(f"Unknown variable: {node.name}")
        if node.name in self.var_array_elem_types:
            if node.field == "length":
                return self.gen_array_length(ptr)
            raise Exception(f"Arrays only support '.length' — use .append() to add elements")
        info, idx = self.get_field_index(node.name, node.field)
        struct_val = self.builder.load(ptr, name=node.name)
        return self.builder.extract_value(struct_val, idx)

    def flush_stdout(self):
        null_ptr = ir.Constant(self.voidptr_ty, None)
        self.builder.call(self.fflush, [null_ptr])

    # ------------------------------------------------------------------
    # Array runtime helpers
    # ------------------------------------------------------------------

    def _arr_load_header(self, ptr):
        return self.builder.load(ptr)

    def gen_array_length(self, ptr):
        return self.builder.extract_value(self._arr_load_header(ptr), 0)

    def gen_array_capacity(self, ptr):
        return self.builder.extract_value(self._arr_load_header(ptr), 1)

    def gen_array_data_ptr(self, ptr):
        return self.builder.extract_value(self._arr_load_header(ptr), 2)

    def gen_array_elem_ptr_from_data(self, data_ptr, index_val):
        byte_off = self.builder.mul(index_val, ir.Constant(int_type, ARRAY_ELEM_SIZE))
        elem_raw = self.builder.gep(data_ptr, [byte_off])
        return self.builder.bitcast(elem_raw, int_type.as_pointer())

    def _elem_to_i64(self, val, elem_type):
        if val.type == int_type:
            return val
        if val.type == float_type:
            return self.builder.bitcast(val, int_type)
        if val.type == STRING_TYPE:
            return self.builder.ptrtoint(val, int_type)
        raise Exception(f"Arrays don't support element type {val.type} yet")

    def _i64_to_elem(self, raw, elem_type):
        if elem_type == int_type:
            return raw
        if elem_type == float_type:
            return self.builder.bitcast(raw, float_type)
        if elem_type == STRING_TYPE:
            return self.builder.inttoptr(raw, STRING_TYPE)
        raise Exception(f"Arrays don't support element type {elem_type} yet")

    def gen_array_bounds_check(self, ptr, index_val, var_name):
        length = self.gen_array_length(ptr)
        func   = self.builder.block.function
        ok_block   = func.append_basic_block("bounds_ok")
        fail_block = func.append_basic_block("bounds_fail")
        too_low  = self.builder.icmp_signed("<",  index_val, ir.Constant(int_type, 0))
        too_high = self.builder.icmp_signed(">=", index_val, length)
        oob      = self.builder.or_(too_low, too_high)
        self.builder.cbranch(oob, fail_block, ok_block)
        self.builder.position_at_end(fail_block)
        self.print_text("Error: array index out of bounds\n", "str_oob_error")
        self.builder.ret(ir.Constant(ir.IntType(32), 1))
        self.builder.position_at_end(ok_block)

    def gen_array_literal(self, node):
        if len(node.elements) == 0:
            elem_type = int_type
            cap_val   = ir.Constant(int_type, ARRAY_INIT_CAP)
        else:
            first_val = self.gen_expr(node.elements[0])
            elem_type = first_val.type
            cap_val   = ir.Constant(int_type, max(ARRAY_INIT_CAP, len(node.elements)))

        self._pending_array_elem_type = elem_type

        byte_cnt   = self.builder.mul(cap_val, ir.Constant(int_type, ARRAY_ELEM_SIZE))
        offset     = self.builder.load(self.arena_offset_global)
        buf        = self.builder.load(self.arena_buf_global)
        new_offset = self.builder.add(offset, byte_cnt)
        self.builder.store(new_offset, self.arena_offset_global)
        data_ptr   = self.builder.gep(buf, [offset])

        for i, elem_node in enumerate(node.elements):
            val = self.gen_expr(elem_node)
            raw = self._elem_to_i64(val, elem_type)
            ep  = self.gen_array_elem_ptr_from_data(data_ptr, ir.Constant(int_type, i))
            self.builder.store(raw, ep)

        len_val = ir.Constant(int_type, len(node.elements))
        header  = ir.Constant(self.ARRAY_HEADER_TYPE, ir.Undefined)
        header  = self.builder.insert_value(header, len_val, 0)
        header  = self.builder.insert_value(header, cap_val, 1)
        header  = self.builder.insert_value(header, data_ptr, 2)
        return header

    def gen_array_index_access(self, node):
        ptr = self.vars.get(node.name)
        if ptr is None:
            raise Exception(f"Unknown variable: '{node.name}'")
        elem_type = self.var_array_elem_types.get(node.name)
        if elem_type is None:
            raise Exception(f"'{node.name}' is not an array")
        index_val = self.gen_expr(node.index)
        if index_val.type != int_type:
            raise Exception(f"Array index must be a number, got {index_val.type}")
        self.gen_array_bounds_check(ptr, index_val, node.name)
        data_ptr = self.gen_array_data_ptr(ptr)
        ep       = self.gen_array_elem_ptr_from_data(data_ptr, index_val)
        raw      = self.builder.load(ep)
        return self._i64_to_elem(raw, elem_type)

    def gen_array_index_assign(self, node):
        ptr = self.vars.get(node.name)
        if ptr is None:
            raise Exception(f"Unknown variable: '{node.name}'")
        elem_type = self.var_array_elem_types.get(node.name)
        if elem_type is None:
            raise Exception(f"'{node.name}' is not an array")
        index_val = self.gen_expr(node.index)
        if index_val.type != int_type:
            raise Exception(f"Array index must be a number, got {index_val.type}")
        self.gen_array_bounds_check(ptr, index_val, node.name)
        val      = self.gen_expr(node.value)
        raw      = self._elem_to_i64(val, elem_type)
        data_ptr = self.gen_array_data_ptr(ptr)
        ep       = self.gen_array_elem_ptr_from_data(data_ptr, index_val)
        self.builder.store(raw, ep)

    def gen_array_append(self, var_name, arg_val):
        ptr = self.vars.get(var_name)
        if ptr is None:
            raise Exception(f"Unknown variable: '{var_name}'")
        elem_type = self.var_array_elem_types.get(var_name)
        if elem_type is None:
            raise Exception(f"'{var_name}' is not an array")
        func = self.builder.block.function

        length   = self.gen_array_length(ptr)
        capacity = self.gen_array_capacity(ptr)
        is_full  = self.builder.icmp_signed(">=", length, capacity)

        grow_block = func.append_basic_block("array_grow")
        cont_block = func.append_basic_block("array_append_cont")
        self.builder.cbranch(is_full, grow_block, cont_block)

        self.builder.position_at_end(grow_block)
        old_cap      = self.gen_array_capacity(ptr)
        new_cap      = self.builder.mul(old_cap, ir.Constant(int_type, 2))
        new_byte_cnt = self.builder.mul(new_cap, ir.Constant(int_type, ARRAY_ELEM_SIZE))
        old_byte_cnt = self.builder.mul(old_cap, ir.Constant(int_type, ARRAY_ELEM_SIZE))
        offset     = self.builder.load(self.arena_offset_global)
        buf        = self.builder.load(self.arena_buf_global)
        new_offset = self.builder.add(offset, new_byte_cnt)
        self.builder.store(new_offset, self.arena_offset_global)
        new_data   = self.builder.gep(buf, [offset])
        old_data   = self.gen_array_data_ptr(ptr)
        false_val  = ir.Constant(bool_type, 0)
        self.builder.call(self.llvm_memcpy, [new_data, old_data, old_byte_cnt, false_val])
        header = self.builder.load(ptr)
        header = self.builder.insert_value(header, new_cap, 1)
        header = self.builder.insert_value(header, new_data, 2)
        self.builder.store(header, ptr)
        self.builder.branch(cont_block)

        self.builder.position_at_end(cont_block)
        cur_len  = self.gen_array_length(ptr)
        raw      = self._elem_to_i64(arg_val, elem_type)
        data_ptr = self.gen_array_data_ptr(ptr)
        ep       = self.gen_array_elem_ptr_from_data(data_ptr, cur_len)
        self.builder.store(raw, ep)
        new_len = self.builder.add(cur_len, ir.Constant(int_type, 1))
        header  = self.builder.load(ptr)
        header  = self.builder.insert_value(header, new_len, 0)
        self.builder.store(header, ptr)

    def gen_method_call(self, node):
        if node.method == "append":
            if len(node.args) != 1:
                raise Exception(f".append() takes exactly 1 argument, got {len(node.args)}")
            arg_val = self.gen_expr(node.args[0])
            self.gen_array_append(node.name, arg_val)
            return ir.Constant(int_type, 0)
        raise Exception(f"Unknown method '.{node.method}' — only .append() is supported on arrays")

    def gen_show_array(self, var_name):
        ptr       = self.vars[var_name]
        elem_type = self.var_array_elem_types[var_name]
        func      = self.builder.block.function
        length    = self.gen_array_length(ptr)
        i_ptr = self.alloca(int_type, name="show_arr_i")
        self.builder.store(ir.Constant(int_type, 0), i_ptr)
        check_block = func.append_basic_block("show_arr_check")
        body_block  = func.append_basic_block("show_arr_body")
        end_block   = func.append_basic_block("show_arr_end")
        self.builder.branch(check_block)
        self.builder.position_at_end(check_block)
        i_val = self.builder.load(i_ptr)
        cond  = self.builder.icmp_signed("<", i_val, length)
        self.builder.cbranch(cond, body_block, end_block)
        self.builder.position_at_end(body_block)
        self.print_text("[", "str_arr_lb")
        self.print_int_fmt(i_val, "%lld", "fmt_arr_idx")
        self.print_text("]: ", "str_arr_colon")
        data_ptr = self.gen_array_data_ptr(ptr)
        ep       = self.gen_array_elem_ptr_from_data(data_ptr, i_val)
        raw      = self.builder.load(ep)
        elem_val = self._i64_to_elem(raw, elem_type)
        if elem_type == float_type:
            self.gen_show_double(elem_val)
            self.print_text("\n", "str_newline")
        elif elem_type == STRING_TYPE:
            self.print_string_fmt(elem_val, "fmt_string")
        else:
            self.print_int_fmt(elem_val, "%lld\n\0", "fmt_int")
        next_i = self.builder.add(i_val, ir.Constant(int_type, 1))
        self.builder.store(next_i, i_ptr)
        self.builder.branch(check_block)
        self.builder.position_at_end(end_block)

    # ------------------------------------------------------------------
    # generate / gen_function
    # ------------------------------------------------------------------

    def generate(self, statements):
        thing_nodes     = [s for s in statements if isinstance(s, ThingNode)]
        fun_nodes       = [s for s in statements if isinstance(s, FunNode)]
        main_statements = [s for s in statements if not isinstance(s, (FunNode, ThingNode))]

        for thing in thing_nodes:
            self.gen_thing(thing)

        fn_param_types = {}
        for fn in fun_nodes:
            fn_param_types[fn.name] = [
                TYPE_NAMES.get(t, int_type) for t in fn.param_types
            ]

        fn_return_types = {fn.name: int_type for fn in fun_nodes}
        for _ in range(2):
            for fn in fun_nodes:
                fn_return_types[fn.name] = self.infer_function_return_type(
                    fn, fn_param_types[fn.name], fn_return_types)

        for fn in fun_nodes:
            fn_ty   = ir.FunctionType(fn_return_types[fn.name], fn_param_types[fn.name])
            ir_func = ir.Function(self.module, fn_ty, name=fn.name)
            self.functions[fn.name] = ir_func

        for fn in fun_nodes:
            self.gen_function(fn)

        main_ty   = ir.FunctionType(ir.IntType(32), [])
        main_func = ir.Function(self.module, main_ty, name="main")
        block     = main_func.append_basic_block(name="entry")
        self.builder = ir.IRBuilder(block)
        self.vars = {}

        self.gen_arena_init()

        for stmt in main_statements:
            self.gen_statement(stmt)

        if not self.builder.block.is_terminated:
            self.gen_arena_shutdown()
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
        if isinstance(t, ir.VectorType):
            return ir.Constant(t, [ir.Constant(float_type, 0.0)] * t.count)
        if t == MAT4_TYPE:
            return ir.Constant(MAT4_TYPE, [self.zero_value(VECTOR_TYPES["vec4"])] * 4)
        return ir.Constant(t, 0)

    # ------------------------------------------------------------------
    # Type inference
    # ------------------------------------------------------------------

    def infer_function_return_type(self, fn, param_types, fn_return_types):
        type_env = dict(zip(fn.params, param_types))
        result   = self.infer_walk(fn.body, type_env, fn_return_types)
        return result if result is not None else int_type

    def infer_walk(self, body, type_env, fn_return_types):
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

    # ------------------------------------------------------------------
    # Statements
    # ------------------------------------------------------------------

    def gen_statement(self, node):
        if isinstance(node, LetNode):
            self._pending_array_elem_type = None
            value = self.gen_expr(node.value)
            ptr = self.alloca(value.type, name=node.name)
            self.builder.store(value, ptr)
            self.vars[node.name] = ptr
            if self._pending_array_elem_type is not None:
                self.var_array_elem_types[node.name] = self._pending_array_elem_type
                self._pending_array_elem_type = None
            if isinstance(node.value, CallNode) and node.value.name in self.things:
                self.var_thing_types[node.name] = node.value.name

        elif isinstance(node, AssignNode):
            ptr = self.vars.get(node.name)
            if ptr is None:
                raise Exception(f"Cannot assign to undeclared variable: '{node.name}' — use 'let {node.name} be ...' first")
            value = self.gen_expr(node.value)
            self.builder.store(value, ptr)

        elif isinstance(node, FieldAssignNode):
            ptr = self.vars.get(node.name)
            if ptr is None:
                raise Exception(f"Cannot assign to undeclared variable: '{node.name}' — use 'let {node.name} be ...' first")
            info, idx  = self.get_field_index(node.name, node.field)
            value      = self.coerce_to(self.gen_expr(node.value), info["field_types"][idx])
            struct_val = self.builder.load(ptr, name=node.name)
            struct_val = self.builder.insert_value(struct_val, value, idx)
            self.builder.store(struct_val, ptr)

        elif isinstance(node, IndexAssignNode):
            self.gen_array_index_assign(node)

        elif isinstance(node, MethodCallNode):
            self.gen_method_call(node)

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
            self.gen_expr(node)

    # ------------------------------------------------------------------
    # Print helpers
    # ------------------------------------------------------------------

    DECIMAL_PLACES = 4
    DECIMAL_SCALE  = 10 ** DECIMAL_PLACES

    def get_global_string(self, text, name):
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
        ptr = self.get_global_string(text, name)
        self.builder.call(self.printf, [ptr])
        self.flush_stdout()

    def print_int_fmt(self, value, fmt, name):
        ptr = self.get_global_string(fmt, name)
        self.builder.call(self.printf, [ptr, value])
        self.flush_stdout()

    def print_string_fmt(self, value, name):
        ptr = self.get_global_string("%s\n", name)
        self.builder.call(self.printf, [ptr, value])
        self.flush_stdout()

    def gen_string_literal(self, node):
        if node.value not in self.string_literals:
            self.string_literals[node.value] = f"str_lit_{len(self.string_literals)}"
        name = self.string_literals[node.value]
        return self.get_global_string(node.value, name)

    def gen_show(self, node):
        if isinstance(node.value, IdentifierNode):
            arr_name = node.value.name
            if arr_name in self.var_array_elem_types:
                self.gen_show_array(arr_name)
                return

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
        if value.type == STRING_TYPE:
            self.print_string_fmt(value, "fmt_string")
            return
        self.print_int_fmt(value, "%lld\n\0", "fmt_int")

    def gen_show_vector(self, value):
        size = value.type.count
        self.print_text("(", "str_lparen")
        for i in range(size):
            comp = self.builder.extract_element(value, ir.Constant(ir.IntType(32), i))
            self.gen_show_double(comp)
            if i < size - 1:
                self.print_text(", ", "str_comma_space")
        self.print_text(")\n", "str_rparen_nl")

    def gen_show_double(self, value):
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

        scale_const = ir.Constant(int_type, self.DECIMAL_SCALE)
        overflow = self.builder.icmp_signed(">=", scaled, scale_const)
        int_part = self.builder.select(overflow, self.builder.add(int_part, ir.Constant(int_type, 1)), int_part)
        scaled   = self.builder.select(overflow, ir.Constant(int_type, 0), scaled)

        self.print_int_fmt(int_part, "%lld\0", "fmt_int_plain")
        self.print_text(".", "str_dot")
        self.print_int_fmt(scaled, f"%0{self.DECIMAL_PLACES}lld\0", "fmt_frac")

    # ------------------------------------------------------------------
    # Control flow
    # ------------------------------------------------------------------

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
        var_ptr   = self.alloca(int_type, name=node.var_name)
        start_val = self.gen_expr(node.start)
        self.builder.store(start_val, var_ptr)
        self.vars[node.var_name] = var_ptr
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

    # ------------------------------------------------------------------
    # Expressions
    # ------------------------------------------------------------------

    def promote_to_common_type(self, left, right):
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
        if left.type == STRING_TYPE or right.type == STRING_TYPE:
            raise Exception("Comparing strings with is/is not/>/< etc. isn't supported yet")
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

        elif isinstance(node, StringNode):
            return self.gen_string_literal(node)

        elif isinstance(node, IdentifierNode):
            ptr = self.vars.get(node.name)
            if ptr is None:
                raise Exception(f"Unknown variable: {node.name}")
            return self.builder.load(ptr, name=node.name)

        elif isinstance(node, ArrayLiteralNode):
            return self.gen_array_literal(node)

        elif isinstance(node, IndexAccessNode):
            return self.gen_array_index_access(node)

        elif isinstance(node, MethodCallNode):
            return self.gen_method_call(node)

        elif isinstance(node, FieldAccessNode):
            return self.gen_field_access(node)

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
            if left.type == STRING_TYPE or right.type == STRING_TYPE:
                raise Exception("Strings don't support [+ - * /] yet")
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
            if node.name in self.things:
                return self.gen_thing_constructor(node)
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
            if node.name == "arena_alloc":
                return self.gen_arena_alloc(node)
            if node.name == "arena_reset":
                return self.gen_arena_reset(node)
            if node.name == "peek_i64":
                return self.gen_peek_i64(node)
            if node.name == "poke_i64":
                return self.gen_poke_i64(node)
            func = self.functions.get(node.name)
            if func is None:
                raise Exception(f"Unknown function: '{node.name}'")
            if len(node.args) != len(func.args):
                raise Exception(f"Function '{node.name}' expects {len(func.args)} argument(s), got {len(node.args)}")
            arg_vals = [self.coerce_to(self.gen_expr(arg), param.type)
                        for arg, param in zip(node.args, func.args)]
            return self.builder.call(func, arg_vals)

    def coerce_to(self, value, target_type):
        if value.type == target_type:
            return value
        if value.type == int_type and target_type == float_type:
            return self.builder.sitofp(value, float_type)
        if value.type == float_type and target_type == int_type:
            return self.builder.fptosi(value, int_type)
        raise Exception(f"Type mismatch: got {value.type}, expected {target_type}")

    def to_float(self, value):
        if value.type == int_type:
            return self.builder.sitofp(value, float_type)
        if value.type == float_type:
            return value
        raise Exception(f"Expected a number, got {value.type}")

    # ------------------------------------------------------------------
    # Vector / mat4
    # ------------------------------------------------------------------

    def gen_vector_constructor(self, node):
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
        if scalar.type == int_type:
            scalar = self.builder.sitofp(scalar, float_type)
        elif scalar.type != float_type:
            raise Exception(f"Cannot use {scalar.type} as a vector component")
        result = ir.Constant(vtype, ir.Undefined)
        for i in range(vtype.count):
            result = self.builder.insert_element(result, scalar, ir.Constant(ir.IntType(32), i))
        return result

    def gen_vector_binop(self, left, right, op):
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

    def identity_mat4_constant(self):
        rows = []
        for i in range(4):
            comps = [ir.Constant(float_type, 1.0 if i == j else 0.0) for j in range(4)]
            rows.append(ir.Constant(VECTOR_TYPES["vec4"], comps))
        return ir.Constant(MAT4_TYPE, rows)

    def gen_mat4_constructor(self, node):
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
        if len(node.args) != 0:
            raise Exception("mat4_identity() takes no arguments")
        return self.identity_mat4_constant()

    def gen_mat4_translate(self, node):
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
        angle = self.to_float(angle)
        s = self.builder.call(self.llvm_sin, [angle])
        c = self.builder.call(self.llvm_cos, [angle])
        return s, c

    def build_mat4_from_rows(self, rows):
        result = ir.Constant(MAT4_TYPE, ir.Undefined)
        for i, row_vals in enumerate(rows):
            row = ir.Constant(VECTOR_TYPES["vec4"], ir.Undefined)
            for j, val in enumerate(row_vals):
                row = self.builder.insert_element(row, val, ir.Constant(ir.IntType(32), j))
            result = self.builder.insert_value(result, row, i)
        return result

    def gen_mat4_rotate_x(self, node):
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
        prod  = self.builder.fmul(a, b)
        size  = a.type.count
        total = self.builder.extract_element(prod, ir.Constant(ir.IntType(32), 0))
        for i in range(1, size):
            comp  = self.builder.extract_element(prod, ir.Constant(ir.IntType(32), i))
            total = self.builder.fadd(total, comp)
        return total

    def gen_mat4_vec_mul(self, m, v):
        result = ir.Constant(VECTOR_TYPES["vec4"], ir.Undefined)
        for i in range(4):
            row = self.builder.extract_value(m, i)
            d   = self.gen_dot(row, v)
            result = self.builder.insert_element(result, d, ir.Constant(ir.IntType(32), i))
        return result

    def gen_mat4_mat_mul(self, m1, m2):
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