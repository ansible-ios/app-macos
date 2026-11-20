// swift-tools-version:5.9
import PackageDescription
let package = Package(name: "BadgeLayoutLab", platforms: [.macOS(.v10_15)], dependencies: [.package(path: "../../../packages/AnsibleUIKit")], targets: [.target(name: "BadgeLab", dependencies: ["AnsibleUIKit"]), .testTarget(name: "BadgeLabTests", dependencies: ["BadgeLab", "AnsibleUIKit"])])
