// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "CalendarUI",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "CalendarUI", targets: ["CalendarUI"]),
    ],
    dependencies: [
        .package(name: "SSignalKit", path: "../../submodules/ansible-ios/submodules/SSignalKit"),
        .package(name: "TelegramCore", path: "../../submodules/ansible-ios/submodules/TelegramCore"),
        .package(name: "Postbox", path: "../../submodules/ansible-ios/submodules/Postbox"),
        .package(name: "TGUIKit", path: "../TGUIKit"),
        .package(name: "Localization", path: "../Localization"),
        .package(name: "AnsibleTheme", path: "../AnsibleTheme"),
        .package(name: "GeneralRows", path: "../GeneralRows"),
        .package(name: "CalendarUtils", path: "../CalendarUtils"),
        .package(name: "AnsibleContext", path: "../AnsibleContext"),
        .package(name: "AnsibleMediaUtils", path: "../AnsibleMediaUtils"),
        .package(name: "AlertsUI", path: "../AlertsUI"),
    ],
    targets: [
        .target(
            name: "CalendarUI",
            dependencies: [
                .product(name: "TGUIKit", package: "TGUIKit", condition: nil),
                .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
                .product(name: "TelegramCore", package: "TelegramCore", condition: nil),
                .product(name: "Postbox", package: "Postbox", condition: nil),
                .product(name: "Localization", package: "Localization", condition: nil),
                .product(name: "AnsibleTheme", package: "AnsibleTheme", condition: nil),
                .product(name: "GeneralRows", package: "GeneralRows", condition: nil),
                .product(name: "CalendarUtils", package: "CalendarUtils", condition: nil),
                .product(name: "AnsibleContext", package: "AnsibleContext"),
                .product(name: "AnsibleMediaUtils", package: "AnsibleMediaUtils"),
                .product(name: "AlertsUI", package: "AlertsUI"),
            ],
            path: "Sources/CalendarUI"),
    ]
)
