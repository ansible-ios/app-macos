import Cocoa
import AppAnalytics
import AnsibleUIKit
import Postbox
import TelegramCore
import SwiftSignalKit
import AnsibleContext
import AnsibleUtils
import ChatModeTypes
import AudioPlayerCore

public protocol PeerInfoPremiumConfiguration {
    var minChannelAutotranslationLevel: Int32 { get }
}


public struct PeerInfoUIHooks {
    public let freezeAlert: (any AccountContextProtocol) -> Void
    public let formatPhoneNumber: (any AccountContextProtocol, String) -> String
    public let resolveUsername: (String, any AccountContextProtocol) -> Signal<Peer?, NoError>
    public let premiumConfiguration: (any AccountContextProtocol) -> any PeerInfoPremiumConfiguration
    public let showDisableSharingModal: (any AccountContextProtocol, PeerId, @escaping (Bool) -> Void) -> Void
    public let showInlineAudioPlayer: (APController, any AccountContextProtocol, TableView?, TableView?) -> Void
    public let showProfileMusicPlayerList: (any AccountContextProtocol, EnginePeer, TelegramMediaFile, ProfileSavedMusicContext.State, ProfileSavedMusicContext) -> Void
    public let activeProfileMusic: (any AccountContextProtocol, PeerId) -> (state: ProfileSavedMusicContext.State, context: ProfileSavedMusicContext, playing: TelegramMediaFile?)?
    public let executeNftLink: (String, String, any AccountContextProtocol) -> Void
    public let navigateToChat: (NavigationViewController?, any AccountContextProtocol, ChatLocation, ChatMode, ChatFocusTarget?, Atomic<ChatLocationContextHolder?>?) -> Void
    public var navigateToChatWithContext: ((NavigationViewController?, any AccountContextProtocol, ChatLocation, ChatMode, ChatFocusTarget?, Atomic<ChatLocationContextHolder?>?, AnalyticsContext) -> Void)?
    public func navigateToChatObserved(_ navigation: NavigationViewController?, _ context: any AccountContextProtocol, _ location: ChatLocation, _ mode: ChatMode, _ focus: ChatFocusTarget?, _ holder: Atomic<ChatLocationContextHolder?>?, analyticsContext: AnalyticsContext) {
        let origin = Analytics.shared.captureContext(engine: context.engine, peerId: location.peerId, inherited: analyticsContext)
        let presentation = origin.beginPresentation()
        defer { presentation.end() }
        if let navigateToChatWithContext {
            navigateToChatWithContext(navigation, context, location, mode, focus, holder, origin)
        } else {
            navigateToChat(navigation, context, location, mode, focus, holder)
        }
    }

    public init(freezeAlert: @escaping (any AccountContextProtocol) -> Void,
                formatPhoneNumber: @escaping (any AccountContextProtocol, String) -> String,
                resolveUsername: @escaping (String, any AccountContextProtocol) -> Signal<Peer?, NoError>,
                premiumConfiguration: @escaping (any AccountContextProtocol) -> any PeerInfoPremiumConfiguration,
                showDisableSharingModal: @escaping (any AccountContextProtocol, PeerId, @escaping (Bool) -> Void) -> Void,
                showInlineAudioPlayer: @escaping (APController, any AccountContextProtocol, TableView?, TableView?) -> Void,
                showProfileMusicPlayerList: @escaping (any AccountContextProtocol, EnginePeer, TelegramMediaFile, ProfileSavedMusicContext.State, ProfileSavedMusicContext) -> Void,
                activeProfileMusic: @escaping (any AccountContextProtocol, PeerId) -> (state: ProfileSavedMusicContext.State, context: ProfileSavedMusicContext, playing: TelegramMediaFile?)?,
                executeNftLink: @escaping (String, String, any AccountContextProtocol) -> Void,
                navigateToChat: @escaping (NavigationViewController?, any AccountContextProtocol, ChatLocation, ChatMode, ChatFocusTarget?, Atomic<ChatLocationContextHolder?>?) -> Void) {
        self.freezeAlert = freezeAlert
        self.formatPhoneNumber = formatPhoneNumber
        self.resolveUsername = resolveUsername
        self.premiumConfiguration = premiumConfiguration
        self.showDisableSharingModal = showDisableSharingModal
        self.showInlineAudioPlayer = showInlineAudioPlayer
        self.showProfileMusicPlayerList = showProfileMusicPlayerList
        self.activeProfileMusic = activeProfileMusic
        self.executeNftLink = executeNftLink
        self.navigateToChat = navigateToChat
    }


    private static var _shared: PeerInfoUIHooks?

    public static var isInstalled: Bool {
        return _shared != nil
    }

    public static var shared: PeerInfoUIHooks {
        if let value = _shared {
            return value
        }
        assertionFailure("PeerInfoUIHooks.install must be called before peer info screens are used")
        return .placeholder
    }

    public static func install(_ hooks: PeerInfoUIHooks) {
        assert(Thread.isMainThread, "PeerInfoUIHooks.install must be called on the main thread")
        _shared = hooks
    }

    public static let placeholder = PeerInfoUIHooks(freezeAlert: { _ in
    }, formatPhoneNumber: { _, number in
        number
    }, resolveUsername: { _, _ in
        .single(nil)
    }, premiumConfiguration: { _ in
        PeerInfoPlaceholderPremiumConfiguration()
    }, showDisableSharingModal: { _, _, _ in
    }, showInlineAudioPlayer: { _, _, _, _ in
    }, showProfileMusicPlayerList: { _, _, _, _, _ in
    }, activeProfileMusic: { _, _ in
        nil
    }, executeNftLink: { _, _, _ in
    }, navigateToChat: { _, _, _, _, _, _ in
    })
}

struct PeerInfoPlaceholderPremiumConfiguration: PeerInfoPremiumConfiguration {
    var minChannelAutotranslationLevel: Int32 { return 3 }
}
