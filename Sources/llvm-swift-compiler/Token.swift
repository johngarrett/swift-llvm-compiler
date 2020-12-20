enum Token {
    case leftParen, rightParen, def, extern, comma, semicolon, `if`, then, `else`
    case identifier(String)
    case number(Double)
    case `operator`(BinaryOperator)
    
    static let singleTokMapping: [Character: Token] = [
        ",": .comma,
        "(": .leftParen,
        ")": .rightParen,
        ";": .semicolon,
        "+": .operator(.plus),
        "-": .operator(.minus),
        "/": .operator(.divide),
        "*": .operator(.times),
        "%": .operator(.mod),
        "=": .operator(.equals)
    ]
    
    init?(_ character: Character) {
        guard let token = Token.singleTokMapping[character] else {
            return nil
        }
        self = token
    }
    
    init(_ identifier: String) {
        self = {
            switch identifier {
            case "def": return .def
            case "extern": return .extern
            case "if": return .if
            case "then": return .then
            case "else": return .else
            default:
                guard let doubleValue = Double(identifier) else {
                    return .identifier(identifier)
                }
                return .number(doubleValue)
            }
        }()
    }
}
