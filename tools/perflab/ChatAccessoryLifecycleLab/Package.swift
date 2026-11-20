// swift-tools-version:5.9
import PackageDescription
let package = Package(name: "ChatAccessoryLifecycleLab", platforms: [.macOS(.v10_15)], dependencies: [.package(path: "../../../packages/AnsibleUIKit"), .package(path: "../../../packages/ColorPalette")], targets: [.testTarget(name: "AccessoryTests", dependencies: ["AnsibleUIKit", "ColorPalette"])])
