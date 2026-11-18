// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "QRCodeUtils",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "QRCodeUtils", targets: ["QRCodeUtils"]),
    ],
    dependencies: [
        .package(name: "SSignalKit", path: "../../submodules/ansible-ios/submodules/SSignalKit"),
        .package(name: "TGUIKit", path: "../TGUIKit"),
        .package(name: "AnsibleMediaUtils", path: "../AnsibleMediaUtils"),
    ],
    targets: [
        .target(
            name: "QRCodeUtils",
            dependencies: [
                .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
                .product(name: "TGUIKit", package: "TGUIKit", condition: nil),
                .product(name: "AnsibleMediaUtils", package: "AnsibleMediaUtils", condition: nil),
            ],
            path: "Sources/QRCodeUtils"),
    ]
)
