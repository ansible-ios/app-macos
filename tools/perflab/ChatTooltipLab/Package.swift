// swift-tools-version:5.5
import PackageDescription
let package = Package(name: "ChatTooltipLab", platforms: [.macOS(.v10_15)], dependencies: [.package(path: "../../../packages/AnsibleUIKit"), .package(name: "SSignalKit", path: "../../../submodules/ansible-ios/submodules/SSignalKit")], targets: [.target(name: "TooltipRows", dependencies: ["AnsibleUIKit", .product(name: "SwiftSignalKit", package: "SSignalKit")]), .testTarget(name: "TooltipTests", dependencies: ["TooltipRows"])])
