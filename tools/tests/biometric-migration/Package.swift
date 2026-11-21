// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "BiometricMigrationTests",
    platforms: [.macOS(.v10_15)],
    dependencies: [.package(name: "SSignalKit", path: "../SSignalKit")],
    targets: [
        .target(name: "PasscodeCore", dependencies: [.product(name: "SwiftSignalKit", package: "SSignalKit")]),
        .testTarget(name: "MigrationTests", dependencies: ["PasscodeCore"])
    ]
)
