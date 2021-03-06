#if os(macOS)
import Darwin
#elseif os(Linux)
import Glibc
#endif
/*
Goal: deconstruct source text into a list of type enum Token
 
 input: def foo(n) (n * 100.34);
 output:
 [
    .def,
    .identifier("foo"),  // ?
    .leftParen,
    .identifier("n"),
    .rightParen,
    .leftParen,
    .identifier("n"),
    .operator(.multiply),
    .number(100.34),
    .rightParen,
    .semicolon
 ]
 
 */
extension Character {
    var value: Int32 {
        Int32(String(self).unicodeScalars.first!.value)
    }
    
    var isSpace: Bool {
        isspace(value) != 0
    }
    
    var isAlphaNumeric: Bool {
        isalnum(value) != 0 || self == "_"
    }
}
class Lexer {
    let input: String
    var index: String.Index
    
    init(on input: String) {
        self.input = input
        self.index = input.startIndex
    }
    
    var currentChar: Character? {
        index < input.endIndex ? input[index] : nil
    }
    
    func advanceIndex() {
        input.formIndex(after: &index)
    }
    
    func readIdentifierOrNumber() -> String {
        var str = ""
        // go until a non alphanumeric or decimal value is hit
        while let char = currentChar, char.isAlphaNumeric || char == "." {
            str.append(char)
            advanceIndex()
        }
        return str
    }
    
    func lex() -> [Token] {
        var toks = [Token]()
        while let tok = advanceToNextToken() {
            toks.append(tok)
        }
        return toks
    }
    
    func advanceToNextToken() -> Token? {
        // skip white space
        while let char = currentChar, char.isSpace {
            advanceIndex()
        }
        
        // end of input
        guard let char = currentChar else {
            return nil
        }
        
        if let opr = BinaryOperator(char) {
            advanceIndex()
            return .operator(opr)
        } else if let tok = Token(char) {
            advanceIndex()
            return tok
        }

        // else, we need to parse an identifier
        return char.isAlphaNumeric ? Token(readIdentifierOrNumber()): nil
    }
}
