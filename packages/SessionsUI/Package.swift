// swift-tools-version:5.5

import PackageDescription

let deps: [(String, String)] = [
    ("AppAnalytics", "../AppAnalytics"),
    ("AnsibleUIKit", "../AnsibleUIKit"),
    ("GeneralRows", "../GeneralRows"),
    ("InputDataUI", "../InputDataUI"),
    ("AnsibleUtils", "../AnsibleUtils"),
    ("AnsibleTheme", "../AnsibleTheme"),
    ("Localization", "../Localization"),
    ("AnsibleContext", "../AnsibleContext"),
    ("AvatarUI", "../AvatarUI"),
    ("LocalAnimations", "../LocalAnimations"),
    ("AlertsUI", "../AlertsUI"),
    ("DateUtils", "../DateUtils"),
    ("ColorPalette", "../ColorPalette"),
    ("AnsibleIconsTheme", "../AnsibleIconsTheme"),
    ("ApiCredentials", "../ApiCredentials"),
]

let package = Package(
    name: "SessionsUI",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "SessionsUI", targets: ["SessionsUI"]),
    ],
    dependencies: [
        .package(name: "SSignalKit", path: "../../submodules/ansible-ios/submodules/SSignalKit"),
        .package(name: "TelegramCore", path: "../../submodules/ansible-ios/submodules/TelegramCore"),
        .package(name: "Postbox", path: "../../submodules/ansible-ios/submodules/Postbox"),
    ] + deps.map { .package(name: $0.0, path: $0.1) },
    targets: [
        .target(
            name: "SessionsUI",
            dependencies: [
                .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
                .product(name: "TelegramCore", package: "TelegramCore", condition: nil),
                .product(name: "Postbox", package: "Postbox", condition: nil),
            ] + deps.map { .product(name: $0.0, package: $0.0, condition: nil) },
            path: "Sources/SessionsUI"),
    ]
)
