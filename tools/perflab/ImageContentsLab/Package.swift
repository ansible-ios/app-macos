// swift-tools-version:5.9
import PackageDescription
let package = Package(name: "ImageContentsLab", platforms: [.macOS(.v10_15)], dependencies: [.package(path: "../../../packages/AnsibleUIKit"), .package(name: "SSignalKit", path: "../../../submodules/ansible-ios/submodules/SSignalKit")], targets: [.testTarget(name: "ImageContentsTests", dependencies: ["AnsibleUIKit", .product(name: "SwiftSignalKit", package: "SSignalKit")])])
