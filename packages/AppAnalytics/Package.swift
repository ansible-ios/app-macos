// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "AppAnalytics",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "AppAnalytics", targets: ["AppAnalytics"]),
    ],
    dependencies: [
        .package(name: "SSignalKit", path: "../../submodules/ansible-ios/submodules/SSignalKit"),
        .package(name: "TelegramCore", path: "../../submodules/ansible-ios/submodules/TelegramCore"),
        .package(name: "Postbox", path: "../../submodules/ansible-ios/submodules/Postbox"),
        .package(name: "AnsibleUIKit", path: "../AnsibleUIKit"),
    ],
    targets: [
        .target(
            name: "AppAnalytics",
            dependencies: [
                .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
                .product(name: "TelegramCore", package: "TelegramCore", condition: nil),
                .product(name: "Postbox", package: "Postbox", condition: nil),
                .product(name: "AnsibleUIKit", package: "AnsibleUIKit", condition: nil),
            ],
            path: "Sources/AppAnalytics"),
        .testTarget(
            name: "AppAnalyticsTests",
            dependencies: [
                "AppAnalytics",
                .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
                .product(name: "TelegramCore", package: "TelegramCore", condition: nil),
                .product(name: "AnsibleUIKit", package: "AnsibleUIKit", condition: nil),
            ],
            path: "Tests/AppAnalyticsTests"),
    ]
)
