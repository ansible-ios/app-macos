// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "ImageCanvasUI",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "ImageCanvasUI", targets: ["ImageCanvasUI"]),
    ],
    dependencies: [
        .package(name: "FFMpegBinding", path: "../../submodules/ansible-ios/submodules/FFMpegBinding"),
        .package(name: "AppAnalytics", path: "../AppAnalytics"),
        .package(name: "TGUIKit", path: "../TGUIKit"),
        .package(name: "ColorPalette", path: "../ColorPalette"),
        .package(name: "Localization", path: "../Localization"),
        .package(name: "AnsibleTheme", path: "../AnsibleTheme"),
        .package(name: "AnsibleMediaUtils", path: "../AnsibleMediaUtils"),
        .package(name: "AnsibleMedia", path: "../AnsibleMedia"),
        .package(name: "TelegramMediaPlayer", path: "../../submodules/ansible-ios/submodules/MediaPlayer"),
        .package(name: "AnsibleContext", path: "../AnsibleContext"),
        .package(name: "TextRecognizing", path: "../TextRecognizing"),
        .package(name: "SSignalKit", path: "../../submodules/ansible-ios/submodules/SSignalKit"),
    ],
    targets: [
        .target(
            name: "ImageCanvasUI",
            dependencies: [
                .product(name: "FFMpegBinding", package: "FFMpegBinding", condition: nil),
                .product(name: "AppAnalytics", package: "AppAnalytics", condition: nil),
                .product(name: "TGUIKit", package: "TGUIKit", condition: nil),
                .product(name: "ColorPalette", package: "ColorPalette", condition: nil),
                .product(name: "Localization", package: "Localization", condition: nil),
                .product(name: "AnsibleTheme", package: "AnsibleTheme", condition: nil),
                .product(name: "AnsibleMediaUtils", package: "AnsibleMediaUtils", condition: nil),
                .product(name: "AnsibleMedia", package: "AnsibleMedia", condition: nil),
                .product(name: "TelegramMediaPlayer", package: "TelegramMediaPlayer", condition: nil),
                .product(name: "AnsibleContext", package: "AnsibleContext", condition: nil),
                .product(name: "TextRecognizing", package: "TextRecognizing", condition: nil),
                .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
            ],
            path: "Sources/ImageCanvasUI",
            resources: [.process("Resources/Assets.xcassets")]),
    ]
)
