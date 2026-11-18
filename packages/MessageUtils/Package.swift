// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "MessageUtils",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "MessageUtils", targets: ["MessageUtils"]),
    ],
    dependencies: [
        .package(name: "SSignalKit", path: "../../submodules/ansible-ios/submodules/SSignalKit"),
        .package(name: "TelegramCore", path: "../../submodules/ansible-ios/submodules/TelegramCore"),
        .package(name: "Postbox", path: "../../submodules/ansible-ios/submodules/Postbox"),
        .package(name: "Localization", path: "../Localization"),
        .package(name: "AnsibleTheme", path: "../AnsibleTheme"),
        .package(name: "AnsibleUtils", path: "../AnsibleUtils"),
        .package(name: "InAppSettings", path: "../InAppSettings"),
        .package(name: "AnsibleMediaUtils", path: "../AnsibleMediaUtils"),
        .package(name: "ChatModeTypes", path: "../ChatModeTypes"),
        .package(name: "AnsibleContext", path: "../AnsibleContext"),
    ],
    targets: [
        .target(
            name: "MessageUtils",
            dependencies: [
                .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
                .product(name: "TelegramCore", package: "TelegramCore", condition: nil),
                .product(name: "Postbox", package: "Postbox", condition: nil),
                .product(name: "Localization", package: "Localization", condition: nil),
                .product(name: "AnsibleTheme", package: "AnsibleTheme", condition: nil),
                .product(name: "AnsibleUtils", package: "AnsibleUtils", condition: nil),
                .product(name: "InAppSettings", package: "InAppSettings", condition: nil),
                .product(name: "AnsibleMediaUtils", package: "AnsibleMediaUtils", condition: nil),
                .product(name: "ChatModeTypes", package: "ChatModeTypes", condition: nil),
                .product(name: "AnsibleContext", package: "AnsibleContext", condition: nil),
            ],
            path: "Sources/MessageUtils"),
    ]
)
