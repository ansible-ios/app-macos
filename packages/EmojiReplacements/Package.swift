// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "EmojiReplacements",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "EmojiReplacements", targets: ["EmojiReplacements"]),
    ],
    dependencies: [
        .package(name: "SSignalKit", path: "../../submodules/ansible-ios/submodules/SSignalKit"),
        .package(name: "Postbox", path: "../../submodules/ansible-ios/submodules/Postbox"),
        .package(name: "AnsibleUIKit", path: "../AnsibleUIKit"),
        .package(name: "Strings", path: "../Strings"),
    ],
    targets: [
        .target(
            name: "EmojiReplacements",
            dependencies: [
                .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
                .product(name: "Postbox", package: "Postbox", condition: nil),
                .product(name: "AnsibleUIKit", package: "AnsibleUIKit", condition: nil),
                .product(name: "Strings", package: "Strings", condition: nil),
            ],
            path: "Sources/EmojiReplacements"),
    ]
)
