// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "PhoneNumberUtils",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "PhoneNumberUtils", targets: ["PhoneNumberUtils"]),
    ],
    dependencies: [
        .package(name: "TelegramCore", path: "../../submodules/ansible-ios/submodules/TelegramCore"),
        .package(name: "libphonenumber", path: "../../submodules/ansible-ios/submodules/libphonenumber"),
        .package(name: "SSignalKit", path: "../../submodules/ansible-ios/submodules/SSignalKit"),
        .package(name: "AnsibleContext", path: "../AnsibleContext"),
    ],
    targets: [
        .target(
            name: "PhoneNumberUtils",
            dependencies: [
                .product(name: "TelegramCore", package: "TelegramCore", condition: nil),
                .product(name: "libphonenumber", package: "libphonenumber", condition: nil),
                .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
                .product(name: "AnsibleContext", package: "AnsibleContext", condition: nil),
            ],
            path: "Sources/PhoneNumberUtils"),
    ]
)
