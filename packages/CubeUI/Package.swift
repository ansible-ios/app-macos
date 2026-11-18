// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "CubeUI",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "CubeUI", targets: ["CubeUI"]),
    ],
    dependencies: [
        .package(name: "TGUIKit", path: "../TGUIKit"),
        .package(name: "AnsibleContext", path: "../AnsibleContext"),
        .package(name: "AnsibleUtils", path: "../AnsibleUtils"),
        .package(name: "AnsibleMediaUtils", path: "../AnsibleMediaUtils"),
        .package(name: "SSignalKit", path: "../../submodules/ansible-ios/submodules/SSignalKit"),
        .package(name: "TelegramCore", path: "../../submodules/ansible-ios/submodules/TelegramCore"),
        .package(name: "Postbox", path: "../../submodules/ansible-ios/submodules/Postbox"),
        .package(name: "InlineStickerLayer", path: "../InlineStickerLayer"),
        .package(name: "UniqueGiftBackground", path: "../UniqueGiftBackground"),
    ],
    targets: [
        .target(
            name: "CubeUI",
            dependencies: [
                .product(name: "TGUIKit", package: "TGUIKit"),
                .product(name: "AnsibleContext", package: "AnsibleContext", condition: nil),
                .product(name: "AnsibleUtils", package: "AnsibleUtils", condition: nil),
                .product(name: "AnsibleMediaUtils", package: "AnsibleMediaUtils", condition: nil),
                .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
                .product(name: "TelegramCore", package: "TelegramCore", condition: nil),
                .product(name: "Postbox", package: "Postbox", condition: nil),
                .product(name: "InlineStickerLayer", package: "InlineStickerLayer", condition: nil),
                .product(name: "UniqueGiftBackground", package: "UniqueGiftBackground", condition: nil),
            ],
            path: "Sources/CubeUI",
            resources: [.process("Resources/Assets.xcassets")]),
    ]
)
