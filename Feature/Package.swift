// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "Feature",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(
            name: "Feature",
            targets: ["Feature"]
        ),
    ],
    dependencies: [
        .package(path: "../Core")
    ],
    targets: [
        .target(
            name: "Feature"
        ),
        .testTarget(
            name: "FeatureTests",
            dependencies: ["Feature"]
        ),
    ]
)
