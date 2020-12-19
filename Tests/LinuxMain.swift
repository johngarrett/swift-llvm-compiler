import XCTest

import llvm_swift_compilerTests

var tests = [XCTestCaseEntry]()
tests += llvm_swift_compilerTests.allTests()
XCTMain(tests)
