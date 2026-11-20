// swift-tools-version:5.5

import PackageDescription

let deps: [(String, String)] = [
    ("AppAnalytics", "../AppAnalytics"),
    ("AnsibleUIKit", "../AnsibleUIKit"),
    ("ColorPalette", "../ColorPalette"),
    ("Localization", "../Localization"),
    ("InAppSettings", "../InAppSettings"),
    ("Strings", "../Strings"),
    ("ObjcUtils", "../ObjcUtils"),
    ("HotKey", "../HotKey"),
    ("AnsibleTheme", "../AnsibleTheme"),
    ("AnsibleContext", "../AnsibleContext"),
    ("AnsibleUtils", "../AnsibleUtils"),
    ("AnsibleMedia", "../AnsibleMedia"),
    ("AnsibleMediaUtils", "../AnsibleMediaUtils"),
    ("AnsibleCallsCore", "../AnsibleCallsCore"),
    ("CallVideoLayer", "../CallVideoLayer"),
    ("MessageUtils", "../MessageUtils"),
    ("EmojiReplacements", "../EmojiReplacements"),
    ("InlineStickers", "../InlineStickers"),
    ("InputView", "../InputView"),
    ("InputTextView", "../InputTextView"),
    ("SceneEffects", "../SceneEffects"),
    ("LocalAnimations", "../LocalAnimations"),
    ("GeneralRows", "../GeneralRows"),
    ("InputDataUI", "../InputDataUI"),
    ("AlertsUI", "../AlertsUI"),
    ("AvatarUI", "../AvatarUI"),
    ("ShortPeerRow", "../ShortPeerRow"),
    ("PremiumStatusUI", "../PremiumStatusUI"),
    ("SystemPermissions", "../SystemPermissions"),
    ("SelectPeersUI", "../SelectPeersUI"),
    ("InviteLinksUI", "../InviteLinksUI"),
    ("CallsUI", "../CallsUI"),
    ("ChatModeTypes", "../ChatModeTypes"),
    ("EntertainmentUI", "../EntertainmentUI"),
    ("TgVoipWebrtc", "../../submodules/tgcalls"),
    ("PushToTalk", "../PushToTalk"),
    ("InlineStickerLayer", "../InlineStickerLayer"),
]

let package = Package(
    name: "GroupCallScreenUI",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "GroupCallScreenUI", targets: ["GroupCallScreenUI"]),
    ],
    dependencies: [
        .package(name: "SSignalKit", path: "../../submodules/ansible-ios/submodules/SSignalKit"),
        .package(name: "TelegramCore", path: "../../submodules/ansible-ios/submodules/TelegramCore"),
        .package(name: "Postbox", path: "../../submodules/ansible-ios/submodules/Postbox"),
    ] + deps.map { .package(name: $0.0, path: $0.1) },
    targets: [
        .target(
            name: "GroupCallScreenUI",
            dependencies: [
                .product(name: "SwiftSignalKit", package: "SSignalKit", condition: nil),
                .product(name: "TelegramCore", package: "TelegramCore", condition: nil),
                .product(name: "Postbox", package: "Postbox", condition: nil),
            ] + deps.map { .product(name: $0.0, package: $0.0, condition: nil) },
            path: "Sources/GroupCallScreenUI",
            swiftSettings: [.unsafeFlags(["-Xcc", "-DWEBRTC_MAC=1"])]),
    ]
)
