// swift-tools-version:5.5
import PackageDescription
let package = Package(name: "StarsEffectLab", platforms: [.macOS(.v10_15)], dependencies: [.package(path: "../../../packages/AnsibleUIKit")], targets: [.target(name: "Effects", dependencies: ["AnsibleUIKit"], resources: [.copy("Resources/particle.png")]), .testTarget(name: "EffectsTests", dependencies: ["Effects", "AnsibleUIKit"]), .executableTarget(name: "StarsRenderLab", dependencies: ["Effects", "AnsibleUIKit"])])
