// swift-tools-version:5.5
import PackageDescription
let package = Package(
    name: "EntertainmentSearchViewLab",
    platforms: [.macOS(.v10_15)],
    dependencies: [.package(path: "../../../packages/AnsibleUIKit")],
    targets: [
        .target(name: "SearchViews", dependencies: ["AnsibleUIKit"]),
        .executableTarget(name: "SearchPreview", dependencies: ["SearchViews"]),
        .testTarget(name: "SearchViewsTests", dependencies: ["SearchViews"])
    ]
)
