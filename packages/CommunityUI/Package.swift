// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "CommunityUI",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "CommunityUI", targets: ["CommunityUI"]),
    ],
    dependencies: [
        .package(name: "SSignalKit", path: "../../submodules/ansible-ios/submodules/SSignalKit"),
        .package(name: "TelegramCore", path: "../../submodules/ansible-ios/submodules/TelegramCore"),
        .package(name: "Postbox", path: "../../submodules/ansible-ios/submodules/Postbox"),
        .package(name: "AnsibleUIKit", path: "../AnsibleUIKit"),
        .package(name: "ColorPalette", path: "../ColorPalette"),
        .package(name: "Localization", path: "../Localization"),
        .package(name: "DateUtils", path: "../DateUtils"),
        .package(name: "AnsibleTheme", path: "../AnsibleTheme"),
        .package(name: "AnsibleContext", path: "../AnsibleContext"),
        .package(name: "AnsibleUtils", path: "../AnsibleUtils"),
        .package(name: "GeneralRows", path: "../GeneralRows"),
        .package(name: "InputDataUI", path: "../InputDataUI"),
        .package(name: "ShortPeerRow", path: "../ShortPeerRow"),
        .package(name: "AvatarUI", path: "../AvatarUI"),
        .package(name: "AnsibleMediaUtils", path: "../AnsibleMediaUtils"),
        .package(name: "AlertsUI", path: "../AlertsUI"),
        .package(name: "LocalAnimations", path: "../LocalAnimations"),
        .package(name: "MessageTextUtils", path: "../MessageTextUtils"),
        .package(name: "AvatarEditorUI", path: "../AvatarEditorUI"),
        .package(name: "FilePanels", path: "../FilePanels"),
        .package(name: "AppAnalytics", path: "../AppAnalytics"),
    ],
    targets: [
        .target(
            name: "CommunityUI",
            dependencies: [
                .product(name: "AnsibleUIKit", package: "AnsibleUIKit", condition: nil),
                .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
                .product(name: "TelegramCore", package: "TelegramCore", condition: nil),
                .product(name: "Postbox", package: "Postbox", condition: nil),
                .product(name: "ColorPalette", package: "ColorPalette", condition: nil),
                .product(name: "Localization", package: "Localization", condition: nil),
                .product(name: "DateUtils", package: "DateUtils", condition: nil),
                .product(name: "AnsibleTheme", package: "AnsibleTheme", condition: nil),
                .product(name: "AnsibleContext", package: "AnsibleContext", condition: nil),
                .product(name: "AnsibleUtils", package: "AnsibleUtils", condition: nil),
                .product(name: "GeneralRows", package: "GeneralRows", condition: nil),
                .product(name: "InputDataUI", package: "InputDataUI", condition: nil),
                .product(name: "ShortPeerRow", package: "ShortPeerRow", condition: nil),
                .product(name: "AvatarUI", package: "AvatarUI", condition: nil),
                .product(name: "AnsibleMediaUtils", package: "AnsibleMediaUtils", condition: nil),
                .product(name: "AlertsUI", package: "AlertsUI", condition: nil),
                .product(name: "LocalAnimations", package: "LocalAnimations", condition: nil),
                .product(name: "MessageTextUtils", package: "MessageTextUtils", condition: nil),
                .product(name: "AvatarEditorUI", package: "AvatarEditorUI", condition: nil),
                .product(name: "FilePanels", package: "FilePanels", condition: nil),
                .product(name: "AppAnalytics", package: "AppAnalytics", condition: nil),
            ],
            path: "Sources/CommunityUI"),
    ]
)
