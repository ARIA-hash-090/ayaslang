from tokens import TokenType

class Token:
    def __init__(self, type, value, line):
        self.type  = type
        self.value = value
        self.line  = line

    def __repr__(self):
        return f"Token({self.type}, {self.value!r}, line={self.line})"


class Lexer:
    def __init__(self, source):
        self.source = source
        self.pos    = 0
        self.line   = 1
        self.tokens = []

    def current(self):
        if self.pos < len(self.source):
            return self.source[self.pos]
        return None

    def peek(self):
        if self.pos + 1 < len(self.source):
            return self.source[self.pos + 1]
        return None

    def advance(self):
        char = self.source[self.pos]
        self.pos += 1
        if char == "\n":
            self.line += 1
        return char

    def skip_whitespace(self):
        while self.current() in (" ", "\t", "\r"):
            self.advance()

    def read_number(self):
        """Reads an integer or float literal. Returns (text, is_float).

        A '.' is only consumed as a decimal point if it's followed by a
        digit — this keeps '.' available for other uses (e.g. field access)
        without ambiguity, since a bare trailing '.' never starts a number.
        """
        start = self.pos
        while self.current() and self.current().isdigit():
            self.advance()

        is_float = False
        if self.current() == "." and self.peek() and self.peek().isdigit():
            is_float = True
            self.advance()  # consume '.'
            while self.current() and self.current().isdigit():
                self.advance()

        return self.source[start:self.pos], is_float

    def read_string(self):
        self.advance()
        start = self.pos
        while self.current() and self.current() != '"':
            self.advance()
        value = self.source[start:self.pos]
        self.advance()
        return value

    def read_word(self):
        start = self.pos
        while self.current() and (self.current().isalnum() or self.current() == "_"):
            self.advance()
        return self.source[start:self.pos]

    KEYWORDS = {
        "let"       : TokenType.LET,
        "be"        : TokenType.BE,
        "fun"       : TokenType.FUN,
        "thing"     : TokenType.THING,
        "when"      : TokenType.WHEN,
        "rather"    : TokenType.RATHER,
        "otherwise" : TokenType.OTHERWISE,
        "repeat"    : TokenType.REPEAT,
        "in"        : TokenType.IN,
        "to"        : TokenType.TO,
        "times"     : TokenType.TIMES,
        "show"      : TokenType.SHOW,
        "disp"      : TokenType.DISP,
        "give"      : TokenType.GIVE,
        "back"      : TokenType.BACK,
        "is"        : TokenType.IS,
        "not"       : TokenType.NOT,
        "and"       : TokenType.AND,
        "or"        : TokenType.OR,
        "skill"     : TokenType.SKILL,
        "issue"     : TokenType.ISSUE,
        "true"      : TokenType.BOOL,
        "false"     : TokenType.BOOL,
    }

    def tokenize(self):
        while self.pos < len(self.source):
            self.skip_whitespace()
            char = self.current()
            if char is None:
                break
            elif char == "\n":
                self.tokens.append(Token(TokenType.NEWLINE, "\\n", self.line))
                self.advance()
            elif char.isdigit():
                value, is_float = self.read_number()
                if is_float:
                    self.tokens.append(Token(TokenType.FLOAT, value, self.line))
                else:
                    self.tokens.append(Token(TokenType.NUMBER, value, self.line))
            elif char == '"':
                value = self.read_string()
                self.tokens.append(Token(TokenType.STRING, value, self.line))
            elif char.isalpha() or char == "_":
                word = self.read_word()
                ttype = self.KEYWORDS.get(word, TokenType.IDENTIFIER)
                self.tokens.append(Token(ttype, word, self.line))
            elif char == ">" and self.peek() == "=":
                self.tokens.append(Token(TokenType.GREATEREQUAL, ">=", self.line))
                self.advance()
                self.advance()
            elif char == "<" and self.peek() == "=":
                self.tokens.append(Token(TokenType.LESSEQUAL, "<=", self.line))
                self.advance()
                self.advance()
            elif char == ">":
                self.tokens.append(Token(TokenType.GREATER, ">", self.line))
                self.advance()
            elif char == "<":
                self.tokens.append(Token(TokenType.LESS, "<", self.line))
                self.advance()
            elif char == "+":
                self.tokens.append(Token(TokenType.PLUS, "+", self.line))
                self.advance()
            elif char == "-":
                self.tokens.append(Token(TokenType.MINUS, "-", self.line))
                self.advance()
            elif char == "*":
                self.tokens.append(Token(TokenType.STAR, "*", self.line))
                self.advance()
            elif char == "/" and self.peek() == "/":
                while self.current() and self.current() != "\n":
                    self.advance()
            elif char == "/":
                self.tokens.append(Token(TokenType.SLASH, "/", self.line))
                self.advance()
            elif char == "[":
                self.tokens.append(Token(TokenType.LBRACKET, "[", self.line))
                self.advance()
            elif char == "]":
                self.tokens.append(Token(TokenType.RBRACKET, "]", self.line))
                self.advance()
            elif char == "{":
                self.tokens.append(Token(TokenType.LBRACE, "{", self.line))
                self.advance()
            elif char == "}":
                self.tokens.append(Token(TokenType.RBRACE, "}", self.line))
                self.advance()
            elif char == "(":
                self.tokens.append(Token(TokenType.LPAREN, "(", self.line))
                self.advance()
            elif char == ")":
                self.tokens.append(Token(TokenType.RPAREN, ")", self.line))
                self.advance()
            elif char == ",":
                self.tokens.append(Token(TokenType.COMMA, ",", self.line))
                self.advance()
            elif char == ":":
                self.tokens.append(Token(TokenType.COLON, ":", self.line))
                self.advance()
            elif char == ".":
                self.tokens.append(Token(TokenType.DOT, ".", self.line))
                self.advance()
            else:
                print(f"Unknown character '{char}' on line {self.line}")
                self.advance()

        self.tokens.append(Token(TokenType.EOF, None, self.line))
        return self.tokens