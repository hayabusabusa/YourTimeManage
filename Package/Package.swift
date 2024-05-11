// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Package",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "AppFeature",
            targets: ["AppFeature"]),
        .library(
            name: "FirebaseClient",
            targets: ["FirebaseClient"]),
        .library(
            name: "FirebaseClientLive",
            targets: ["FirebaseClientLive"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            from: "10.25.0"),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            from: "1.10.3"),
        .package(
            url: "https://github.com/pointfreeco/swift-dependencies",
            from: "1.3.0"),
    ],
    targets: [
        .target(
            name: "AppFeature",
            dependencies: [
                "FirebaseClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]),
        .target(
            name: "FirebaseClient",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
            ]),
        .target(
            name: "FirebaseClientLive",
            dependencies: [
                "FirebaseClient",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
            ]),
        .testTarget(
            name: "PackageTests",
            dependencies: []),
    ]
)
