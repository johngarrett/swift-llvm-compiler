print("hello world!")

let toks = Lexer(input: "def foo(n) (n * 100.35);").lex()

print(toks)
