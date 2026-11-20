// swift-tools-version:5.5
import PackageDescription
let package = Package(name: "InlinePlaybackLab", platforms: [.macOS(.v10_15)], dependencies: [.package(path: "../../../packages/AnsibleUIKit")], targets: [.target(name: "Playback", dependencies: ["AnsibleUIKit"]), .testTarget(name: "PlaybackTests", dependencies: ["Playback"])])
