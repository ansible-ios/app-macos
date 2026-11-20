// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "ExternalVideoUtils",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "ExternalVideoUtils", targets: ["ExternalVideoUtils"]),
    ],
    dependencies: [
        .package(name: "SSignalKit", path: "../../submodules/ansible-ios/submodules/SSignalKit"),
        .package(name: "TelegramCore", path: "../../submodules/ansible-ios/submodules/TelegramCore"),
        .package(name: "Postbox", path: "../../submodules/ansible-ios/submodules/Postbox"),
        .package(name: "ObjcUtils", path: "../ObjcUtils"),
        .package(name: "InAppVideoServices", path: "../InAppVideoServices"),
        .package(name: "AnsibleUIKit", path: "../AnsibleUIKit"),
        .package(name: "AnsibleTheme", path: "../AnsibleTheme"),
    ],
    targets: [
        .target(
            name: "ExternalVideoUtils",
            dependencies: [
                .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
                .product(name: "TelegramCore", package: "TelegramCore", condition: nil),
                .product(name: "Postbox", package: "Postbox", condition: nil),
                .product(name: "ObjcUtils", package: "ObjcUtils", condition: nil),
                .product(name: "InAppVideoServices", package: "InAppVideoServices", condition: nil),
                .product(name: "AnsibleUIKit", package: "AnsibleUIKit", condition: nil),
                .product(name: "AnsibleTheme", package: "AnsibleTheme", condition: nil),
            ],
            path: "Sources/ExternalVideoUtils"),
    ]
)
