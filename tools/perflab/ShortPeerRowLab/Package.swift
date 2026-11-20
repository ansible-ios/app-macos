// swift-tools-version:5.5
import PackageDescription
let package = Package(name: "ShortPeerRowLab", platforms: [.macOS(.v10_15)], dependencies: [.package(path: "../../../packages/AnsibleUIKit")], targets: [.target(name: "PeerRows", dependencies: ["AnsibleUIKit"]), .testTarget(name: "PeerRowTests", dependencies: ["PeerRows"])])
