// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "InlineMediaGrid",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "InlineMediaGrid", targets: ["InlineMediaGrid"]),
    ],
    dependencies: [
        .package(name: "TelegramCore", path: "../../submodules/ansible-ios/submodules/TelegramCore"),
        .package(name: "Postbox", path: "../../submodules/ansible-ios/submodules/Postbox"),
        .package(name: "SSignalKit", path: "../../submodules/ansible-ios/submodules/SSignalKit"),
        .package(name: "TelegramMediaPlayer", path: "../../submodules/ansible-ios/submodules/MediaPlayer"),
        .package(name: "AnsibleUIKit", path: "../AnsibleUIKit"),
        .package(name: "InlineStickerLayer", path: "../InlineStickerLayer"),
        .package(name: "AnsibleMediaUtils", path: "../AnsibleMediaUtils"),
        .package(name: "AnsibleMedia", path: "../AnsibleMedia"),
        .package(name: "ColorPalette", path: "../ColorPalette"),
        .package(name: "Localization", path: "../Localization"),
        .package(name: "InAppSettings", path: "../InAppSettings"),
        .package(name: "AnsibleContext", path: "../AnsibleContext"),
        .package(name: "AnsibleTheme", path: "../AnsibleTheme"),
        .package(name: "AnsibleUtils", path: "../AnsibleUtils"),
        .package(name: "MessageUtils", path: "../MessageUtils"),
        .package(name: "AvatarUI", path: "../AvatarUI"),
        .package(name: "GeneralRows", path: "../GeneralRows"),
        .package(name: "LocalAnimations", path: "../LocalAnimations"),
        .package(name: "ThemeSettings", path: "../ThemeSettings"),
        .package(name: "rnoise", path: "../../submodules/ansible-ios/third-party/rnnoise"),
    ],
    targets: [
        .target(
            name: "InlineMediaGrid",
            dependencies: [
                .product(name: "TelegramCore", package: "TelegramCore", condition: nil),
                .product(name: "Postbox", package: "Postbox", condition: nil),
                .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
                .product(name: "TelegramMediaPlayer", package: "TelegramMediaPlayer", condition: nil),
                .product(name: "AnsibleUIKit", package: "AnsibleUIKit", condition: nil),
                .product(name: "InlineStickerLayer", package: "InlineStickerLayer", condition: nil),
                .product(name: "AnsibleMediaUtils", package: "AnsibleMediaUtils", condition: nil),
                .product(name: "AnsibleMedia", package: "AnsibleMedia", condition: nil),
                .product(name: "ColorPalette", package: "ColorPalette", condition: nil),
                .product(name: "Localization", package: "Localization", condition: nil),
                .product(name: "InAppSettings", package: "InAppSettings", condition: nil),
                .product(name: "AnsibleContext", package: "AnsibleContext", condition: nil),
                .product(name: "AnsibleTheme", package: "AnsibleTheme", condition: nil),
                .product(name: "AnsibleUtils", package: "AnsibleUtils", condition: nil),
                .product(name: "MessageUtils", package: "MessageUtils", condition: nil),
                .product(name: "AvatarUI", package: "AvatarUI", condition: nil),
                .product(name: "GeneralRows", package: "GeneralRows", condition: nil),
                .product(name: "LocalAnimations", package: "LocalAnimations", condition: nil),
            ],
            path: "Sources/InlineMediaGrid"),
        .testTarget(
            name: "InlineMediaGridTests",
            dependencies: [
                "InlineMediaGrid",
                .product(name: "AnsibleUIKit", package: "AnsibleUIKit", condition: nil),
                .product(name: "AnsibleTheme", package: "AnsibleTheme", condition: nil),
                .product(name: "AnsibleUtils", package: "AnsibleUtils", condition: nil),
                .product(name: "GeneralRows", package: "GeneralRows", condition: nil),
                .product(name: "InAppSettings", package: "InAppSettings", condition: nil),
                .product(name: "TelegramCore", package: "TelegramCore", condition: nil),
                .product(name: "Postbox", package: "Postbox", condition: nil),
                .product(name: "ColorPalette", package: "ColorPalette", condition: nil),
                .product(name: "ThemeSettings", package: "ThemeSettings", condition: nil),
                .product(name: "rnoise", package: "rnoise", condition: nil),
            ],
            path: "Tests/InlineMediaGridTests"),
    ]
)
