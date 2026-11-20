// swift-tools-version:5.5
import PackageDescription
let package = Package(name: "InvisibleInkAllocationLab", platforms: [.macOS(.v10_15)], dependencies: [.package(path: "../../../packages/AnsibleUIKit")], targets: [.target(name: "OriginalInkDust", dependencies: ["AnsibleUIKit"]), .testTarget(name: "InkDustTests", dependencies: ["AnsibleUIKit", "OriginalInkDust"])])
