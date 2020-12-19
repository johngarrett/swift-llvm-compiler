enum Token {
    case leftParen, rightParen, def, extern, comma, semicolon, `if`, then, `else`
    case identifier(String)
    case number(Double)
    case `operator`(BinaryOperator)
}
