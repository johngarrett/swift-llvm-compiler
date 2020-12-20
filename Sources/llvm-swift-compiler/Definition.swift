/*
 
 A kaleidoscope function def has 2 parts:
    1. a prototype
    2. an expression
 */

struct Definition {
    let prototype: Prototype
    let expr: Expr
}

/*
def foo(a, b, c) 0;
 -> name = foo
 -> parameters = ["a", "b", "c"]
 
 */
struct Prototype {
    let name: String
    let params: [String]
}

/*
 expressions in Kaleidoscope:
    - Doubles
    - Variables
    - Binary operators
    - function calls
    - if-else
*/ 
// indirect b/c some cases are recusrive
indirect enum Expr {
    case number(Double)
    case variable(String)
    // two subexpressions and an operator
    case binary(Expr, BinaryOperator, Expr)
    // identifier(arguments) -> $0($1)
    case call(String, [Expr])
    // if $0 then $1 else $2
    case ifelse(Expr, Expr, Expr)
}
