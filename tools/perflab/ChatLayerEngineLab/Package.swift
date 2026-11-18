// swift-tools-version:5.5
import PackageDescription
let package = Package(
    name: "ChatLayerEngineLab",
    platforms: [.macOS(.v10_15)],
    products: [.executable(name: "ChatLayerEngineApp", targets: ["ChatLayerEngineApp"])],
    dependencies: [.package(path: "../../../packages/TGUIKit"), .package(name: "SSignalKit", path: "../../../submodules/ansible-ios/submodules/SSignalKit")],
    targets: [
        .target(name: "ChatLayerEngine", dependencies: ["TGUIKit", "InputTextView", "TelegramCore", "AnsibleContext", "InputView", "InlineStickerLayer", .product(name: "SwiftSignalKit", package: "SSignalKit")]),
        .target(name: "TelegramCore", path: "Sources/AnsibleCore"),
        .target(name: "AnsibleContext"),
        .target(name: "InputView"),
        .target(name: "InlineStickerLayer", dependencies: ["TGUIKit", "AnsibleContext", "InputView"]),
        .target(name: "InputTextView", dependencies: ["TGUIKit"]),
        .target(name: "ChatRowGeometryHarness"),
        .target(name: "ChatRowObserverHarness", dependencies: ["TGUIKit"]),
        .testTarget(name: "ChatRowObserverTests", dependencies: ["ChatRowObserverHarness", "TGUIKit"]),
        .target(name: "ChatLayerEngineBaseline", dependencies: ["TGUIKit", "InputTextView", "TelegramCore", .product(name: "SwiftSignalKit", package: "SSignalKit")]),
        .target(name: "FoldingViewHarnessBaseline", dependencies: ["TGUIKit", "ChatLayerEngineBaseline", "InputTextView"]),
        .target(name: "FoldingViewHarness", dependencies: ["TGUIKit", "ChatLayerEngine", "InputTextView", "AnsibleContext", "InputView", "InlineStickerLayer"]),
        .testTarget(name: "FoldingViewTests", dependencies: ["AnsibleContext", "InputView", "InlineStickerLayer", "FoldingViewHarnessBaseline", "FoldingViewHarness", "TGUIKit", "ChatLayerEngine", .product(name: "SwiftSignalKit", package: "SSignalKit")]),
        .target(name: "FoldingBlocksHarness", dependencies: ["TGUIKit", "InputTextView"]),
        .testTarget(name: "FoldingBlocksTests", dependencies: ["FoldingBlocksHarness", "TGUIKit", "InputTextView"]),
        .executableTarget(name: "ChatLayerEngineApp", dependencies: ["ChatLayerEngine", "TGUIKit"]),
        .testTarget(name: "ChatLayerEngineTests", dependencies: ["ChatLayerEngine", "TGUIKit", "InputTextView"]),
        .testTarget(name: "ChatRowGeometryTests", dependencies: ["ChatRowGeometryHarness"])
    ]
)
