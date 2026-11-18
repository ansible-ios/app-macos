// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "InlineEmojiLayerLab",
    platforms: [.macOS(.v10_15)],
    dependencies: [.package(path: "../../../packages/TGUIKit")],
    targets: [
        .target(name: "AnsibleContext"),
        .target(name: "InputView"),
        .target(name: "InlineStickerLayer", dependencies: ["TGUIKit", "AnsibleContext", "InputView"]),
        .target(name: "InlineEmojiHelper", dependencies: ["TGUIKit", "AnsibleContext", "InputView", "InlineStickerLayer"]),
        .testTarget(name: "InlineEmojiTests", dependencies: ["InlineEmojiHelper", "TGUIKit", "AnsibleContext", "InputView", "InlineStickerLayer"])
    ]
)
