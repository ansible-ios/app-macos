// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "AnsibleLinks",
    platforms: [.macOS(.v10_13)],
    products: [.library(name: "AnsibleLinks", targets: ["AnsibleLinks"])],
    dependencies: [
        .package(name: "TelegramCore", path: "../../submodules/ansible-ios/submodules/TelegramCore"),
        .package(name: "Postbox", path: "../../submodules/ansible-ios/submodules/Postbox"),
        .package(name: "MtProtoKit", path: "../../submodules/ansible-ios/submodules/MtProtoKit"),
        .package(name: "Colors", path: "../Colors"),
        .package(name: "Strings", path: "../Strings"),
    ],
    targets: [
        .target(name: "AnsibleLinks", dependencies: [
            .product(name: "TelegramCore", package: "TelegramCore"),
            .product(name: "Postbox", package: "Postbox"),
            .product(name: "MtProtoKit", package: "MtProtoKit"),
            .product(name: "Colors", package: "Colors"),
            .product(name: "Strings", package: "Strings"),
        ]),
        .testTarget(name: "AnsibleLinksTests", dependencies: ["AnsibleLinks"]),
    ]
)
