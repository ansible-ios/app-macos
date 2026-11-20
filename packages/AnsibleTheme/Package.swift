// swift-tools-version:5.5

import PackageDescription

let dependencies: [Target.Dependency] = [
    .product(name: "AnsibleUIKit", package: "AnsibleUIKit", condition: nil),
    .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
    .product(name: "TelegramCore", package: "TelegramCore", condition: nil),
    .product(name: "Postbox", package: "Postbox", condition: nil),
    .product(name: "ColorPalette", package: "ColorPalette", condition: nil),
    .product(name: "ThemeSettings", package: "ThemeSettings", condition: nil),
    .product(name: "AnsibleIconsTheme", package: "AnsibleIconsTheme", condition: nil),
    .product(name: "InAppSettings", package: "InAppSettings", condition: nil),
    .product(name: "FoundationUtils", package: "FoundationUtils", condition: nil),
    .product(name: "Localization", package: "Localization", condition: nil),
    .product(name: "GZIP", package: "GZIP", condition: nil),
    .product(name: "Svg", package: "Svg", condition: nil),
    .product(name: "ApiCredentials", package: "ApiCredentials", condition: nil),
]

let package = Package(
    name: "AnsibleTheme",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "AnsibleTheme", targets: ["AnsibleTheme"]),
        .library(name: "AnsibleThemeShare", targets: ["AnsibleThemeShare"]),
    ],
    dependencies: [
        .package(name: "SSignalKit", path: "../../submodules/ansible-ios/submodules/SSignalKit"),
        .package(name: "TelegramCore", path: "../../submodules/ansible-ios/submodules/TelegramCore"),
        .package(name: "Postbox", path: "../../submodules/ansible-ios/submodules/Postbox"),
        .package(name: "AnsibleUIKit", path: "../AnsibleUIKit"),
        .package(name: "ColorPalette", path: "../ColorPalette"),
        .package(name: "ThemeSettings", path: "../ThemeSettings"),
        .package(name: "AnsibleIconsTheme", path: "../AnsibleIconsTheme"),
        .package(name: "InAppSettings", path: "../InAppSettings"),
        .package(name: "FoundationUtils", path: "../FoundationUtils"),
        .package(name: "Localization", path: "../Localization"),
        .package(name: "GZIP", path: "../GZIP"),
        .package(name: "Svg", path: "../Svg"),
        .package(name: "ApiCredentials", path: "../ApiCredentials"),
    ],
    targets: [
        .target(
            name: "AnsibleTheme",
            dependencies: dependencies,
            path: "Sources/AnsibleTheme"),
        .target(
            name: "AnsibleThemeShare",
            dependencies: dependencies,
            path: "Sources/AnsibleThemeShare",
            swiftSettings: [.define("SHARE")]),
    ]
)
