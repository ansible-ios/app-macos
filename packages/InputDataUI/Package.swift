// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "InputDataUI",
    platforms: [.macOS(.v10_13)],
    products: [.library(name: "InputDataUI", targets: ["InputDataUI"])],
    dependencies: [
        .package(name: "ColorPalette", path: "../ColorPalette"),
        .package(name: "GeneralRows", path: "../GeneralRows"),
        .package(name: "AnsibleContext", path: "../AnsibleContext"),
        .package(name: "AnsibleTheme", path: "../AnsibleTheme"),
        .package(name: "AnsibleUtils", path: "../AnsibleUtils"),
        .package(name: "SecureIdUtils", path: "../SecureIdUtils"),
        .package(name: "Localization", path: "../Localization"),
        .package(name: "AnsibleUIKit", path: "../AnsibleUIKit"),
        .package(name: "AppAnalytics", path: "../AppAnalytics"),
        .package(name: "SSignalKit", path: "../../submodules/ansible-ios/submodules/SSignalKit"),
        .package(name: "TelegramCore", path: "../../submodules/ansible-ios/submodules/TelegramCore"),
        .package(name: "Postbox", path: "../../submodules/ansible-ios/submodules/Postbox"),
        .package(name: "AnsibleModernGrowingTextView", path: "../AnsibleModernGrowingTextView"),
        .package(name: "CalendarUtils", path: "../CalendarUtils"),
        .package(name: "KeyboardKey", path: "../KeyboardKey"),
        .package(name: "ObjcUtils", path: "../ObjcUtils"),
        .package(name: "InAppSettings", path: "../InAppSettings"),
        .package(name: "ThemeSettings", path: "../ThemeSettings"),
        .package(name: "rnoise", path: "../../submodules/ansible-ios/third-party/rnnoise"),
    ],
    targets: [
        .target(name: "InputDataUI", dependencies: [
            .product(name: "ColorPalette", package: "ColorPalette"),
            .product(name: "GeneralRows", package: "GeneralRows"),
            .product(name: "AnsibleContext", package: "AnsibleContext"),
            .product(name: "AnsibleTheme", package: "AnsibleTheme"),
            .product(name: "AnsibleUtils", package: "AnsibleUtils"),
            .product(name: "SecureIdUtils", package: "SecureIdUtils"),
            .product(name: "Localization", package: "Localization"),
            .product(name: "AnsibleUIKit", package: "AnsibleUIKit"),
            .product(name: "SwiftSignalKit", package: "SSignalKit"),
            .product(name: "TelegramCore", package: "TelegramCore"),
            .product(name: "Postbox", package: "Postbox"),
            .product(name: "AnsibleModernGrowingTextView", package: "AnsibleModernGrowingTextView"),
            .product(name: "CalendarUtils", package: "CalendarUtils"),
            .product(name: "KeyboardKey", package: "KeyboardKey"),
            .product(name: "ObjcUtils", package: "ObjcUtils"),
            .product(name: "AppAnalytics", package: "AppAnalytics"),
        ]),
        .testTarget(name: "InputDataUITests", dependencies: [
            "InputDataUI",
            .product(name: "AnsibleUIKit", package: "AnsibleUIKit"),
            .product(name: "GeneralRows", package: "GeneralRows"),
            .product(name: "AnsibleTheme", package: "AnsibleTheme"),
            .product(name: "ColorPalette", package: "ColorPalette"),
            .product(name: "InAppSettings", package: "InAppSettings"),
            .product(name: "ThemeSettings", package: "ThemeSettings"),
            .product(name: "rnoise", package: "rnoise"),
        ])
    ]
)
