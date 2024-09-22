// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

private let swiftSettings = [
    SwiftSetting.enableUpcomingFeature("StrictConcurrency")
]

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
            ],
            swiftSettings: swiftSettings),
        .target(
            name: "TimerFeature",
            dependencies: [
                "FirestoreClient",
                "SharedModels",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Dependencies", package: "swift-dependencies"),
            ],
            resources: [
                .process("Resources")
            ],
            swiftSettings: swiftSettings),

        // MARK: - Client
        .target(
            name: "AuthClient",
            dependencies: [
                "SharedModels",
                .product(name: "Dependencies", package: "swift-dependencies"),
            ],
            swiftSettings: swiftSettings),
        .target(
            name: "AuthClientLive",
            dependencies: [
                "AuthClient",
                "SharedModels",
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
            ],
            swiftSettings: swiftSettings),
        .target(
            name: "FirebaseClient",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
            ],
            swiftSettings: swiftSettings),
        .target(
            name: "FirebaseClientLive",
            dependencies: [
                "FirebaseClient",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
            ],
            swiftSettings: swiftSettings),
        .target(
            name: "FirestoreClient",
            dependencies: [
                "SharedModels",
                .product(name: "Dependencies", package: "swift-dependencies"),
            ],
            swiftSettings: swiftSettings),
        .target(
            name: "FirestoreClientLive",
            dependencies: [
                "FirestoreClient",
                "SharedModels",
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestoreSwift", package: "firebase-ios-sdk"),
            ],
            swiftSettings: swiftSettings),
        .target(
            name: "SharedModels",
            swiftSettings: swiftSettings),

        // MARK: - Tests
        .testTarget(
            name: "PackageTests",
            dependencies: []),
    ]
)
