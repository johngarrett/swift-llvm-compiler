// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "llvm-swift-compiler",
    products: [
        .executable(
            name: "llvm-swift-compiler",
            targets: ["llvm-swift-compiler"]
        ),
    ],
    targets: [
        .target(name: "llvm-swift-compiler"),
        .testTarget(
            name: "llvm-swift-compilerTests",
            dependencies: ["llvm-swift-compiler"]),
    ]
)
