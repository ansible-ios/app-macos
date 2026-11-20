// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "LocalAnimations",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "LocalAnimations", targets: ["LocalAnimations"]),
    ],
    dependencies: [
        .package(name: "TelegramCore", path: "../../submodules/ansible-ios/submodules/TelegramCore"),
        .package(name: "Postbox", path: "../../submodules/ansible-ios/submodules/Postbox"),
        .package(name: "AnsibleMedia", path: "../AnsibleMedia"),
        .package(name: "AnsibleMediaResources", path: "../AnsibleMediaResources"),
        .package(name: "InAppSettings", path: "../InAppSettings"),
        .package(name: "AnsibleUtils", path: "../AnsibleUtils"),
        .package(name: "SSignalKit", path: "../../submodules/ansible-ios/submodules/SSignalKit"),
        .package(name: "AnsibleContext", path: "../AnsibleContext"),
        .package(name: "AnsibleTheme", path: "../AnsibleTheme"),
        .package(name: "AnsibleUIKit", path: "../AnsibleUIKit"),
    ],
    targets: [
        .target(
            name: "LocalAnimations",
            dependencies: [
                .product(name: "TelegramCore", package: "TelegramCore", condition: nil),
                .product(name: "Postbox", package: "Postbox", condition: nil),
                .product(name: "AnsibleMedia", package: "AnsibleMedia", condition: nil),
                .product(name: "AnsibleMediaResources", package: "AnsibleMediaResources", condition: nil),
                .product(name: "InAppSettings", package: "InAppSettings", condition: nil),
                .product(name: "AnsibleUtils", package: "AnsibleUtils", condition: nil),
                .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
                .product(name: "AnsibleContext", package: "AnsibleContext", condition: nil),
                .product(name: "AnsibleTheme", package: "AnsibleTheme", condition: nil),
                .product(name: "AnsibleUIKit", package: "AnsibleUIKit", condition: nil),
            ],
            path: "Sources/LocalAnimations"),
    ]
)
