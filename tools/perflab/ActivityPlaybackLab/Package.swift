// swift-tools-version:5.5
import PackageDescription
let package = Package(name: "ActivityPlaybackLab", platforms: [.macOS(.v10_15)], dependencies: [.package(path: "../../../packages/AnsibleUIKit")], targets: [.target(name: "ActivityPlaybackCore", dependencies: ["AnsibleUIKit"], path: "Sources/Activity"), .testTarget(name: "ActivityTests", dependencies: ["ActivityPlaybackCore", "AnsibleUIKit"])])
