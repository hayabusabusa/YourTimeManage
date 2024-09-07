// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Package",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "AppFeature",
            targets: ["AppFeature"]),
        .library(
            name: "AuthClient",
            targets: ["AuthClient"]),
        .library(
            name: "AuthClientLive",
            targets: ["AuthClientLive"]),
        .library(
            name: "FirebaseClient",
            targets: ["FirebaseClient"]),
        .library(
            name: "FirebaseClientLive",
            targets: ["FirebaseClientLive"]),
        .library(
            name: "FirestoreClient",
            targets: ["FirestoreClient"]),
        .library(
            name: "FirestoreClientLive",
            targets: ["FirestoreClientLive"]),
        .library(
            name: "SharedModels",
            targets: [
                "SharedModels"
            ]),
        .library(
            name: "TimerFeature",
            targets: [
                "TimerFeature"
            ])
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
        // MARK: - Feature
        .target(
            name: "AppFeature",
            dependencies: [
                "FirebaseClient",
                "TimerFeature",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]),
        .target(
            name: "TimerFeature",
            dependencies: [
                "SharedModels",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Dependencies", package: "swift-dependencies"),
            ],
            resources: [
                .process("Resources")
            ]),

        // MARK: - Client
        .target(
            name: "AuthClient",
            dependencies: [
                "SharedModels",
                .product(name: "Dependencies", package: "swift-dependencies"),
            ]),
        .target(
            name: "AuthClientLive",
            dependencies: [
                "AuthClient",
                "SharedModels",
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
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
        .target(
            name: "FirestoreClient",
            dependencies: [
                "SharedModels",
                .product(name: "Dependencies", package: "swift-dependencies"),
            ]),
        .target(
            name: "FirestoreClientLive",
            dependencies: [
                "FirestoreClient",
                "SharedModels",
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestoreSwift", package: "firebase-ios-sdk"),
            ]),
        .target(
            name: "SharedModels"),

        // MARK: - Tests
        .testTarget(
            name: "PackageTests",
            dependencies: []),
    ]
)
