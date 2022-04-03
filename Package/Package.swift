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
        .package(url: "https://github.com/danielgindi/Charts.git", from: "4.0.0")
    ],
    targets: [
        // MARK: Feature modules
        
        .target(
            name: "AppFeature",
            dependencies: [
                "UIComponent",
                "Core",
            ]
        ),
        
        // MARK: Internal modules
        
        .target(
            name: "Core",
            dependencies: []
        ),
        .target(
            name: "UIComponent",
            dependencies: [
                .product(name: "Charts", package: "Charts")
            ]
        ),
    ]
)
