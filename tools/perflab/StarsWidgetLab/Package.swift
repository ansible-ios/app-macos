// swift-tools-version:5.5
import PackageDescription
let package = Package(name: "StarsWidgetLab", platforms: [.macOS(.v10_15)], dependencies: [.package(path: "../../../packages/AnsibleUIKit")], targets: [.target(name: "Effects", dependencies: ["AnsibleUIKit"], resources: [.copy("Resources/star.png"), .copy("Resources/star@2x.png")]), .testTarget(name: "EffectsTests", dependencies: ["Effects", "AnsibleUIKit"]), .executableTarget(name: "StarsWidgetProbe", dependencies: ["Effects", "AnsibleUIKit"]), .executableTarget(name: "StarsWidgetRender", dependencies: ["Effects", "AnsibleUIKit"])])
