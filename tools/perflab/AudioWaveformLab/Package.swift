// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "AudioWaveformLab",
    platforms: [.macOS(.v10_15)],
    dependencies: [.package(path: "../../../packages/AnsibleUIKit")],
    targets: [
        .target(name: "WaveformCurrent", dependencies: ["AnsibleUIKit"]),
        .target(name: "WaveformOriginal", dependencies: ["AnsibleUIKit"]),
        .testTarget(name: "WaveformTests", dependencies: ["WaveformCurrent", "WaveformOriginal", "AnsibleUIKit"])
    ]
)
