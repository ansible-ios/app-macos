// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "ChartLabLegacy",
    platforms: [.macOS(.v14)],
    dependencies: [
        .package(name: "AnsibleUIKit", path: "../../../../packages/AnsibleUIKit"),
        .package(name: "SSignalKit", path: "../../../../submodules/ansible-ios/submodules/SSignalKit"),
    ],
    targets: [
        .target(
            name: "GraphCore",
            path: "Modules/GraphCore"),
        .target(
            name: "GraphUI",
            dependencies: [
                "GraphCore",
                .product(name: "AnsibleUIKit", package: "AnsibleUIKit", condition: nil),
                .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
            ],
            path: "Modules/GraphUI"),
        .executableTarget(
            name: "ChartLab",
            dependencies: [
                "GraphUI",
                "GraphCore",
                .product(name: "AnsibleUIKit", package: "AnsibleUIKit", condition: nil),
            ],
            path: "Modules/ChartLab"),
    ]
)
