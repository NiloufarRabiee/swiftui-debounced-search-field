// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "DebouncedSearchField",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "DebouncedSearchField",
            targets: ["DebouncedSearchField"]
        )
    ],
    targets: [
        .target(
            name: "DebouncedSearchField"
        ),
        .testTarget(
            name: "DebouncedSearchFieldTests",
            dependencies: ["DebouncedSearchField"]
        )
    ]
)
