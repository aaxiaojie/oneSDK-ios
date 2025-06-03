// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "oneSDK",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "oneSDK",
            targets: ["oneSDK"]),
    ],
    dependencies: [
        .package(url: "https://github.com/adjust/ios_sdk.git", from: "5.4.0"),
        .package(url: "https://github.com/facebook/facebook-ios-sdk.git", from: "18.0.0"),
        .package(url: "https://github.com/google/GoogleSignIn-iOS.git", from: "8.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "oneSDK"),
        .testTarget(
            name: "oneSDKTests",
            dependencies: ["oneSDK"]
        ),
    ]
)