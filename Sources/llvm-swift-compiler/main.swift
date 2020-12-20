let toks = Lexer(on: """
    extern sqrt(n);
    def foo(n) (n * sqrt(n * 200) + 57 * n % 2);
    """
).lex()
let file = try! Parser(tokens: toks).parseFile()
print(file)
