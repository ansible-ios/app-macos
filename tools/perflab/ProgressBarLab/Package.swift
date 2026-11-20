// swift-tools-version:5.5
import PackageDescription
let package = Package(name: "ProgressBarLab", platforms: [.macOS(.v10_15)], dependencies: [.package(path: "../../../packages/AnsibleUIKit")], targets: [.target(name: "ProgressReference", dependencies: ["AnsibleUIKit"]), .testTarget(name: "ProgressTests", dependencies: ["ProgressReference", "AnsibleUIKit"])])
