// swift-tools-version:5.5

import PackageDescription

let deps: [(String, String)] = [
    ("TGUIKit", "../TGUIKit"),
    ("ColorPalette", "../ColorPalette"),
    ("Localization", "../Localization"),
    ("AnsibleTheme", "../AnsibleTheme"),
    ("AnsibleIconsTheme", "../AnsibleIconsTheme"),
    ("AnsibleContext", "../AnsibleContext"),
    ("AnsibleUtils", "../AnsibleUtils"),
    ("GeneralRows", "../GeneralRows"),
    ("InputDataUI", "../InputDataUI"),
    ("AvatarUI", "../AvatarUI"),
    ("AlertsUI", "../AlertsUI"),
    ("AnsibleMedia", "../AnsibleMedia"),
    ("LocalAnimations", "../LocalAnimations"),
    ("CurrencyFormat", "../CurrencyFormat"),
    ("InputView", "../InputView"),
    ("InputTextView", "../InputTextView"),
    ("StatisticsUI", "../StatisticsUI"),
    ("AffiliateUI", "../AffiliateUI"),
    ("StarsUI", "../StarsUI"),
    ("BoostUI", "../BoostUI"),
    ("ChatModeTypes", "../ChatModeTypes"),
    ("GraphCore", "../../submodules/ansible-ios/submodules/GraphCore"),
    ("InlineStickerLayer", "../InlineStickerLayer"),
    ("AppAnalytics", "../AppAnalytics"),
]

let package = Package(
    name: "MonetizationUI",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "MonetizationUI", targets: ["MonetizationUI"]),
    ],
    dependencies: [
        .package(name: "SSignalKit", path: "../../submodules/ansible-ios/submodules/SSignalKit"),
        .package(name: "TelegramCore", path: "../../submodules/ansible-ios/submodules/TelegramCore"),
        .package(name: "Postbox", path: "../../submodules/ansible-ios/submodules/Postbox"),
    ] + deps.map { .package(name: $0.0, path: $0.1) },
    targets: [
        .target(
            name: "MonetizationUI",
            dependencies: [
                .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
                .product(name: "TelegramCore", package: "TelegramCore", condition: nil),
                .product(name: "Postbox", package: "Postbox", condition: nil),
            ] + deps.map { .product(name: $0.0, package: $0.0, condition: nil) },
            path: "Sources/MonetizationUI")
    ]
)
