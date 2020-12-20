class File {
    private(set) var externs = [Prototype]()
    private(set) var definitions = [Definition]()
    private(set) var expressions = [Expr]()
    private(set) var prototypeMap = [String: Prototype]()

    func prototype(name: String) -> Prototype? {
        return prototypeMap[name]
    }

    func addExpression(_ expression: Expr) {
        expressions.append(expression)
    }

    func addExtern(_ prototype: Prototype) {
        externs.append(prototype)
        prototypeMap[prototype.name] = prototype
    }

    func addDefinition(_ definition: Definition) {
        definitions.append(definition)
        prototypeMap[definition.prototype.name] = definition.prototype
    }
}
