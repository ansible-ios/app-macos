// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "ProxyUtils",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "ProxyUtils", targets: ["ProxyUtils"]),
    ],
    dependencies: [
        .package(name: "SSignalKit", path: "../../submodules/ansible-ios/submodules/SSignalKit"),
        .package(name: "TelegramCore", path: "../../submodules/ansible-ios/submodules/TelegramCore"),
        .package(name: "Postbox", path: "../../submodules/ansible-ios/submodules/Postbox"),
        .package(name: "FoundationUtils", path: "../FoundationUtils"),
        .package(name: "MtProtoKit", path: "../../submodules/ansible-ios/submodules/MtProtoKit"),
    ],
    targets: [
        .target(
            name: "ProxyUtils",
            dependencies: [
                .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
                .product(name: "TelegramCore", package: "TelegramCore", condition: nil),
                .product(name: "Postbox", package: "Postbox", condition: nil),
                .product(name: "FoundationUtils", package: "FoundationUtils", condition: nil),
                .product(name: "MtProtoKit", package: "MtProtoKit", condition: nil),
            ],
            path: "Sources/ProxyUtils"),
    ]
)
