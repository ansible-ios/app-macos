// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "WidgetResizeLab",
    platforms: [.macOS(.v12)],
    dependencies: [
        .package(name: "AnsibleUIKit", path: "../../../packages/AnsibleUIKit"),
    ],
    targets: [
        .executableTarget(
            name: "WidgetResizeLab",
            dependencies: [
                .product(name: "AnsibleUIKit", package: "AnsibleUIKit"),
            ],
            path: "Sources"),
    ]
)
