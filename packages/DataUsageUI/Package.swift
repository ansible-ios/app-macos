// swift-tools-version:5.5

import PackageDescription

let deps: [(String, String)] = [
    ("AppAnalytics", "../AppAnalytics"),
    ("TGUIKit", "../TGUIKit"),
    ("InputDataUI", "../InputDataUI"),
    ("GeneralRows", "../GeneralRows"),
    ("Localization", "../Localization"),
    ("AnsibleContext", "../AnsibleContext"),
    ("AnsibleUtils", "../AnsibleUtils"),
    ("AnsibleTheme", "../AnsibleTheme"),
    ("ColorPalette", "../ColorPalette"),
    ("FoundationUtils", "../FoundationUtils"),
    ("AlertsUI", "../AlertsUI"),
    ("InAppSettings", "../InAppSettings"),
    ("LocalAnimations", "../LocalAnimations"),
    ("AvatarUI", "../AvatarUI"),
    ("ProxyUtils", "../ProxyUtils"),
    ("FilePanels", "../FilePanels"),
    ("AnsibleIconsTheme", "../AnsibleIconsTheme"),
    ("ShortPeerRow", "../ShortPeerRow"),
    ("SystemPermissions", "../SystemPermissions"),
    ("ChatModeTypes", "../ChatModeTypes"),
    ("AudioPlayerCore", "../AudioPlayerCore"),
    ("AnsibleMediaUtils", "../AnsibleMediaUtils"),
    ("AnsibleMedia", "../AnsibleMedia"),
    ("InlineMediaGrid", "../InlineMediaGrid"),
    ("GraphCore", "../../submodules/ansible-ios/submodules/GraphCore"),
]

let package = Package(
    name: "DataUsageUI",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "DataUsageUI", targets: ["DataUsageUI"]),
    ],
    dependencies: [
        .package(name: "SSignalKit", path: "../../submodules/ansible-ios/submodules/SSignalKit"),
        .package(name: "TelegramCore", path: "../../submodules/ansible-ios/submodules/TelegramCore"),
        .package(name: "Postbox", path: "../../submodules/ansible-ios/submodules/Postbox"),
    ] + deps.map { .package(name: $0.0, path: $0.1) },
    targets: [
        .target(
            name: "DataUsageUI",
            dependencies: [
                .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
                .product(name: "TelegramCore", package: "TelegramCore", condition: nil),
                .product(name: "Postbox", package: "Postbox", condition: nil),
            ] + deps.map { .product(name: $0.0, package: $0.0, condition: nil) },
            path: "Sources/DataUsageUI",
            resources: [.process("Resources/StorageUsageAssets.xcassets")]),
    ]
)
