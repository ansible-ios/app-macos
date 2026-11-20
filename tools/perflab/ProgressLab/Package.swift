// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "ProgressLab",
    platforms: [.macOS(.v12)],
    dependencies: [
        .package(name: "AnsibleUIKit", path: "../../../packages/AnsibleUIKit"),
    ],
    targets: [
        .executableTarget(
            name: "ProgressLab",
            dependencies: [
                .product(name: "AnsibleUIKit", package: "AnsibleUIKit", condition: nil),
            ],
            path: "Sources/ProgressLab"),
    ]
)
