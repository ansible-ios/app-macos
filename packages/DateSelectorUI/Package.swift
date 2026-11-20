// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "DateSelectorUI",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "DateSelectorUI", targets: ["DateSelectorUI"]),
    ],
    dependencies: [
        .package(name: "SSignalKit", path: "../../submodules/ansible-ios/submodules/SSignalKit"),
        .package(name: "TelegramCore", path: "../../submodules/ansible-ios/submodules/TelegramCore"),
        .package(name: "Postbox", path: "../../submodules/ansible-ios/submodules/Postbox"),
        .package(name: "AnsibleUIKit", path: "../AnsibleUIKit"),
        .package(name: "ColorPalette", path: "../ColorPalette"),
        .package(name: "Localization", path: "../Localization"),
        .package(name: "AnsibleTheme", path: "../AnsibleTheme"),
        .package(name: "AnsibleContext", path: "../AnsibleContext"),
        .package(name: "AnsibleUtils", path: "../AnsibleUtils"),
        .package(name: "GeneralRows", path: "../GeneralRows"),
        .package(name: "InputDataUI", path: "../InputDataUI"),
        .package(name: "CalendarUtils", path: "../CalendarUtils"),
        .package(name: "CalendarUI", path: "../CalendarUI"),
        .package(name: "DateUtils", path: "../DateUtils"),
        .package(name: "AppAnalytics", path: "../AppAnalytics"),
    ],
    targets: [
        .target(
            name: "DateSelectorUI",
            dependencies: [
                .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
                .product(name: "TelegramCore", package: "TelegramCore", condition: nil),
                .product(name: "Postbox", package: "Postbox", condition: nil),
                .product(name: "AnsibleUIKit", package: "AnsibleUIKit", condition: nil),
                .product(name: "ColorPalette", package: "ColorPalette", condition: nil),
                .product(name: "Localization", package: "Localization", condition: nil),
                .product(name: "AnsibleTheme", package: "AnsibleTheme", condition: nil),
                .product(name: "AnsibleContext", package: "AnsibleContext", condition: nil),
                .product(name: "AnsibleUtils", package: "AnsibleUtils", condition: nil),
                .product(name: "GeneralRows", package: "GeneralRows", condition: nil),
                .product(name: "InputDataUI", package: "InputDataUI", condition: nil),
                .product(name: "CalendarUtils", package: "CalendarUtils", condition: nil),
                .product(name: "CalendarUI", package: "CalendarUI", condition: nil),
                .product(name: "DateUtils", package: "DateUtils", condition: nil),
                .product(name: "AppAnalytics", package: "AppAnalytics", condition: nil),
            ],
            path: "Sources/DateSelectorUI"),
    ]
)
