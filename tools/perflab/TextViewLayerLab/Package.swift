// swift-tools-version:5.5
import PackageDescription
let package = Package(name: "TextViewLayerLab", platforms: [.macOS(.v10_15)], dependencies: [.package(path: "../../../packages/AnsibleUIKit")], targets: [.target(name: "ChatTextRows", dependencies: ["AnsibleUIKit"]), .testTarget(name: "LayerTests", dependencies: ["AnsibleUIKit", "ChatTextRows"])])
