// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "MessageTextUtils",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "MessageTextUtils", targets: ["MessageTextUtils"]),
    ],
    dependencies: [
        .package(name: "SSignalKit", path: "../../submodules/ansible-ios/submodules/SSignalKit"),
        .package(name: "TelegramCore", path: "../../submodules/ansible-ios/submodules/TelegramCore"),
        .package(name: "Postbox", path: "../../submodules/ansible-ios/submodules/Postbox"),
        .package(name: "AnsibleUIKit", path: "../AnsibleUIKit"),
        .package(name: "Localization", path: "../Localization"),
        .package(name: "AnsibleTheme", path: "../AnsibleTheme"),
        .package(name: "AnsibleUtils", path: "../AnsibleUtils"),
        .package(name: "AnsibleMediaUtils", path: "../AnsibleMediaUtils"),
        .package(name: "MessageUtils", path: "../MessageUtils"),
        .package(name: "ColorPalette", path: "../ColorPalette"),
        .package(name: "InputView", path: "../InputView"),
        .package(name: "CurrencyFormat", path: "../CurrencyFormat"),
        .package(name: "AnsibleContext", path: "../AnsibleContext"),
        .package(name: "SecureIdUtils", path: "../SecureIdUtils"),
        .package(name: "InlineStickerLayer", path: "../InlineStickerLayer"),
    ],
    targets: [
        .target(
            name: "MessageTextUtils",
            dependencies: [
                .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
                .product(name: "TelegramCore", package: "TelegramCore", condition: nil),
                .product(name: "Postbox", package: "Postbox", condition: nil),
                .product(name: "AnsibleUIKit", package: "AnsibleUIKit", condition: nil),
                .product(name: "Localization", package: "Localization", condition: nil),
                .product(name: "AnsibleTheme", package: "AnsibleTheme", condition: nil),
                .product(name: "AnsibleUtils", package: "AnsibleUtils", condition: nil),
                .product(name: "AnsibleMediaUtils", package: "AnsibleMediaUtils", condition: nil),
                .product(name: "MessageUtils", package: "MessageUtils", condition: nil),
                .product(name: "ColorPalette", package: "ColorPalette", condition: nil),
                .product(name: "InputView", package: "InputView", condition: nil),
                .product(name: "CurrencyFormat", package: "CurrencyFormat", condition: nil),
                .product(name: "AnsibleContext", package: "AnsibleContext", condition: nil),
                .product(name: "SecureIdUtils", package: "SecureIdUtils", condition: nil),
                .product(name: "InlineStickerLayer", package: "InlineStickerLayer", condition: nil),
            ],
            path: "Sources/MessageTextUtils"),
        .testTarget(
            name: "MessageTextUtilsTests",
            dependencies: ["MessageTextUtils", .product(name: "AnsibleUtils", package: "AnsibleUtils")],
            path: "Tests/MessageTextUtilsTests"),
    ]
)
