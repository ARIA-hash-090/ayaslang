from tokens import TokenType

class NumberNode:
    def __init__(self, value):
        self.value = value
    def __repr__(self):
        return f"Number({self.value})"

class FloatNode:
    def __init__(self, value):
        self.value = value
    def __repr__(self):
        return f"Float({self.value})"

class StringNode:
    def __init__(self, value):
        self.value = value
    def __repr__(self):
        return f"String({self.value})"

class IdentifierNode:
    def __init__(self, name):
        self.name = name
    def __repr__(self):
        return f"Identifier({self.name})"

class LetNode:
    def __init__(self, name, value):
        self.name  = name
        self.value = value
    def __repr__(self):
        return f"Let({self.name} = {self.value})"

class AssignNode:
    def __init__(self, name, value):
        self.name  = name
        self.value = value
    def __repr__(self):
        return f"Assign({self.name} = {self.value})"

class ShowNode:
    def __init__(self, value):
        self.value = value
    def __repr__(self):
        return f"Show({self.value})"

class UnaryOpNode:
    def __init__(self, op, operand):
        self.op      = op
        self.operand = operand
    def __repr__(self):
        return f"UnaryOp({self.op}{self.operand})"

class BinaryOpNode:
    def __init__(self, left, op, right):
        self.left  = left
        self.op    = op
        self.right = right
    def __repr__(self):
        return f"BinaryOp({self.left} {self.op} {self.right})"

class CompareNode:
    def __init__(self, left, op, right):
        self.left  = left
        self.op    = op
        self.right = right
    def __repr__(self):
        return f"Compare({self.left} {self.op} {self.right})"

class WhenNode:
    def __init__(self, branches, otherwise):
        self.branches  = branches
        self.otherwise = otherwise
    def __repr__(self):
        return f"When({len(self.branches)} branches)"

class RepeatTimesNode:
    def __init__(self, count, body):
        self.count = count
        self.body  = body
    def __repr__(self):
        return f"RepeatTimes({self.count}, {len(self.body)} statements)"

class RepeatInNode:
    def __init__(self, var_name, start, end, body):
        self.var_name = var_name
        self.start    = start
        self.end      = end
        self.body     = body
    def __repr__(self):
        return f"RepeatIn({self.var_name} in [{self.start} to {self.end}], {len(self.body)} statements)"

class FunNode:
    def __init__(self, name, params, param_types, body):
        self.name        = name
        self.params      = params
        self.param_types = param_types  # parallel list: type name string or None
        self.body        = body
    def __repr__(self):
        return f"Fun({self.name}({', '.join(self.params)}), {len(self.body)} statements)"

class CallNode:
    def __init__(self, name, args):
        self.name = name
        self.args = args
    def __repr__(self):
        return f"Call({self.name}, {self.args})"

class GiveBackNode:
    def __init__(self, value):
        self.value = value
    def __repr__(self):
        return f"GiveBack({self.value})"


