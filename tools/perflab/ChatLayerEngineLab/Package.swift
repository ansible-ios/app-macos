// swift-tools-version:5.5
import PackageDescription
let package = Package(
    name: "ChatLayerEngineLab",
    platforms: [.macOS(.v10_15)],
    products: [.executable(name: "ChatLayerEngineApp", targets: ["ChatLayerEngineApp"])],
    dependencies: [.package(path: "../../../packages/AnsibleUIKit"), .package(name: "SSignalKit", path: "../../../submodules/ansible-ios/submodules/SSignalKit")],
    targets: [
        .target(name: "ChatLayerEngine", dependencies: ["AnsibleUIKit", "InputTextView", "TelegramCore", "AnsibleContext", "InputView", "InlineStickerLayer", .product(name: "SwiftSignalKit", package: "SSignalKit")]),
        .target(name: "TelegramCore", path: "Sources/AnsibleCore"),
        .target(name: "AnsibleContext"),
        .target(name: "InputView"),
        .target(name: "InlineStickerLayer", dependencies: ["AnsibleUIKit", "AnsibleContext", "InputView"]),
        .target(name: "InputTextView", dependencies: ["AnsibleUIKit"]),
        .target(name: "ChatRowGeometryHarness"),
        .target(name: "ChatRowObserverHarness", dependencies: ["AnsibleUIKit"]),
        .testTarget(name: "ChatRowObserverTests", dependencies: ["ChatRowObserverHarness", "AnsibleUIKit"]),
        .target(name: "ChatLayerEngineBaseline", dependencies: ["AnsibleUIKit", "InputTextView", "TelegramCore", .product(name: "SwiftSignalKit", package: "SSignalKit")]),
        .target(name: "FoldingViewHarnessBaseline", dependencies: ["AnsibleUIKit", "ChatLayerEngineBaseline", "InputTextView"]),
        .target(name: "FoldingViewHarness", dependencies: ["AnsibleUIKit", "ChatLayerEngine", "InputTextView", "AnsibleContext", "InputView", "InlineStickerLayer"]),
        .testTarget(name: "FoldingViewTests", dependencies: ["AnsibleContext", "InputView", "InlineStickerLayer", "FoldingViewHarnessBaseline", "FoldingViewHarness", "AnsibleUIKit", "ChatLayerEngine", .product(name: "SwiftSignalKit", package: "SSignalKit")]),
        .target(name: "FoldingBlocksHarness", dependencies: ["AnsibleUIKit", "InputTextView"]),
        .testTarget(name: "FoldingBlocksTests", dependencies: ["FoldingBlocksHarness", "AnsibleUIKit", "InputTextView"]),
        .executableTarget(name: "ChatLayerEngineApp", dependencies: ["ChatLayerEngine", "AnsibleUIKit"]),
        .testTarget(name: "ChatLayerEngineTests", dependencies: ["ChatLayerEngine", "AnsibleUIKit", "InputTextView"]),
        .testTarget(name: "ChatRowGeometryTests", dependencies: ["ChatRowGeometryHarness"])
    ]
)
