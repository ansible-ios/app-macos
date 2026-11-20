// swift-tools-version:5.5

import PackageDescription

let deps: [(String, String)] = [
    ("AnsibleUIKit", "../AnsibleUIKit"),
    ("InAppSettings", "../InAppSettings"),
    ("Localization", "../Localization"),
    ("AnsibleTheme", "../AnsibleTheme"),
    ("AnsibleContext", "../AnsibleContext"),
    ("AnsibleUtils", "../AnsibleUtils"),
    ("AnsibleMediaUtils", "../AnsibleMediaUtils"),
    ("AnsibleMedia", "../AnsibleMedia"),
    ("ChatModeTypes", "../ChatModeTypes"),
    ("MessageUtils", "../MessageUtils"),
    ("LocalAnimations", "../LocalAnimations"),
    ("GeneralRows", "../GeneralRows"),
    ("AudioPlayerCore", "../AudioPlayerCore"),
    ("ChatHistoryModel", "../ChatHistoryModel"),
    ("GalleryUI", "../GalleryUI"),
    ("ChatUI", "../ChatUI"),
    ("PeerMediaUI", "../PeerMediaUI"),
    ("RangeSet", "../../submodules/ansible-ios/submodules/Utils/RangeSet"),
]

let package = Package(
    name: "AudioPlayerUI",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "AudioPlayerUI", targets: ["AudioPlayerUI"]),
    ],
    dependencies: [
        .package(name: "SSignalKit", path: "../../submodules/ansible-ios/submodules/SSignalKit"),
        .package(name: "TelegramCore", path: "../../submodules/ansible-ios/submodules/TelegramCore"),
        .package(name: "Postbox", path: "../../submodules/ansible-ios/submodules/Postbox"),
    ] + deps.map { .package(name: $0.0, path: $0.1) },
    targets: [
        .target(
            name: "AudioPlayerUI",
            dependencies: [
                .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
                .product(name: "TelegramCore", package: "TelegramCore", condition: nil),
                .product(name: "Postbox", package: "Postbox", condition: nil),
            ] + deps.map { .product(name: $0.0, package: $0.0, condition: nil) },
            path: "Sources/AudioPlayerUI"),
    ]
)
