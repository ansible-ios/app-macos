// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "ChatModeTypes",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "ChatModeTypes", targets: ["ChatModeTypes"]),
    ],
    dependencies: [
        .package(name: "SSignalKit", path: "../../submodules/ansible-ios/submodules/SSignalKit"),
        .package(name: "TelegramCore", path: "../../submodules/ansible-ios/submodules/TelegramCore"),
        .package(name: "Postbox", path: "../../submodules/ansible-ios/submodules/Postbox"),
        .package(name: "TGUIKit", path: "../TGUIKit"),
        .package(name: "Localization", path: "../Localization"),
        .package(name: "AnsibleUtils", path: "../AnsibleUtils"),
        .package(name: "InputView", path: "../InputView"),
        .package(name: "AnsibleLinks", path: "../AnsibleLinks"),
        .package(name: "InAppSettings", path: "../InAppSettings"),
        .package(name: "AnsibleContext", path: "../AnsibleContext"),
        .package(name: "AnsibleTheme", path: "../AnsibleTheme"),
    ],
    targets: [
        .target(
            name: "ChatModeTypes",
            dependencies: [
                .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
                .product(name: "TelegramCore", package: "TelegramCore", condition: nil),
                .product(name: "Postbox", package: "Postbox", condition: nil),
                .product(name: "TGUIKit", package: "TGUIKit", condition: nil),
                .product(name: "Localization", package: "Localization", condition: nil),
                .product(name: "AnsibleUtils", package: "AnsibleUtils", condition: nil),
                .product(name: "InputView", package: "InputView", condition: nil),
                .product(name: "AnsibleLinks", package: "AnsibleLinks", condition: nil),
                .product(name: "InAppSettings", package: "InAppSettings", condition: nil),
                .product(name: "AnsibleContext", package: "AnsibleContext", condition: nil),
                .product(name: "AnsibleTheme", package: "AnsibleTheme", condition: nil),
            ],
            path: "Sources/ChatModeTypes"),
    ]
)
