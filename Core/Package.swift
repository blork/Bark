// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(
            name: "DogAPI",
            targets: ["DogAPI"]
        ),
    ],
    dependencies: [
        .package(path: "../Base"),
    ],
    targets: [
        .target(
            name: "DogAPI",
            dependencies: [
                .product(name: "Base", package: "Base"),
            ]
        ),
        .testTarget(
            name: "DogAPITests",
            dependencies: ["DogAPI"]
        )
    ]
)
