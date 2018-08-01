// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BigNum",
    products: [
        .library(
            name: "BigNum",
            type: .dynamic,
            targets: ["BigNum"]),
    ],
    dependencies: [
      .package(
        url: "https://github.com/dankogai/swift-floatingpointmath.git", from:"0.1.0" 
      ),
      .package(
        url: "https://github.com/attaswift/BigInt.git", from:"3.1.0"
      )
    ],
    targets: [
        .target(
            name: "BigNum",
            dependencies: ["BigInt", "FloatingPointMath"]),
        .target(
            name: "BigNumRun",
            dependencies: ["BigNum"]),
        .testTarget(
            name: "BigNumTests",
            dependencies: ["BigNum"]),
    ]
)