class Parser:
    def __init__(self, tokens):
        self.tokens = tokens
        self.pos    = 0

    def current(self):
        return self.tokens[self.pos]

    def peek(self):
        if self.pos + 1 < len(self.tokens):
            return self.tokens[self.pos + 1]
        return None

    def advance(self):
        token = self.tokens[self.pos]
        self.pos += 1
        return token

    def skip_newlines(self):
        while self.current().type == TokenType.NEWLINE:
            self.advance()

    def expect(self, type):
        token = self.current()
        if token.type != type:
            raise Exception(f"Expected {type} but got {token.type} on line {token.line}")
        return self.advance()

    def parse(self):
        statements = []
        while self.current().type != TokenType.EOF:
            self.skip_newlines()
            if self.current().type == TokenType.EOF:
                break
            stmt = self.parse_statement()
            if stmt:
                statements.append(stmt)
        return statements

    def parse_statement(self):
        token = self.current()
        if token.type == TokenType.LET:
            return self.parse_let()
        elif token.type == TokenType.IDENTIFIER and self.peek() and self.peek().type == TokenType.BE:
            return self.parse_assign()
        elif token.type == TokenType.IDENTIFIER and self.peek() and self.peek().type == TokenType.LPAREN:
            name = self.advance().value
            return self.parse_call(name)
        elif token.type in (TokenType.SHOW, TokenType.DISP):
            return self.parse_show()
        elif token.type == TokenType.WHEN:
            return self.parse_when()
        elif token.type == TokenType.REPEAT:
            return self.parse_repeat()
        elif token.type == TokenType.FUN:
            return self.parse_fun()
        elif token.type == TokenType.GIVE:
            return self.parse_give_back()
        else:
            raise Exception(f"Unexpected token {token.type} on line {token.line}")

    def parse_let(self):
        self.expect(TokenType.LET)
        name = self.expect(TokenType.IDENTIFIER).value
        self.expect(TokenType.BE)
        value = self.parse_expression()
        return LetNode(name, value)

    def parse_assign(self):
        name = self.expect(TokenType.IDENTIFIER).value
        self.expect(TokenType.BE)
        value = self.parse_expression()
        return AssignNode(name, value)

    def parse_show(self):
        self.advance()
        value = self.parse_expression()
        return ShowNode(value)

    def parse_when(self):
        branches  = []
        otherwise = None

        self.expect(TokenType.WHEN)
        condition = self.parse_condition()
        body      = self.parse_block()
        branches.append((condition, body))

        while True:
            self.skip_newlines()
            if self.current().type == TokenType.RATHER:
                self.advance()
                self.expect(TokenType.WHEN)
                condition = self.parse_condition()
                body      = self.parse_block()
                branches.append((condition, body))
            else:
                break

        self.skip_newlines()
        if self.current().type == TokenType.OTHERWISE:
            self.advance()
            otherwise = self.parse_block()

        return WhenNode(branches, otherwise)

    def parse_repeat(self):
        self.expect(TokenType.REPEAT)

        if self.current().type == TokenType.NUMBER and self.peek() and self.peek().type == TokenType.TIMES:
            count = self.advance().value
            self.expect(TokenType.TIMES)
            body = self.parse_block()
            return RepeatTimesNode(count, body)

        if self.current().type == TokenType.IDENTIFIER and self.peek() and self.peek().type == TokenType.IN:
            var_name = self.advance().value
            self.expect(TokenType.IN)
            self.expect(TokenType.LBRACKET)
            start = self.parse_primary()
            self.expect(TokenType.TO)
            end = self.parse_primary()
            self.expect(TokenType.RBRACKET)
            body = self.parse_block()
            return RepeatInNode(var_name, start, end, body)

        raise Exception(f"Unsupported 'repeat' form on line {self.current().line} (expected 'repeat <number> times' or 'repeat <name> in [<start> to <end>]')")

    def parse_fun(self):
        self.expect(TokenType.FUN)
        name = self.expect(TokenType.IDENTIFIER).value
        self.expect(TokenType.LPAREN)

        params      = []
        param_types = []
        if self.current().type != TokenType.RPAREN:
            params.append(self.expect(TokenType.IDENTIFIER).value)
            param_types.append(self.parse_optional_type())
            while self.current().type == TokenType.COMMA:
                self.advance()
                params.append(self.expect(TokenType.IDENTIFIER).value)
                param_types.append(self.parse_optional_type())

        self.expect(TokenType.RPAREN)
        body = self.parse_block()
        return FunNode(name, params, param_types, body)

    def parse_optional_type(self):
        """Parses an optional ': vec3' / ': float' etc. after a parameter
        name. Returns the type name as a string, or None if there's no
        annotation (in which case the parameter defaults to a number)."""
        if self.current().type == TokenType.COLON:
            self.advance()
            return self.expect(TokenType.IDENTIFIER).value
        return None

    def parse_call(self, name):
        self.expect(TokenType.LPAREN)

        args = []
        if self.current().type != TokenType.RPAREN:
            args.append(self.parse_expression())
            while self.current().type == TokenType.COMMA:
                self.advance()
                args.append(self.parse_expression())

        self.expect(TokenType.RPAREN)
        return CallNode(name, args)

    def parse_give_back(self):
        self.expect(TokenType.GIVE)
        self.expect(TokenType.BACK)
        value = self.parse_expression()
        return GiveBackNode(value)

    def parse_condition(self):
        self.expect(TokenType.LBRACKET)
        left  = self.parse_primary()
        op    = self.parse_compare_op()
        right = self.parse_primary()
        self.expect(TokenType.RBRACKET)
        return CompareNode(left, op, right)

    def parse_compare_op(self):
        token = self.current()
        if token.type == TokenType.IS:
            self.advance()
            if self.current().type == TokenType.NOT:
                self.advance()
                return "is not"
            return "is"
        elif token.type in (TokenType.GREATER, TokenType.LESS,
                            TokenType.GREATEREQUAL, TokenType.LESSEQUAL):
            self.advance()
            return token.value
        else:
            raise Exception(f"Expected comparison operator but got {token.type} on line {token.line}")

    def parse_block(self):
        statements = []
        self.skip_newlines()
        self.expect(TokenType.LBRACE)
        self.skip_newlines()
        while self.current().type not in (TokenType.RBRACE, TokenType.EOF):
            stmt = self.parse_statement()
            if stmt:
                statements.append(stmt)
            self.skip_newlines()
        self.expect(TokenType.RBRACE)
        return statements

    def parse_expression(self):
        if self.current().type == TokenType.LBRACKET:
            self.advance()
            left = self.parse_primary()
            if self.current().type == TokenType.RBRACKET:
                self.advance()
                return left
            op    = self.advance().value
            right = self.parse_primary()
            self.expect(TokenType.RBRACKET)
            return BinaryOpNode(left, op, right)
        return self.parse_primary()

    def parse_primary(self):
        token = self.current()
        if token.type == TokenType.MINUS:
            self.advance()
            operand = self.parse_primary()
            return UnaryOpNode("-", operand)
        elif token.type == TokenType.NUMBER:
            self.advance()
            return NumberNode(token.value)
        elif token.type == TokenType.FLOAT:
            self.advance()
            return FloatNode(token.value)
        elif token.type == TokenType.STRING:
            self.advance()
            return StringNode(token.value)
        elif token.type == TokenType.IDENTIFIER:
            self.advance()
            if self.current().type == TokenType.LPAREN:
                return self.parse_call(token.value)
            return IdentifierNode(token.value)
        else:
            raise Exception(f"Unexpected token {token.type} on line {token.line}")