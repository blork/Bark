// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "Feature",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(
            name: "DogBrowser",
            targets: ["DogBrowser"]
        )
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(
            url: "https://github.com/pointfreeco/swift-snapshot-testing",
            from: "1.12.0"
        ),
    ],
    targets: [
        .target(
            name: "DogBrowser",
            dependencies: [
                .product(name: "DogAPI", package: "Core"),
                .product(name: "DogDesign", package: "Core"),
            ]
        ),
        .testTarget(
            name: "DogBrowserTests",
            dependencies: [
                "DogBrowser",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
            ]
        )
    ]
)
