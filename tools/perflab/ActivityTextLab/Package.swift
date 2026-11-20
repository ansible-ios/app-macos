// swift-tools-version:5.5
import PackageDescription
let package = Package(name: "ActivityTextLab", platforms: [.macOS(.v10_15)], dependencies: [.package(path: "../../../packages/AnsibleUIKit"), .package(path: "../../../packages/ColorPalette"), .package(name: "SSignalKit", path: "../../../submodules/ansible-ios/submodules/SSignalKit")], targets: [.target(name: "ActivityText", dependencies: ["AnsibleUIKit", .product(name: "SwiftSignalKit", package: "SSignalKit")]), .testTarget(name: "ActivityTextTests", dependencies: ["ActivityText", "AnsibleUIKit", "ColorPalette"])])
