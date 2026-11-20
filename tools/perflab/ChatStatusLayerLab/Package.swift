// swift-tools-version:5.5
import PackageDescription
let package = Package(name: "ChatStatusLayerLab", platforms: [.macOS(.v10_15)], dependencies: [.package(path: "../../../packages/AnsibleUIKit")], targets: [.target(name: "StatusLayers", dependencies: ["AnsibleUIKit"]), .testTarget(name: "StatusLayerTests", dependencies: ["StatusLayers"])])
