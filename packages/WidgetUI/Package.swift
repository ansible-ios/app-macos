// swift-tools-version:5.5

import PackageDescription

let deps: [(String, String)] = [
    ("AnsibleUIKit", "../AnsibleUIKit"),
    ("ColorPalette", "../ColorPalette"),
    ("InAppSettings", "../InAppSettings"),
    ("Localization", "../Localization"),
    ("AnsibleTheme", "../AnsibleTheme"),
    ("AnsibleIconsTheme", "../AnsibleIconsTheme"),
    ("AnsibleContext", "../AnsibleContext"),
    ("AnsibleUtils", "../AnsibleUtils"),
    ("ThemeSettings", "../ThemeSettings"),
    ("AvatarUI", "../AvatarUI"),
    ("QuickSwitcher", "../QuickSwitcher"),
    ("SettingsUI", "../SettingsUI"),
    ("StickerSettingsUI", "../StickerSettingsUI"),
    ("PremiumUI", "../PremiumUI"),
]

let package = Package(
    name: "WidgetUI",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "WidgetUI", targets: ["WidgetUI"]),
    ],
    dependencies: [
        .package(name: "SSignalKit", path: "../../submodules/ansible-ios/submodules/SSignalKit"),
        .package(name: "TelegramCore", path: "../../submodules/ansible-ios/submodules/TelegramCore"),
        .package(name: "Postbox", path: "../../submodules/ansible-ios/submodules/Postbox"),
    ] + deps.map { .package(name: $0.0, path: $0.1) },
    targets: [
        .target(
            name: "WidgetUI",
            dependencies: [
                .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
                .product(name: "TelegramCore", package: "TelegramCore", condition: nil),
                .product(name: "Postbox", package: "Postbox", condition: nil),
            ] + deps.map { .product(name: $0.0, package: $0.0, condition: nil) },
            path: "Sources/WidgetUI"),
    ]
)
