// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "FolderSharingUI",
    platforms: [.macOS(.v10_13)],
    products: [.library(name: "FolderSharingUI", targets: ["FolderSharingUI"])],
    dependencies: [
        .package(name: "InputDataUI", path: "../InputDataUI"),
        .package(name: "GeneralRows", path: "../GeneralRows"),
        .package(name: "AnsibleContext", path: "../AnsibleContext"),
        .package(name: "AnsibleTheme", path: "../AnsibleTheme"),
        .package(name: "Localization", path: "../Localization"),
        .package(name: "AnsibleUIKit", path: "../AnsibleUIKit"),
        .package(name: "AppAnalytics", path: "../AppAnalytics"),
        .package(name: "SSignalKit", path: "../../submodules/ansible-ios/submodules/SSignalKit"),
        .package(name: "TelegramCore", path: "../../submodules/ansible-ios/submodules/TelegramCore"),
        .package(name: "Postbox", path: "../../submodules/ansible-ios/submodules/Postbox")
    ],
    targets: [
        .target(name: "FolderSharingUI", dependencies: [
            .product(name: "InputDataUI", package: "InputDataUI"),
            .product(name: "GeneralRows", package: "GeneralRows"),
            .product(name: "AnsibleContext", package: "AnsibleContext"),
            .product(name: "AnsibleTheme", package: "AnsibleTheme"),
            .product(name: "Localization", package: "Localization"),
            .product(name: "AnsibleUIKit", package: "AnsibleUIKit"),
            .product(name: "AppAnalytics", package: "AppAnalytics"),
            .product(name: "SwiftSignalKit", package: "SSignalKit"),
            .product(name: "TelegramCore", package: "TelegramCore"),
            .product(name: "Postbox", package: "Postbox")
        ]),
        .testTarget(name: "FolderSharingUITests", dependencies: ["FolderSharingUI"])
    ]
)
