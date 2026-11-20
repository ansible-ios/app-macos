// swift-tools-version:5.5

import PackageDescription

let deps: [(String, String)] = [
    ("AppAnalytics", "../AppAnalytics"),
    ("AnsibleUIKit", "../AnsibleUIKit"),
    ("ColorPalette", "../ColorPalette"),
    ("InAppSettings", "../InAppSettings"),
    ("Localization", "../Localization"),
    ("AnsibleTheme", "../AnsibleTheme"),
    ("AnsibleContext", "../AnsibleContext"),
    ("AnsibleUtils", "../AnsibleUtils"),
    ("GeneralRows", "../GeneralRows"),
    ("InputDataUI", "../InputDataUI"),
    ("AlertsUI", "../AlertsUI"),
    ("LocalAnimations", "../LocalAnimations"),
    ("ThemeSettings", "../ThemeSettings"),
    ("AnsibleMedia", "../AnsibleMedia"),
    ("AnsibleMediaUtils", "../AnsibleMediaUtils"),
    ("AnsibleIconsTheme", "../AnsibleIconsTheme"),
    ("ChatHistoryModel", "../ChatHistoryModel"),
    ("AnsibleModernGrowingTextView", "../AnsibleModernGrowingTextView"),
    ("FilePanels", "../FilePanels"),
    ("PremiumUI", "../PremiumUI"),
    ("DiceCache", "../DiceCache"),
]

let package = Package(
    name: "WallpaperUI",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "WallpaperUI", targets: ["WallpaperUI"]),
    ],
    dependencies: [
        .package(name: "SSignalKit", path: "../../submodules/ansible-ios/submodules/SSignalKit"),
        .package(name: "TelegramCore", path: "../../submodules/ansible-ios/submodules/TelegramCore"),
        .package(name: "Postbox", path: "../../submodules/ansible-ios/submodules/Postbox"),
    ] + deps.map { .package(name: $0.0, path: $0.1) },
    targets: [
        .target(
            name: "WallpaperUI",
            dependencies: [
                .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
                .product(name: "TelegramCore", package: "TelegramCore", condition: nil),
                .product(name: "Postbox", package: "Postbox", condition: nil),
            ] + deps.map { .product(name: $0.0, package: $0.0, condition: nil) },
            path: "Sources/WallpaperUI"),
    ]
)
