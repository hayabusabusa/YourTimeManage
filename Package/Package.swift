// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Package",
    platforms: [.iOS(.v26)],
    products: [
        .library(
            name: "AuthClient",
            targets: ["AuthClient"]
        ),
        .library(
            name: "AuthClientLive",
            targets: ["AuthClientLive"]
        ),
        .library(
            name: "AppFeature",
            targets: ["AppFeature"]
        ),
        .library(
            name: "FirebaseClient",
            targets: ["FirebaseClient"]
        ),
        .library(
            name: "FirebaseClientLive",
            targets: ["FirebaseClientLive"]
        ),
        .library(
            name: "FirestoreClient",
            targets: ["FirestoreClient"]
        ),
        .library(
            name: "FirestoreClientLive",
            targets: ["FirestoreClientLive"]
        ),
        .library(
            name: "GoogleAdsView",
            targets: ["GoogleAdsView"]
        ),
        .library(
            name: "SharedModels",
            targets: ["SharedModels"]
        ),
        .library(
            name: "TimerFeature",
            targets: ["TimerFeature"]
        ),
        .library(
            name: "UserDefaultsClient",
            targets: ["UserDefaultsClient"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            from: "12.6.0"
        ),
        .package(
            url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git",
            from: "12.14.0"
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-dependencies",
            from: "1.10.0"
        ),
    ],
    targets: [
        .target(
            name: "AuthClient",
            dependencies: [
                "SharedModels",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
            ]
        ),
        .target(
            name: "AuthClientLive",
            dependencies: [
                "AuthClient",
                "SharedModels",
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "Dependencies", package: "swift-dependencies"),
            ],
        ),
        .target(
            name: "AppFeature",
            dependencies: [
                "FirebaseClient",
                .product(name: "Dependencies", package: "swift-dependencies"),
            ]
        ),
        .target(
            name: "FirebaseClient",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
            ],
        ),
        .target(
            name: "FirebaseClientLive",
            dependencies: [
                "FirebaseClient",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads"),
            ],
        ),
        .target(
            name: "FirestoreClient",
            dependencies: [
                "SharedModels",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
            ],
        ),
        .target(
            name: "FirestoreClientLive",
            dependencies: [
                "FirestoreClient",
                "SharedModels",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
            ],
        ),
        .target(
            name: "GoogleAdsView",
            dependencies: [
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads"),
            ]
        ),
        .target(
            name: "SharedModels"
        ),
        .target(
            name: "TimerFeature",
            dependencies: [
                "SharedModels",
                "UserDefaultsClient",
                .product(name: "Dependencies", package: "swift-dependencies"),
            ],
        ),
        .target(
            name: "UserDefaultsClient",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
            ],
        ),
        .testTarget(
            name: "PackageTests",
            dependencies: ["AppFeature"]
        ),
    ]
)
