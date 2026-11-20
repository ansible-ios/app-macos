// swift-tools-version:5.5

import PackageDescription

let common: [Target.Dependency] = [
    .product(name: "AnsibleUIKit", package: "AnsibleUIKit", condition: nil),
    .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
    .product(name: "TelegramCore", package: "TelegramCore", condition: nil),
    .product(name: "Postbox", package: "Postbox", condition: nil),
    .product(name: "ColorPalette", package: "ColorPalette", condition: nil),
    .product(name: "Localization", package: "Localization", condition: nil),
]

let package = Package(
    name: "ShortPeerRow",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "ShortPeerRow", targets: ["ShortPeerRow"]),
        .library(name: "ShortPeerRowShare", targets: ["ShortPeerRowShare"]),
    ],
    dependencies: [
        .package(name: "SSignalKit", path: "../../submodules/ansible-ios/submodules/SSignalKit"),
        .package(name: "TelegramCore", path: "../../submodules/ansible-ios/submodules/TelegramCore"),
        .package(name: "Postbox", path: "../../submodules/ansible-ios/submodules/Postbox"),
        .package(name: "AnsibleUIKit", path: "../AnsibleUIKit"),
        .package(name: "ColorPalette", path: "../ColorPalette"),
        .package(name: "Localization", path: "../Localization"),
        .package(name: "AnsibleTheme", path: "../AnsibleTheme"),
        .package(name: "AnsibleContext", path: "../AnsibleContext"),
        .package(name: "AnsibleUtils", path: "../AnsibleUtils"),
        .package(name: "GeneralRows", path: "../GeneralRows"),
        .package(name: "AvatarUI", path: "../AvatarUI"),
        .package(name: "PremiumStatusUI", path: "../PremiumStatusUI"),
        .package(name: "InAppSettings", path: "../InAppSettings"),
        .package(name: "ThemeSettings", path: "../ThemeSettings"),
        .package(name: "rnoise", path: "../../submodules/ansible-ios/third-party/rnnoise"),
    ],
    targets: [
        .target(
            name: "ShortPeerRow",
            dependencies: common + [.product(name: "AnsibleTheme", package: "AnsibleTheme", condition: nil),
                                    .product(name: "AnsibleContext", package: "AnsibleContext", condition: nil),
                                    .product(name: "AnsibleUtils", package: "AnsibleUtils", condition: nil),
                                    .product(name: "GeneralRows", package: "GeneralRows", condition: nil),
                                    .product(name: "AvatarUI", package: "AvatarUI", condition: nil),
                                    .product(name: "PremiumStatusUI", package: "PremiumStatusUI", condition: nil)],
            path: "Sources/ShortPeerRow"),
        .target(
            name: "ShortPeerRowShare",
            dependencies: common + [.product(name: "AnsibleThemeShare", package: "AnsibleTheme", condition: nil),
                                    .product(name: "AnsibleContextShare", package: "AnsibleContext", condition: nil),
                                    .product(name: "AnsibleUtilsShare", package: "AnsibleUtils", condition: nil),
                                    .product(name: "GeneralRowsShare", package: "GeneralRows", condition: nil),
                                    .product(name: "AvatarUIShare", package: "AvatarUI", condition: nil)],
            path: "Sources/ShortPeerRowShare",
            swiftSettings: [.define("SHARE")]),
        .testTarget(
            name: "ShortPeerRowTests",
            dependencies: [
                "ShortPeerRow",
                .product(name: "TelegramCore", package: "TelegramCore", condition: nil),
                .product(name: "Postbox", package: "Postbox", condition: nil),
                .product(name: "AnsibleUIKit", package: "AnsibleUIKit", condition: nil),
                .product(name: "AnsibleTheme", package: "AnsibleTheme", condition: nil),
                .product(name: "GeneralRows", package: "GeneralRows", condition: nil),
                .product(name: "ColorPalette", package: "ColorPalette", condition: nil),
                .product(name: "InAppSettings", package: "InAppSettings", condition: nil),
                .product(name: "ThemeSettings", package: "ThemeSettings", condition: nil),
                .product(name: "rnoise", package: "rnoise"),
            ],
            path: "Tests/ShortPeerRowTests"),
    ]
)
