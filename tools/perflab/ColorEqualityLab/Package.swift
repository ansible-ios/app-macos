// swift-tools-version:5.9
import PackageDescription
let package = Package(name: "ColorEqualityLab", platforms: [.macOS(.v10_15)], dependencies: [.package(path: "../../../packages/AnsibleUIKit"), .package(path: "../../../packages/Colors")], targets: [.target(name: "KitProbe", dependencies: ["AnsibleUIKit"]), .target(name: "CoreProbe", dependencies: ["Colors"]), .testTarget(name: "ColorTests", dependencies: ["KitProbe", "CoreProbe"])])
