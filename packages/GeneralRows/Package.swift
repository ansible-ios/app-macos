// swift-tools-version:5.5

import PackageDescription

let common: [Target.Dependency] = [
    .product(name: "AnsibleUIKit", package: "AnsibleUIKit", condition: nil),
    .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
    .product(name: "TelegramCore", package: "TelegramCore", condition: nil),
    .product(name: "Postbox", package: "Postbox", condition: nil),
    .product(name: "ColorPalette", package: "ColorPalette", condition: nil),
    .product(name: "InAppSettings", package: "InAppSettings", condition: nil),
    .product(name: "Localization", package: "Localization", condition: nil),
    .product(name: "AnsibleIconsTheme", package: "AnsibleIconsTheme", condition: nil),
]

let package = Package(
    name: "GeneralRows",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "GeneralRows", targets: ["GeneralRows"]),
        .library(name: "GeneralRowsShare", targets: ["GeneralRowsShare"]),
    ],
    dependencies: [
        .package(name: "AnsibleIconsTheme", path: "../AnsibleIconsTheme"),
        .package(name: "SSignalKit", path: "../../submodules/ansible-ios/submodules/SSignalKit"),
        .package(name: "TelegramCore", path: "../../submodules/ansible-ios/submodules/TelegramCore"),
        .package(name: "Postbox", path: "../../submodules/ansible-ios/submodules/Postbox"),
        .package(name: "AnsibleUIKit", path: "../AnsibleUIKit"),
        .package(name: "ColorPalette", path: "../ColorPalette"),
        .package(name: "AnsibleTheme", path: "../AnsibleTheme"),
        .package(name: "AnsibleContext", path: "../AnsibleContext"),
        .package(name: "AnsibleUtils", path: "../AnsibleUtils"),
        .package(name: "InAppSettings", path: "../InAppSettings"),
        .package(name: "Localization", path: "../Localization"),
        .package(name: "LocalAnimations", path: "../LocalAnimations"),
        .package(name: "rnoise", path: "../../submodules/ansible-ios/third-party/rnnoise"),
        .package(name: "ThemeSettings", path: "../ThemeSettings"),
        .package(name: "AnsibleMedia", path: "../AnsibleMedia"),
    ],
    targets: [
        .target(
            name: "GeneralRows",
            dependencies: common + [.product(name: "AnsibleTheme", package: "AnsibleTheme", condition: nil),
                                    .product(name: "AnsibleContext", package: "AnsibleContext", condition: nil),
                                    .product(name: "AnsibleUtils", package: "AnsibleUtils", condition: nil),
                                    .product(name: "LocalAnimations", package: "LocalAnimations", condition: nil),
                                    .product(name: "AnsibleMedia", package: "AnsibleMedia", condition: nil)],
            path: "Sources/GeneralRows"),
        .target(
            name: "GeneralRowsShare",
            dependencies: common + [.product(name: "AnsibleThemeShare", package: "AnsibleTheme", condition: nil),
                                    .product(name: "AnsibleUtilsShare", package: "AnsibleUtils", condition: nil)],
            path: "Sources/GeneralRowsShare",
            swiftSettings: [.define("SHARE")]),
        .testTarget(
            name: "GeneralRowsTests",
            dependencies: [
                "GeneralRows",
                .product(name: "AnsibleUIKit", package: "AnsibleUIKit", condition: nil),
                .product(name: "TelegramCore", package: "TelegramCore", condition: nil),
                .product(name: "Postbox", package: "Postbox", condition: nil),
                .product(name: "AnsibleMedia", package: "AnsibleMedia", condition: nil),
                .product(name: "AnsibleContext", package: "AnsibleContext", condition: nil),
                .product(name: "rnoise", package: "rnoise"),
                .product(name: "AnsibleTheme", package: "AnsibleTheme", condition: nil),
                .product(name: "ColorPalette", package: "ColorPalette", condition: nil),
                .product(name: "InAppSettings", package: "InAppSettings", condition: nil),
                .product(name: "ThemeSettings", package: "ThemeSettings", condition: nil)
            ]
        ),
    ]
)
