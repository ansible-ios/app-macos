// swift-tools-version:5.9
import PackageDescription
let package = Package(name: "VisibleEnumerationLab", platforms: [.macOS(.v10_15)], dependencies: [.package(path: "../../../packages/AnsibleUIKit"), .package(path: "AnsibleUIKitBaseline")], targets: [.testTarget(name: "EnumerationTests", dependencies: ["AnsibleUIKit", "AnsibleUIKitBaseline"])])
