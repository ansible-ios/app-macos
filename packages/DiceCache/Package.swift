// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "DiceCache",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "DiceCache", targets: ["DiceCache"]),
    ],
    dependencies: [
        .package(name: "SSignalKit", path: "../../submodules/ansible-ios/submodules/SSignalKit"),
        .package(name: "TelegramCore", path: "../../submodules/ansible-ios/submodules/TelegramCore"),
        .package(name: "Postbox", path: "../../submodules/ansible-ios/submodules/Postbox"),
        .package(name: "AnsibleTheme", path: "../AnsibleTheme"),
        .package(name: "FoundationUtils", path: "../FoundationUtils"),
    ],
    targets: [
        .target(
            name: "DiceCache",
            dependencies: [
                .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
                .product(name: "TelegramCore", package: "TelegramCore", condition: nil),
                .product(name: "Postbox", package: "Postbox", condition: nil),
                .product(name: "AnsibleTheme", package: "AnsibleTheme", condition: nil),
                .product(name: "FoundationUtils", package: "FoundationUtils", condition: nil),
            ],
            path: "Sources/DiceCache"),
    ]
)
