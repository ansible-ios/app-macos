// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "ChangePhoneNumberUI",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "ChangePhoneNumberUI", targets: ["ChangePhoneNumberUI"]),
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
        .package(name: "AlertsUI", path: "../AlertsUI"),
        .package(name: "AnsibleMedia", path: "../AnsibleMedia"),
        .package(name: "PhoneNumberUtils", path: "../PhoneNumberUtils"),
        .package(name: "LocalAnimations", path: "../LocalAnimations"),
        .package(name: "PhoneInputUI", path: "../PhoneInputUI"),
    ],
    targets: [
        .target(
            name: "ChangePhoneNumberUI",
            dependencies: [
                .product(name: "AnsibleUIKit", package: "AnsibleUIKit", condition: nil),
                .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
                .product(name: "TelegramCore", package: "TelegramCore", condition: nil),
                .product(name: "Postbox", package: "Postbox", condition: nil),
                .product(name: "ColorPalette", package: "ColorPalette", condition: nil),
                .product(name: "Localization", package: "Localization", condition: nil),
                .product(name: "AnsibleTheme", package: "AnsibleTheme", condition: nil),
                .product(name: "AnsibleContext", package: "AnsibleContext", condition: nil),
                .product(name: "AnsibleUtils", package: "AnsibleUtils", condition: nil),
                .product(name: "AlertsUI", package: "AlertsUI", condition: nil),
                .product(name: "AnsibleMedia", package: "AnsibleMedia", condition: nil),
                .product(name: "PhoneNumberUtils", package: "PhoneNumberUtils", condition: nil),
                .product(name: "LocalAnimations", package: "LocalAnimations", condition: nil),
                .product(name: "PhoneInputUI", package: "PhoneInputUI", condition: nil),
            ],
            path: "Sources/ChangePhoneNumberUI"),
    ]
)
