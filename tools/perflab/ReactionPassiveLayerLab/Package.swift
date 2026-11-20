// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "ReactionPassiveLayerLab",
    platforms: [.macOS(.v10_15)],
    dependencies: [.package(path: "../../../packages/AnsibleUIKit")],
    targets: [
        .target(name: "ReactionHarness", dependencies: ["AnsibleUIKit"]),
        .testTarget(name: "ReactionTests", dependencies: ["ReactionHarness", "AnsibleUIKit"])
    ]
)
