// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "ModalMorphLab",
    platforms: [.macOS(.v12)],
    dependencies: [
        .package(name: "AnsibleUIKit", path: "../../../packages/AnsibleUIKit"),
    ],
    targets: [
        .executableTarget(
            name: "ModalMorphLab",
            dependencies: [
                .product(name: "AnsibleUIKit", package: "AnsibleUIKit"),
            ],
            path: "Sources"),
    ]
)
