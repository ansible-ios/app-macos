// swift-tools-version:5.5
import PackageDescription
let package = Package(name: "ChatListActivityLab", platforms: [.macOS(.v10_15)], dependencies: [.package(path: "../../../packages/AnsibleUIKit"), .package(name: "SSignalKit", path: "../../../submodules/ansible-ios/submodules/SSignalKit")], targets: [.target(name: "ActivityText", dependencies: ["AnsibleUIKit", .product(name: "SwiftSignalKit", package: "SSignalKit")]), .testTarget(name: "ChatListActivityTests", dependencies: ["ActivityText", "AnsibleUIKit"])])
