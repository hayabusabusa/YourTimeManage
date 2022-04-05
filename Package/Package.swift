// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Package",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "AppFeature",
            targets: [
                "AppFeature"
            ]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/danielgindi/Charts.git", from: "4.0.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "8.14.0"),
    ],
    targets: [
        // MARK: Feature modules
        
        .target(
            name: "AppFeature",
            dependencies: [
                "Core",
                "Domain",
                "UIComponent"
            ]
        ),
        
        // MARK: Internal modules
        
        .target(
            name: "Core",
            dependencies: []
        ),
        .target(
            name: "Domain",
            dependencies: [
                "Core",
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestoreSwift-Beta", package: "firebase-ios-sdk"),
            ]
        ),
        .target(
            name: "UIComponent",
            dependencies: [
                .product(name: "Charts", package: "Charts")
            ]
        ),
    ]
)
