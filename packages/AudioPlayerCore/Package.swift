// swift-tools-version:5.5

import PackageDescription

let deps: [(String, String)] = [
    ("AnsibleUIKit", "../AnsibleUIKit"),
    ("Localization", "../Localization"),
    ("AnsibleTheme", "../AnsibleTheme"),
    ("AnsibleContext", "../AnsibleContext"),
    ("AnsibleUtils", "../AnsibleUtils"),
    ("AnsibleMediaUtils", "../AnsibleMediaUtils"),
    ("AnsibleMedia", "../AnsibleMedia"),
    ("ChatModeTypes", "../ChatModeTypes"),
    ("MessageUtils", "../MessageUtils"),
    ("RangeSet", "../../submodules/ansible-ios/submodules/Utils/RangeSet"),
    ("AnsibleMediaResources", "../../submodules/ansible-ios/submodules/AnsibleMediaResources"),
]

let package = Package(
    name: "AudioPlayerCore",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "AudioPlayerCore", targets: ["AudioPlayerCore"]),
    ],
    dependencies: [
        .package(name: "SSignalKit", path: "../../submodules/ansible-ios/submodules/SSignalKit"),
        .package(name: "TelegramCore", path: "../../submodules/ansible-ios/submodules/TelegramCore"),
        .package(name: "Postbox", path: "../../submodules/ansible-ios/submodules/Postbox"),
        .package(name: "TelegramMediaPlayer", path: "../../submodules/ansible-ios/submodules/MediaPlayer"),
    ] + deps.map { .package(name: $0.0, path: $0.1) },
    targets: [
        .target(
            name: "AudioPlayerCore",
            dependencies: [
                .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
                .product(name: "TelegramCore", package: "TelegramCore", condition: nil),
                .product(name: "Postbox", package: "Postbox", condition: nil),
            ] + deps.map { .product(name: $0.0, package: $0.0, condition: nil) },
            path: "Sources/AudioPlayerCore"),
        .testTarget(
            name: "AudioPlayerCoreTests",
            dependencies: [
                "AudioPlayerCore",
                .product(name: "AnsibleMedia", package: "AnsibleMedia"),
                .product(name: "SwiftSignalKit", package: "SSignalKit"),
                .product(name: "Postbox", package: "Postbox"),
                .product(name: "TelegramMediaPlayer", package: "TelegramMediaPlayer"),
            ],
            path: "Tests/AudioPlayerCoreTests"),
    ]
)
