// swift-tools-version:5.5

import PackageDescription

let common: [Target.Dependency] = [
    .product(name: "TGUIKit", package: "TGUIKit", condition: nil),
    .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
    .product(name: "TelegramCore", package: "TelegramCore", condition: nil),
    .product(name: "Postbox", package: "Postbox", condition: nil),
    .product(name: "ColorPalette", package: "ColorPalette", condition: nil),
    .product(name: "InAppSettings", package: "InAppSettings", condition: nil),
    .product(name: "BuildConfig", package: "BuildConfig", condition: nil),
]

let package = Package(
    name: "AnsibleContext",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "AnsibleContext", targets: ["AnsibleContext"]),
        .library(name: "AnsibleContextShare", targets: ["AnsibleContextShare"]),
    ],
    dependencies: [
        .package(name: "SSignalKit", path: "../../submodules/ansible-ios/submodules/SSignalKit"),
        .package(name: "TelegramCore", path: "../../submodules/ansible-ios/submodules/TelegramCore"),
        .package(name: "InlineStickers", path: "../InlineStickers"),
        .package(name: "AnsibleTheme", path: "../AnsibleTheme"),
        .package(name: "Postbox", path: "../../submodules/ansible-ios/submodules/Postbox"),
        .package(name: "TGUIKit", path: "../TGUIKit"),
        .package(name: "ColorPalette", path: "../ColorPalette"),
        .package(name: "InAppSettings", path: "../InAppSettings"),
        .package(name: "BuildConfig", path: "../../submodules/BuildConfig"),
        .package(name: "FetchManager", path: "../FetchManager"),
        .package(name: "Reactions", path: "../Reactions"),
        .package(name: "DiceCache", path: "../DiceCache"),
        .package(name: "CaptureExclusion", path: "../CaptureExclusion"),
        .package(name: "CurrencyFormat", path: "../CurrencyFormat"),
    ],
    targets: [
        .target(
            name: "AnsibleContext",
            dependencies: common + [
                .product(name: "FetchManager", package: "FetchManager", condition: nil),
                .product(name: "Reactions", package: "Reactions", condition: nil),
                .product(name: "DiceCache", package: "DiceCache", condition: nil),
                .product(name: "CaptureExclusion", package: "CaptureExclusion", condition: nil),
                .product(name: "CurrencyFormat", package: "CurrencyFormat", condition: nil),
                .product(name: "InlineStickers", package: "InlineStickers", condition: nil),
                .product(name: "AnsibleTheme", package: "AnsibleTheme", condition: nil),
            ],
            path: "Sources/AnsibleContext"),
        .target(
            name: "AnsibleContextShare",
            dependencies: common,
            path: "Sources/AnsibleContextShare",
            swiftSettings: [.define("SHARE")]),
    ]
)
