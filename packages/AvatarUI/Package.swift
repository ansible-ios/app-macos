// swift-tools-version:5.5

import PackageDescription

let common: [Target.Dependency] = [
    .product(name: "TGUIKit", package: "TGUIKit"),
    .product(name: "SwiftSignalKit", package: "SSignalKit"),
    .product(name: "TelegramCore", package: "TelegramCore"),
    .product(name: "Postbox", package: "Postbox"),
]

let package = Package(
    name: "AvatarUI",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "AvatarUI", targets: ["AvatarUI"]),
        .library(name: "AvatarUIShare", targets: ["AvatarUIShare"]),
    ],
    dependencies: [
        .package(name: "rnoise", path: "../../submodules/ansible-ios/third-party/rnnoise"),
        .package(name: "ColorPalette", path: "../ColorPalette"),
        .package(name: "TGUIKit", path: "../TGUIKit"),
        .package(name: "SSignalKit", path: "../../submodules/ansible-ios/submodules/SSignalKit"),
        .package(name: "TelegramCore", path: "../../submodules/ansible-ios/submodules/TelegramCore"),
        .package(name: "Postbox", path: "../../submodules/ansible-ios/submodules/Postbox"),
        .package(name: "AnsibleUtils", path: "../AnsibleUtils"),
        .package(name: "AnsibleTheme", path: "../AnsibleTheme"),
        .package(name: "AnsibleContext", path: "../AnsibleContext"),
    ],
    targets: [
        .target(
            name: "AvatarUI",
            dependencies: common + [
                .product(name: "AnsibleTheme", package: "AnsibleTheme"),
                .product(name: "AnsibleContext", package: "AnsibleContext"),
                .product(name: "AnsibleUtils", package: "AnsibleUtils"),
            ]),
        .target(
            name: "AvatarUIShare",
            dependencies: common + [
                .product(name: "AnsibleThemeShare", package: "AnsibleTheme"),
                .product(name: "AnsibleUtilsShare", package: "AnsibleUtils"),
            ],
            swiftSettings: [.define("SHARE")]),
        .testTarget(name: "AvatarUITests", dependencies: [
            "AvatarUI",
            .product(name: "rnoise", package: "rnoise"),
            .product(name: "TGUIKit", package: "TGUIKit"),
            .product(name: "ColorPalette", package: "ColorPalette"),
            .product(name: "Postbox", package: "Postbox"),
            .product(name: "TelegramCore", package: "TelegramCore"),
        ]),
    ]
)
