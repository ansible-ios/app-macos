// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "SceneEffects",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(
            name: "SceneEffects",
            targets: ["SceneEffects"]),
    ],
    dependencies: [
        .package(name: "AnsibleUIKit", path: "../AnsibleUIKit"),
        .package(name: "AnsibleMedia", path: "../AnsibleMedia"),
        .package(name: "AnsibleContext", path: "../AnsibleContext"),
        .package(name: "AnsibleMediaUtils", path: "../AnsibleMediaUtils"),
        .package(name: "AnsibleTheme", path: "../AnsibleTheme"),
        .package(name: "InlineStickers", path: "../InlineStickers"),
        .package(name: "LocalAnimations", path: "../LocalAnimations"),
        .package(name: "AnsibleUtils", path: "../AnsibleUtils"),
        .package(name: "TelegramCore", path: "../../submodules/ansible-ios/submodules/TelegramCore"),
        .package(name: "Postbox", path: "../../submodules/ansible-ios/submodules/Postbox"),
        .package(name: "SSignalKit", path: "../../submodules/ansible-ios/submodules/SSignalKit"),
        .package(name: "MetalEngine", path: "../../submodules/ansible-ios/submodules/MetalEngine"),
        .package(name: "InlineStickerLayer", path: "../InlineStickerLayer"),
    ],
    targets: [
        .target(
            name: "SceneEffects",
            dependencies: [
                .product(name: "AnsibleUIKit", package: "AnsibleUIKit", condition: nil),
                .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
                .product(name: "MetalEngine", package: "MetalEngine", condition: nil),
                .product(name: "TelegramCore", package: "TelegramCore", condition: nil),
                .product(name: "AnsibleMedia", package: "AnsibleMedia", condition: nil),
                .product(name: "AnsibleContext", package: "AnsibleContext", condition: nil),
                .product(name: "AnsibleMediaUtils", package: "AnsibleMediaUtils", condition: nil),
                .product(name: "AnsibleTheme", package: "AnsibleTheme", condition: nil),
                .product(name: "InlineStickers", package: "InlineStickers", condition: nil),
                .product(name: "LocalAnimations", package: "LocalAnimations", condition: nil),
                .product(name: "AnsibleUtils", package: "AnsibleUtils", condition: nil),
                .product(name: "Postbox", package: "Postbox", condition: nil),
                .product(name: "InlineStickerLayer", package: "InlineStickerLayer", condition: nil),
            ],
            path: "Sources"),
    ]
)
