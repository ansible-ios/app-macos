// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "TextButtonLab",
    platforms: [.macOS(.v10_15)],
    dependencies: [.package(path: "../../../packages/AnsibleUIKit")],
    targets: [.executableTarget(name: "TextButtonLab", dependencies: ["AnsibleUIKit"])]
)
