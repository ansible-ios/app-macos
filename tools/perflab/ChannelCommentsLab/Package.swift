// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "ChannelCommentsLab",
    platforms: [.macOS(.v10_15)],
    dependencies: [.package(path: "../../../packages/AnsibleUIKit")],
    targets: [
        .target(name: "CommentsHarness", dependencies: ["AnsibleUIKit"]),
        .testTarget(name: "CommentsTests", dependencies: ["CommentsHarness", "AnsibleUIKit"])
    ]
)
