import Cocoa
import AnsibleUIKit
import TelegramCore
import Postbox
import SwiftSignalKit
import AnsibleMediaResources
import InAppSettings

public struct AnsibleUtilsHooks {
    public let animationsAreLite: () -> Bool
    public let isLite: (LiteModeKey) -> Bool
    public let peerTitle: (Peer) -> String
    public let peerLetters: (Peer) -> [String]
    public let peerIsForum: (Peer) -> Bool
    public let peerCompactTitle: (Peer) -> String
    public let repliesPeerId: () -> PeerId
    public let topicFile: ((String, Int32, Bool) -> TelegramMediaFile)?
    public let topicImage: ((String, [NSColor], [NSColor]) -> Signal<ImageDataTransformation, NoError>)?
    public let generalTopicImage: ((LocalBundleResource, CGFloat) -> Signal<ImageDataTransformation, NoError>)?

    public init(animationsAreLite: @escaping () -> Bool, isLite: @escaping (LiteModeKey) -> Bool, peerTitle: @escaping (Peer) -> String, peerLetters: @escaping (Peer) -> [String], peerIsForum: @escaping (Peer) -> Bool, peerCompactTitle: @escaping (Peer) -> String, repliesPeerId: @escaping () -> PeerId, topicFile: ((String, Int32, Bool) -> TelegramMediaFile)? = nil, topicImage: ((String, [NSColor], [NSColor]) -> Signal<ImageDataTransformation, NoError>)? = nil, generalTopicImage: ((LocalBundleResource, CGFloat) -> Signal<ImageDataTransformation, NoError>)? = nil) {
        self.animationsAreLite = animationsAreLite
        self.isLite = isLite
        self.peerTitle = peerTitle
        self.peerLetters = peerLetters
        self.peerIsForum = peerIsForum
        self.peerCompactTitle = peerCompactTitle
        self.repliesPeerId = repliesPeerId
        self.topicFile = topicFile
        self.topicImage = topicImage
        self.generalTopicImage = generalTopicImage
    }

    private static var installed: AnsibleUtilsHooks?

    public static var shared: AnsibleUtilsHooks {
        guard let hooks = installed else {
            fatalError("AnsibleUtilsHooks.install must be called before shared presentation is used")
        }
        return hooks
    }

    public static func install(_ hooks: AnsibleUtilsHooks) {
        installed = hooks
    }
}
