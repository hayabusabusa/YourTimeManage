// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Package",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "Package", targets: ["Package"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Package",
            dependencies: []),
        .testTarget(
            name: "PackageTests",
            dependencies: ["Package"]),
    ]
)
