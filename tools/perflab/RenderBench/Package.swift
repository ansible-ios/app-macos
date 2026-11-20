// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "RenderBench",
    platforms: [.macOS(.v10_15)],
    dependencies: [
        .package(name: "AnsibleUIKit", path: "../../../packages/AnsibleUIKit"),
        .package(name: "SSignalKit", path: "../../../submodules/ansible-ios/submodules/SSignalKit"),
    ],
    targets: [
        .executableTarget(
            name: "RenderBench",
            dependencies: [
                .product(name: "AnsibleUIKit", package: "AnsibleUIKit", condition: nil),
                .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
            ],
            path: "Sources/RenderBench"),
    ]
)
