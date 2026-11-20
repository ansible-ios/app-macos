// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "RevealOptions",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "RevealOptions", targets: ["RevealOptions"]),
    ],
    dependencies: [
        .package(name: "AnsibleUIKit", path: "../AnsibleUIKit"),
    ],
    targets: [
        .target(
            name: "RevealOptions",
            dependencies: [
                .product(name: "AnsibleUIKit", package: "AnsibleUIKit", condition: nil),
            ],
            path: "Sources/RevealOptions"),
        .testTarget(
            name: "RevealOptionsTests",
            dependencies: [
                "RevealOptions",
                .product(name: "AnsibleUIKit", package: "AnsibleUIKit", condition: nil),
            ],
            path: "Tests/RevealOptionsTests"),
    ]
)
