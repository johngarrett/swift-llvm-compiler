import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(llvm_swift_compilerTests.allTests),
    ]
}
#endif
