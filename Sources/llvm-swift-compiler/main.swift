print("hello world!")

let toks = Lexer(on: "def foo(n) (n * 100.35);").lex()

print(toks)
