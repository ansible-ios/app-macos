// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "PremiumStatusUI",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "PremiumStatusUI", targets: ["PremiumStatusUI"]),
    ],
    dependencies: [
        .package(name: "SSignalKit", path: "../../submodules/ansible-ios/submodules/SSignalKit"),
        .package(name: "TelegramCore", path: "../../submodules/ansible-ios/submodules/TelegramCore"),
        .package(name: "Postbox", path: "../../submodules/ansible-ios/submodules/Postbox"),
        .package(name: "TGUIKit", path: "../TGUIKit"),
        .package(name: "ColorPalette", path: "../ColorPalette"),
        .package(name: "Localization", path: "../Localization"),
        .package(name: "AnsibleTheme", path: "../AnsibleTheme"),
        .package(name: "AnsibleContext", path: "../AnsibleContext"),
        .package(name: "AnsibleUtils", path: "../AnsibleUtils"),
        .package(name: "InlineStickers", path: "../InlineStickers"),
        .package(name: "InAppSettings", path: "../InAppSettings"),
        .package(name: "LocalAnimations", path: "../LocalAnimations"),
        .package(name: "ObjcUtils", path: "../ObjcUtils"),
        .package(name: "AnsibleMedia", path: "../AnsibleMedia"),
        .package(name: "InlineStickerLayer", path: "../InlineStickerLayer"),
    ],
    targets: [
        .target(
            name: "PremiumStatusUI",
            dependencies: [
                .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
                .product(name: "TelegramCore", package: "TelegramCore", condition: nil),
                .product(name: "Postbox", package: "Postbox", condition: nil),
                .product(name: "TGUIKit", package: "TGUIKit", condition: nil),
                .product(name: "ColorPalette", package: "ColorPalette", condition: nil),
                .product(name: "Localization", package: "Localization", condition: nil),
                .product(name: "AnsibleTheme", package: "AnsibleTheme", condition: nil),
                .product(name: "AnsibleContext", package: "AnsibleContext", condition: nil),
                .product(name: "AnsibleUtils", package: "AnsibleUtils", condition: nil),
                .product(name: "InlineStickers", package: "InlineStickers", condition: nil),
                .product(name: "InAppSettings", package: "InAppSettings", condition: nil),
                .product(name: "LocalAnimations", package: "LocalAnimations", condition: nil),
                .product(name: "ObjcUtils", package: "ObjcUtils", condition: nil),
                .product(name: "AnsibleMedia", package: "AnsibleMedia", condition: nil),
                .product(name: "InlineStickerLayer", package: "InlineStickerLayer", condition: nil),
            ],
            path: "Sources/PremiumStatusUI"),
    ]
)
