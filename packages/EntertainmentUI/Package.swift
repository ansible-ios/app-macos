// swift-tools-version:5.5

import PackageDescription

let deps: [(String, String)] = [
    ("AppAnalytics", "../AppAnalytics"),
    ("AnsibleUIKit", "../AnsibleUIKit"),
    ("ColorPalette", "../ColorPalette"),
    ("InAppSettings", "../InAppSettings"),
    ("Localization", "../Localization"),
    ("FoundationUtils", "../FoundationUtils"),
    ("Strings", "../Strings"),
    ("ObjcUtils", "../ObjcUtils"),
    ("ComponentsUI", "../ComponentsUI"),
    ("AnsibleModernGrowingTextView", "../AnsibleModernGrowingTextView"),
    ("AnsibleTheme", "../AnsibleTheme"),
    ("AnsibleContext", "../AnsibleContext"),
    ("AnsibleUtils", "../AnsibleUtils"),
    ("AnsibleMedia", "../AnsibleMedia"),
    ("AnsibleMediaResources", "../AnsibleMediaResources"),
    ("AnsibleMediaUtils", "../AnsibleMediaUtils"),
    ("InlineStickers", "../InlineStickers"),
    ("InlineMediaGrid", "../InlineMediaGrid"),
    ("LocalAnimations", "../LocalAnimations"),
    ("GeneralRows", "../GeneralRows"),
    ("InputDataUI", "../InputDataUI"),
    ("AlertsUI", "../AlertsUI"),
    ("AvatarUI", "../AvatarUI"),
    ("FilePanels", "../FilePanels"),
    ("MessageTextUtils", "../MessageTextUtils"),
    ("PremiumStatusUI", "../PremiumStatusUI"),
    ("ChatModeTypes", "../ChatModeTypes"),
    ("InputView", "../InputView"),
    ("InlineStickerLayer", "../InlineStickerLayer"),
    ("PerfLab", "../PerfLab"),
]

let package = Package(
    name: "EntertainmentUI",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "EntertainmentUI", targets: ["EntertainmentUI"]),
    ],
    dependencies: [
        .package(name: "SSignalKit", path: "../../submodules/ansible-ios/submodules/SSignalKit"),
        .package(name: "TelegramCore", path: "../../submodules/ansible-ios/submodules/TelegramCore"),
        .package(name: "Postbox", path: "../../submodules/ansible-ios/submodules/Postbox"),
    ] + deps.map { .package(name: $0.0, path: $0.1) },
    targets: [
        .target(
            name: "EntertainmentUI",
            dependencies: [
                .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
                .product(name: "TelegramCore", package: "TelegramCore", condition: nil),
                .product(name: "Postbox", package: "Postbox", condition: nil),
            ] + deps.map { .product(name: $0.0, package: $0.0, condition: nil) },
            path: "Sources/EntertainmentUI"),
    ]
)
