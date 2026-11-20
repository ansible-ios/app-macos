// swift-tools-version:5.5
import PackageDescription
let package = Package(
    name: "ControlNodeLab",
    platforms: [.macOS(.v10_15)],
    dependencies: [.package(path: "../../../packages/AnsibleUIKit"), .package(name: "SSignalKit", path: "../../../submodules/ansible-ios/submodules/SSignalKit")],
    targets: [
        .target(name: "LabSupport", dependencies: ["AnsibleUIKit"]),
        .target(name: "SceneLab", dependencies: ["AnsibleUIKit", "LabSupport", .product(name: "SwiftSignalKit", package: "SSignalKit")]),
        .target(name: "SceneLabMutant", dependencies: ["AnsibleUIKit", "LabSupport", .product(name: "SwiftSignalKit", package: "SSignalKit")]),
        .testTarget(name: "ControlNodeTests", dependencies: ["AnsibleUIKit", "LabSupport", "SceneLab", "SceneLabMutant"])
    ]
)
