// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "MergeRetileLab",
    platforms: [.macOS(.v10_15)],
    dependencies: [.package(path: "../../../packages/AnsibleUIKit")],
    targets: [
        .target(name: "MergeHarness", dependencies: ["AnsibleUIKit"]),
        .testTarget(name: "MergeTests", dependencies: ["MergeHarness", "AnsibleUIKit"])
    ]
)
