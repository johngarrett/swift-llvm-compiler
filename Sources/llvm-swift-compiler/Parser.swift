#if os(macOS)
import Darwin
#elseif os(Linux)
import Glibc
#endif

enum ParseError: Error {
    case unexpectedToken(Token)
    case unexpectedEOF
}
class Parser {
    let tokens: [Token]
    var index = 0
    
    init(tokens: [Token]) {
        self.tokens = tokens
    }
    
    var currentToken: Token? {
        return index < tokens.count ? tokens[index]: nil
    }
    
    func consumeToken(n: Int = 1) {
        index += n
    }
    
    func advance() {
        index += 1
    }
    
    func consume(_ token: Token) throws {
        guard let tok = currentToken else {
            throw ParseError.unexpectedEOF
        }
        
        guard token == tok else {
            throw ParseError.unexpectedToken(token)
        }
        
        consumeToken()
    }
    
    /// Eats the specified token if it's the currentToken
    /// else: thows an error
    func parse(_ token: Token) throws {
        guard let tok = currentToken else {
            throw ParseError.unexpectedEOF
        }
        guard token == tok else {
            throw ParseError.unexpectedToken(token)
        }
        consumeToken()
    }
    /*
     parse the current token as a single idenfitifer (base case)
     throws an error if it's not an .identifier
     */
    func parseIdentifier() throws -> String {
        guard let token = currentToken else {
            throw ParseError.unexpectedEOF
        }
        guard case .identifier(let name) = token else {
            throw ParseError.unexpectedToken(token)
        }
        consumeToken() // advance the cursor
        return name // return name
    }
    
    /*
     parser for prototypes
     
     we want to parse:
        - a single identifier
        - a left paren -> identites + commas -> right paren
     */
    func parseCommaSeparated<TermType>(_ parseFn: () throws -> TermType) throws -> [TermType] {
        // START: (
        try parse(.leftParen)
        var vals = [TermType]()
        // MIDDLE: . . .
        while let tok = currentToken, tok != .rightParen {
            let val = try parseFn()
            if case .comma? = currentToken {
                try parse(.comma)
            }
            vals.append(val)
        }
        // LAST: )
        try parse(.rightParen)
        return vals
    }
    
    func parseExpr() throws -> Expr {
        guard let token = currentToken else {
            throw ParseError.unexpectedEOF
        }
        var expr: Expr
        switch token {
        case .leftParen: // ( <expr> )
            consumeToken()
            expr = try parseExpr()
            try consume(.rightParen)
        case .number(let value):
            consumeToken()
            expr = .number(value)
        case .identifier(let value):
            consumeToken()
            if case .leftParen? = currentToken {
                let params = try parseCommaSeparated(parseExpr)
                expr = .call(value, params)
            } else {
                expr = .variable(value)
            }
        case .if: // if <expr> then <expr> else <expr>
            consumeToken()
            let cond = try parseExpr()
            try consume(.then)
            let thenVal = try parseExpr()
            try consume(.else)
            let elseVal = try parseExpr()
            expr = .ifelse(cond, thenVal, elseVal)
        default:
            throw ParseError.unexpectedToken(token)
        }

        if case .operator(let op)? = currentToken {
            consumeToken()
            let rhs = try parseExpr()
            print("""
                case was .operator after switch
                    expr: \(expr)
                    op: \(op)
                    rhs: \(rhs)
                """
            )

            expr = .binary(expr, op, rhs)
            print("expr is now: \(expr)")
        }

        return expr
    }
    
    /*
     parsing an extern C function
     */
    func parseExtern() throws -> Prototype {
        try parse(.extern)
        let proto = try parsePrototype()
        try parse(.semicolon)
        return proto
    }
    
    func parsePrototype() throws -> Prototype {
        let name = try parseIdentifier()
        // parse comma seperated values with the parseIdentifier funciton
        let params = try parseCommaSeparated(parseIdentifier)
        return Prototype(name: name, params: params)
    }
    
    /*
     function defs include:
        1. a prototype
        2. an expression for the body
     */
    func parseDefinition() throws -> Definition {
        try parse(.def)
        let prototype = try parsePrototype()
        let expr = try parseExpr()
        let def = Definition(prototype: prototype, expr: expr)
        try parse(.semicolon)
        return def
    }
    
    func parseFile() throws -> File {
        let file = File()
        while let tok = currentToken {
            switch tok {
            case .extern:
                file.addExtern(try parseExtern())
            case .def:
                file.addDefinition(try parseDefinition())
            default:
                let expr = try parseExpr()
                try consume(.semicolon)
                file.addExpression(expr)
            }
        }
        return file
    }
}
