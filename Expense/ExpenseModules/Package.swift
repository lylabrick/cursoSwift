// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "ExpenseTracker",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "ExpenseCore", targets: ["ExpenseCore"]),
        .library(name: "ExpenseUI", targets: ["ExpenseUI"])
    ],
    targets: [
        .target(name: "ExpenseCore"),
        .target(name: "ExpenseUI", dependencies: ["ExpenseCore"])
    ]
)
