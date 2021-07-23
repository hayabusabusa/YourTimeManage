// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Modules",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "Application", targets: ["Application"]),
        .library(name: "Domain", targets: ["Domain"]),
        .library(name: "Shared", type: .dynamic, targets: ["Shared"]),
        .library(name: "UIComponent", targets: ["UIComponent"]),
    ],
    dependencies: [
        .package(name: "Charts", url: "https://github.com/danielgindi/Charts.git", from: "4.0.0"),
        .package(name: "Entwine", url: "https://github.com/tcldr/Entwine.git", from: "0.9.0"),
        .package(name: "Firebase", url: "https://github.com/firebase/firebase-ios-sdk.git", from: "8.2.0"),
        .package(name: "GoogleMobileAds-SPM", url: "https://github.com/Koze/GoogleMobileAds-SPM.git", from: "8.7.0"),
        .package(name: "HorizonCalendar", url: "https://github.com/airbnb/HorizonCalendar.git", from: "1.0.0"),
    ],
    targets: [
        // MARK: Modules
        .target(name: "Application", dependencies: [
            "Domain",
            "Shared",
            "UIComponent",
            .product(name: "GoogleMobileAds", package: "GoogleMobileAds-SPM"),
        ]),
        .target(name: "Domain", dependencies: [
            "Shared",
            .product(name: "FirebaseAuth", package: "Firebase"),
            .product(name: "FirebaseFirestore", package: "Firebase"),
            .product(name: "FirebaseFirestoreSwift-Beta", package: "Firebase"),
        ]),
        .target(name: "Shared", dependencies: []),
        .target(name: "UIComponent", dependencies: [
            "Shared",
            .product(name: "Charts", package: "Charts"),
            .product(name: "HorizonCalendar", package: "HorizonCalendar"),
        ]),
        
        // MARK: Tests
        .testTarget(name: "DomainTests", dependencies: [
            "Domain",
            .product(name: "EntwineTest", package: "Entwine")
        ]),
        .testTarget(name: "SharedTests", dependencies: [
            "Shared",
        ]),
    ]
)
