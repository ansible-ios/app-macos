// swift-tools-version:5.9
import PackageDescription
let package = Package(name: "ShimmerRenderLab", platforms: [.macOS(.v10_15)], dependencies: [.package(path: "../../../packages/AnsibleUIKit"), .package(path: "AnsibleUIKitBaseline")], targets: [.testTarget(name: "ShimmerTests", dependencies: ["AnsibleUIKit", "AnsibleUIKitBaseline"])])
