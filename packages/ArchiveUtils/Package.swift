// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "ArchiveUtils",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "ArchiveUtils", targets: ["ArchiveUtils"]),
    ],
    dependencies: [
        .package(name: "SSignalKit", path: "../../submodules/ansible-ios/submodules/SSignalKit"),
        .package(name: "Zip", path: "../../submodules/Zip"),
        .package(name: "AnsibleMediaResources", path: "../AnsibleMediaResources"),
    ],
    targets: [
        .target(
            name: "ArchiveUtils",
            dependencies: [
                .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
                .product(name: "Zip", package: "Zip", condition: nil),
                .product(name: "AnsibleMediaResources", package: "AnsibleMediaResources", condition: nil),
            ],
            path: "Sources/ArchiveUtils"),
    ]
)
