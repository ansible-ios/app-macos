// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "InlineEmojiLayerLab",
    platforms: [.macOS(.v10_15)],
    dependencies: [.package(path: "../../../packages/AnsibleUIKit")],
    targets: [
        .target(name: "AnsibleContext"),
        .target(name: "InputView"),
        .target(name: "InlineStickerLayer", dependencies: ["AnsibleUIKit", "AnsibleContext", "InputView"]),
        .target(name: "InlineEmojiHelper", dependencies: ["AnsibleUIKit", "AnsibleContext", "InputView", "InlineStickerLayer"]),
        .testTarget(name: "InlineEmojiTests", dependencies: ["InlineEmojiHelper", "AnsibleUIKit", "AnsibleContext", "InputView", "InlineStickerLayer"])
    ]
)
