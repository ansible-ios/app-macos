// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "ComponentsUI",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "ComponentsUI", targets: ["ComponentsUI"]),
    ],
    dependencies: [
        .package(name: "AnsibleUIKit", path: "../AnsibleUIKit"),
    ],
    targets: [
        .target(
            name: "ComponentsUI",
            dependencies: [
                .product(name: "AnsibleUIKit", package: "AnsibleUIKit"),
            ],
            path: "Sources/ComponentsUI"),
    ]
)
