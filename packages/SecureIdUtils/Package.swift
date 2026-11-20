// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "SecureIdUtils",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "SecureIdUtils", targets: ["SecureIdUtils"]),
    ],
    dependencies: [
        .package(name: "SSignalKit", path: "../../submodules/ansible-ios/submodules/SSignalKit"),
        .package(name: "TelegramCore", path: "../../submodules/ansible-ios/submodules/TelegramCore"),
        .package(name: "Postbox", path: "../../submodules/ansible-ios/submodules/Postbox"),
        .package(name: "Localization", path: "../Localization"),
        .package(name: "AnsibleTheme", path: "../AnsibleTheme"),
        .package(name: "AnsiblePassportMRZ", path: "../AnsiblePassportMRZ"),
    ],
    targets: [
        .target(
            name: "SecureIdUtils",
            dependencies: [
                .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
                .product(name: "TelegramCore", package: "TelegramCore", condition: nil),
                .product(name: "Postbox", package: "Postbox", condition: nil),
                .product(name: "Localization", package: "Localization", condition: nil),
                .product(name: "AnsibleTheme", package: "AnsibleTheme", condition: nil),
                .product(name: "AnsiblePassportMRZ", package: "AnsiblePassportMRZ", condition: nil),
            ],
            path: "Sources/SecureIdUtils"),
    ]
)
