// swift-tools-version:5.9
import PackageDescription
let package = Package(name: "ImageTintLab", platforms: [.macOS(.v10_15)], dependencies: [.package(path: "../../../packages/AnsibleUIKit")], targets: [.testTarget(name: "TintTests", dependencies: ["AnsibleUIKit"])])
