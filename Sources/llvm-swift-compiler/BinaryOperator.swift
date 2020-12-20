enum BinaryOperator: Character, CaseIterable {
    case plus = "+"
    case minus = "-"
    case times = "*"
    case divide = "/"
    case mod = "%"
    case equals = "="
    
    init?(_ character: Character) {
        guard let `operator` = BinaryOperator.allCases.first(where: { $0.rawValue == character }) else {
            return nil
        }
        self = `operator`
    }
}
