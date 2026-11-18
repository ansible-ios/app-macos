// swift-tools-version:5.5

import PackageDescription

let common: [Target.Dependency] = [
    .product(name: "FastBlur", package: "FastBlur"),
    .product(name: "Strings", package: "Strings"),
    .product(name: "CalendarUtils", package: "CalendarUtils"),
    .product(name: "DateUtils", package: "DateUtils"),
    .product(name: "TGUIKit", package: "TGUIKit", condition: nil),
    .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
    .product(name: "TelegramCore", package: "TelegramCore", condition: nil),
    .product(name: "Postbox", package: "Postbox", condition: nil),
    .product(name: "ColorPalette", package: "ColorPalette", condition: nil),
    .product(name: "InAppSettings", package: "InAppSettings", condition: nil),
    .product(name: "FoundationUtils", package: "FoundationUtils", condition: nil),
    .product(name: "Localization", package: "Localization", condition: nil),
    .product(name: "libphonenumber", package: "libphonenumber", condition: nil),
    .product(name: "AnsibleMediaResources", package: "AnsibleMediaResources", condition: nil),
    .product(name: "Mozjpeg", package: "Mozjpeg", condition: nil),
    .product(name: "CurrencyFormat", package: "CurrencyFormat", condition: nil),
]

let package = Package(
    name: "AnsibleUtils",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "AnsibleUtils", targets: ["AnsibleUtils"]),
        .library(name: "AnsibleUtilsShare", targets: ["AnsibleUtilsShare"]),
    ],
    dependencies: [
        .package(name: "FastBlur", path: "../FastBlur"),
        .package(name: "Strings", path: "../Strings"),
        .package(name: "CalendarUtils", path: "../CalendarUtils"),
        .package(name: "DateUtils", path: "../DateUtils"),
        .package(name: "ObjcUtils", path: "../ObjcUtils"),
        .package(name: "SSignalKit", path: "../../submodules/ansible-ios/submodules/SSignalKit"),
        .package(name: "TelegramCore", path: "../../submodules/ansible-ios/submodules/TelegramCore"),
        .package(name: "InlineStickers", path: "../InlineStickers"),
        .package(name: "Postbox", path: "../../submodules/ansible-ios/submodules/Postbox"),
        .package(name: "TGUIKit", path: "../TGUIKit"),
        .package(name: "ColorPalette", path: "../ColorPalette"),
        .package(name: "InAppSettings", path: "../InAppSettings"),
        .package(name: "FoundationUtils", path: "../FoundationUtils"),
        .package(name: "Localization", path: "../Localization"),
        .package(name: "libphonenumber", path: "../../submodules/ansible-ios/submodules/libphonenumber"),
        .package(name: "AnsibleContext", path: "../AnsibleContext"),
        .package(name: "AnsibleMediaResources", path: "../AnsibleMediaResources"),
        .package(name: "Mozjpeg", path: "../../submodules/Mozjpeg"),
        .package(name: "CurrencyFormat", path: "../CurrencyFormat"),
        .package(name: "AnsibleTheme", path: "../AnsibleTheme"),
    ],
    targets: [
        .target(
            name: "AnsibleUtils",
            dependencies: common + [.product(name: "ObjcUtils", package: "ObjcUtils"),
                                    .product(name: "AnsibleTheme", package: "AnsibleTheme", condition: nil),
                                    .product(name: "InlineStickers", package: "InlineStickers", condition: nil),
                                    .product(name: "AnsibleContext", package: "AnsibleContext", condition: nil)],
            path: "Sources/AnsibleUtils"),
        .target(
            name: "AnsibleUtilsShare",
            dependencies: common + [.product(name: "AnsibleThemeShare", package: "AnsibleTheme", condition: nil),
                                    .product(name: "AnsibleContextShare", package: "AnsibleContext", condition: nil)],
            path: "Sources/AnsibleUtilsShare",
            swiftSettings: [.define("SHARE")]),
        .testTarget(
            name: "AnsibleUtilsTests",
            dependencies: ["AnsibleUtils", .product(name: "TelegramCore", package: "TelegramCore"), .product(name: "Postbox", package: "Postbox")],
            path: "Tests/AnsibleUtilsTests"),
    ]
)
