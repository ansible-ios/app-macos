// swift-tools-version:5.5

import PackageDescription

let deps: [(String, String)] = [
    ("AnsibleUtils", "../AnsibleUtils"),
    ("AnsibleMedia", "../AnsibleMedia"),
    ("AnsibleMediaResources", "../AnsibleMediaResources"),
    ("InlineStickers", "../InlineStickers"),
    ("InputView", "../InputView"),
    ("AnsibleUIKit", "../AnsibleUIKit"),
    ("AnsibleTheme", "../AnsibleTheme"),
    ("AnsibleContext", "../AnsibleContext"),
    ("ColorPalette", "../ColorPalette"),
    ("LokiRng", "../../submodules/ansible-ios/submodules/Utils/LokiRng"),
]

let package = Package(
    name: "InlineStickerLayer",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "InlineStickerLayer", targets: ["InlineStickerLayer"]),
    ],
    dependencies: [
        .package(name: "SSignalKit", path: "../../submodules/ansible-ios/submodules/SSignalKit"),
        .package(name: "TelegramCore", path: "../../submodules/ansible-ios/submodules/TelegramCore"),
        .package(name: "Postbox", path: "../../submodules/ansible-ios/submodules/Postbox"),
    ] + deps.map { .package(name: $0.0, path: $0.1) },
    targets: [
        .target(
            name: "InlineStickerLayer",
            dependencies: [
                .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
                .product(name: "TelegramCore", package: "TelegramCore", condition: nil),
                .product(name: "Postbox", package: "Postbox", condition: nil),
            ] + deps.map { .product(name: $0.0, package: $0.0, condition: nil) },
            path: "Sources/InlineStickerLayer"),
    ]
)
