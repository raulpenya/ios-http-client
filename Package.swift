// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HTTPClient",
    platforms: [
        .iOS(.v17),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "HTTPClient",
            targets: ["HTTPClient"]
        ),
    ],
    targets: [
        .target(
            name: "HTTPClient"
        ),
        .testTarget(
            name: "HTTPClientTests",
            dependencies: ["HTTPClient"]
        ),
    ]
)
