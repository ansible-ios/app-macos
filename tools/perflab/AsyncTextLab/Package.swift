// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "AsyncTextLab",
    platforms: [.macOS(.v10_15)],
    dependencies: [.package(path: "../../../packages/AnsibleUIKit")],
    targets: [
        .target(name: "AsyncTextHarness", dependencies: ["AnsibleUIKit"]),
        .testTarget(name: "AsyncTextTests", dependencies: ["AsyncTextHarness", "AnsibleUIKit"])
    ]
)
