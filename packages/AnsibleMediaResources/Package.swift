// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "AnsibleMediaResources",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(
            name: "AnsibleMediaResources",
            targets: ["AnsibleMediaResources"]),
    ],
    dependencies: [
        .package(name: "Colors", path: "../Colors"),
        .package(name: "Postbox", path: "../../submodules/ansible-ios/submodules/Postbox"),
        .package(name: "SSignalKit", path: "../../submodules/ansible-ios/submodules/SSignalKit"),
        .package(name: "TelegramCore", path: "../../submodules/ansible-ios/submodules/TelegramCore")
    ],
    targets: [
        .target(
            name: "AnsibleMediaResources",
            dependencies: [
                .product(name: "Colors", package: "Colors", condition: nil),
                .product(name: "Postbox", package: "Postbox", condition: nil),
                .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
                .product(name: "TelegramCore", package: "TelegramCore", condition: nil)
            ]),
    ]
)
