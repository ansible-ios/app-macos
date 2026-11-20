import Cocoa
import Foundation
import Postbox
import AnsibleUIKit
import ColorPalette
import AnsibleTheme
import GeneralRows

public enum VideoSourceMacMode {
    case video
    case screencast
    
}

public struct DominantVideo : Equatable {
    
    public enum PinMode {
        case permanent
        case focused
    }
    
    public static let streamEndpoint = "unified"
    
    public let peerId: PeerId
    public let endpointId: String
    public let mode: VideoSourceMacMode
    public let pinMode: PinMode?
    public init(_ peerId: PeerId, _ endpointId: String, _ mode: VideoSourceMacMode, _ pinMode: PinMode?) {
        self.peerId = peerId
        self.endpointId = endpointId
        self.mode = mode
        self.pinMode = pinMode
    }
}

private func generatePeerControl(_ icon: CGImage, background: NSColor) -> CGImage {
    return generateImage(NSMakeSize(28, 28), contextGenerator: { size, ctx in
        let rect: NSRect = .init(origin: .zero, size: size)
        ctx.clear(rect)
        
        ctx.round(size, 4)
        ctx.setFillColor(background.cgColor)
        ctx.fill(rect)
        
        ctx.draw(icon, in: rect.focus(icon.backingSize))
    })!
}

public struct GroupCallTheme {
    public static var membersColor:NSColor {
        return AnsibleThemeHooks.shared.darkAppearance().colors.background
    }
    public static var windowBackground: NSColor {
        return AnsibleThemeHooks.shared.darkAppearance().colors.listBackground
    }
    public static var grayStatusColor: NSColor {
        return AnsibleThemeHooks.shared.darkAppearance().colors.grayText
    }
    public static var blueStatusColor: NSColor {
        return AnsibleThemeHooks.shared.darkAppearance().colors.accent
    }
    public static var greenStatusColor: NSColor {
        return AnsibleThemeHooks.shared.darkAppearance().colors.greenUI
    }
    public static var memberSeparatorColor: NSColor {
        AnsibleThemeHooks.shared.darkAppearance().colors.border
    }
    public static var speakActiveColor: NSColor {
        AnsibleThemeHooks.shared.darkAppearance().colors.greenUI
    }
    public static var speakInactiveColor: NSColor {
        AnsibleThemeHooks.shared.darkAppearance().colors.accent
    }
    public static var speakLockedColor: NSColor {
        AnsibleThemeHooks.shared.darkAppearance().colors.redUI
    }
    public static var speakDisabledColor: NSColor {
        AnsibleThemeHooks.shared.darkAppearance().colors.grayBackground
    }
    public static var titleColor: NSColor {
        return NSColor.white
    }
    public static var declineColor: NSColor {
        return AnsibleThemeHooks.shared.darkAppearance().colors.redUI.withAlphaComponent(0.3)
    }
    public static var settingsColor: NSColor {
        return AnsibleThemeHooks.shared.darkAppearance().colors.grayBackground
    }
    
    public static let purple = NSColor(rgb: 0x3252ef)
    public static let pink = NSColor(rgb: 0xef436c)

    
    public static var accent: NSColor {
        return speakInactiveColor
    }
    public static var secondary: NSColor {
        return grayStatusColor
    }
    
    public static var titleSpeakingAnimation: [CGImage] {
        recordVoiceActivityAnimation(GroupCallTheme.greenStatusColor)
    }
    
    public static let videoBox_video: CGImage = AnsibleThemeHooks.shared.image(.iconGroupCallStatusVideo).precomposed(NSColor.white.withAlphaComponent(0.8))
    public static let videoBox_screencast: CGImage = AnsibleThemeHooks.shared.image(.iconGroupCallStatusScreencast).precomposed(NSColor.white.withAlphaComponent(0.8))
    public static let closeTooltip: CGImage = AnsibleThemeHooks.shared.image(.iconVoiceChatTooltipClose).precomposed(.white)
    public static let settingsIcon: CGImage = AnsibleThemeHooks.shared.image(.iconGroupCallSettings).precomposed(.white)
    public static let smallSettingsIcon: CGImage = AnsibleThemeHooks.shared.image(.iconGroupCallSettingsSmall).precomposed(.white)
    public static let declineIcon: CGImage = AnsibleThemeHooks.shared.image(.iconGroupCallDecline).precomposed(.white)
    public static let inviteIcon: CGImage = AnsibleThemeHooks.shared.image(.iconGroupCallInvite).precomposed(.white)
    public static let shareIcon: CGImage = AnsibleThemeHooks.shared.image(.iconBotAffiliateLink).precomposed(.white)
    public static let video_back = AnsibleThemeHooks.shared.image(.iconChatNavigationBack).precomposed(NSColor.white)
    public static let video_paused = AnsibleThemeHooks.shared.image(.iconVoiceChatPausedVideo).precomposed(NSColor.white)
    public static let videoBox_muted: CGImage = AnsibleThemeHooks.shared.image(.iconGroupCallVideoBoxMuted).precomposed(NSColor.white.withAlphaComponent(0.8))
    public static let videoBox_unmuted: CGImage = AnsibleThemeHooks.shared.image(.iconGroupCallVideoBoxUnmuted).precomposed(NSColor.white.withAlphaComponent(0.8))
    public static let video_limit: CGImage = AnsibleThemeHooks.shared.image(.iconVoiceChatVideoLimit).precomposed(.white)
    public static let pin_video: CGImage = AnsibleThemeHooks.shared.image(.iconVoiceChatPinVideo).precomposed(.white)
    public static let unpin_video: CGImage = AnsibleThemeHooks.shared.image(.iconVoiceChatUnpinVideo).precomposed(.white)
    public static let pin_window: CGImage = AnsibleThemeHooks.shared.image(.iconGroupCallPin).precomposed(.white)
    public static let unhide_peers: CGImage = AnsibleThemeHooks.shared.image(.iconVoiceChatHidePeers).precomposed(.white, flipHorizontal: true)

    public static let messageIcon: CGImage = AnsibleThemeHooks.shared.image(.iconGroupCallMessage).precomposed(.white)

    
    public static var video_status_muted_red: CGImage {
        return AnsibleThemeHooks.shared.image(.iconGroupCallVideoBoxMuted).precomposed(GroupCallTheme.speakLockedColor)
    }
    public static var video_status_muted_gray: CGImage {
        return AnsibleThemeHooks.shared.image(.iconGroupCallVideoBoxMuted).precomposed(GroupCallTheme.grayStatusColor)
    }

    public static var video_status_unmuted_green: CGImage {
        return AnsibleThemeHooks.shared.image(.iconGroupCallVideoBoxUnmuted).precomposed(GroupCallTheme.greenStatusColor)
    }
    public static var video_status_unmuted_gray: CGImage {
        return AnsibleThemeHooks.shared.image(.iconGroupCallVideoBoxUnmuted).precomposed(GroupCallTheme.grayStatusColor)
    }
    public static var video_status_unmuted_accent: CGImage {
        return AnsibleThemeHooks.shared.image(.iconGroupCallVideoBoxUnmuted).precomposed(GroupCallTheme.accent)
    }
    public static var videoBox_muted_locked: CGImage {
        AnsibleThemeHooks.shared.image(.iconGroupCallVideoBoxMuted).precomposed(GroupCallTheme.grayStatusColor)
    }
    public static var invitedIcon: CGImage {
        AnsibleThemeHooks.shared.image(.iconGroupCallInvited).precomposed(GroupCallTheme.grayStatusColor)
    }
    
    public static var send_message_image: CGImage {
        return AnsibleThemeHooks.shared.image(.iconSendMessage).precomposed(AnsibleThemeHooks.shared.darkAppearance().colors.accent)
    }
    public static var emoji_image: CGImage {
        return  AnsibleThemeHooks.shared.image(.iconEntertainments).precomposed(NSColor(0xffffff, 1))
    }
    public static var emoji_image_active: CGImage {
        return AnsibleThemeHooks.shared.image(.iconEntertainments).precomposed(NSColor(0xffffff, 0.8))
    }

    
    public static var small_speaking: CGImage {
        generatePeerControl(AnsibleThemeHooks.shared.image(.iconGroupCallSmallUnmuted).precomposed(GroupCallTheme.greenStatusColor), background: .clear)
    }
    public static var small_unmuted: CGImage {
        generatePeerControl(AnsibleThemeHooks.shared.image(.iconGroupCallSmallUnmuted).precomposed(GroupCallTheme.grayStatusColor), background: .clear)
    }
    public static var small_muted: CGImage {
        generatePeerControl(AnsibleThemeHooks.shared.image(.iconGroupCallSmallMuted).precomposed(GroupCallTheme.grayStatusColor), background: .clear)
    }
    public static var small_muted_locked: CGImage {
        generatePeerControl(AnsibleThemeHooks.shared.image(.iconGroupCallSmallMuted).precomposed(GroupCallTheme.speakLockedColor), background: .clear)
    }
    
    public static var small_speaking_active: CGImage {
        generatePeerControl(AnsibleThemeHooks.shared.image(.iconGroupCallSmallUnmuted).precomposed(GroupCallTheme.greenStatusColor), background: GroupCallTheme.windowBackground.withAlphaComponent(0.3))
    }
    public static var small_unmuted_active: CGImage {
        generatePeerControl(AnsibleThemeHooks.shared.image(.iconGroupCallSmallUnmuted).precomposed(GroupCallTheme.grayStatusColor), background: GroupCallTheme.windowBackground.withAlphaComponent(0.3))
    }
    public static var small_muted_active: CGImage {
        generatePeerControl(AnsibleThemeHooks.shared.image(.iconGroupCallSmallMuted).precomposed(GroupCallTheme.grayStatusColor), background: GroupCallTheme.windowBackground.withAlphaComponent(0.3))
    }
    public static var small_muted_locked_active: CGImage {
        generatePeerControl(AnsibleThemeHooks.shared.image(.iconGroupCallSmallMuted).precomposed(GroupCallTheme.speakLockedColor), background: GroupCallTheme.windowBackground.withAlphaComponent(0.3))
    }

    
    public static var small_raised_hand: CGImage {
        generatePeerControl(AnsibleThemeHooks.shared.image(.iconGroupCallRaiseHandSmall).precomposed(GroupCallTheme.customTheme.accentColor), background: .clear)
    }
    public static var small_raised_hand_active: CGImage {
        generatePeerControl(AnsibleThemeHooks.shared.image(.iconGroupCallRaiseHandSmall).precomposed(GroupCallTheme.customTheme.accentColor), background: GroupCallTheme.windowBackground.withAlphaComponent(0.3))
    }
    public static var status_video_gray: CGImage {
        AnsibleThemeHooks.shared.image(.iconGroupCallStatusVideo).precomposed(GroupCallTheme.grayStatusColor)
    }
    public static var status_video_accent: CGImage {
        AnsibleThemeHooks.shared.image(.iconGroupCallStatusVideo).precomposed(GroupCallTheme.blueStatusColor)
    }
    public static var status_video_green: CGImage {
        AnsibleThemeHooks.shared.image(.iconGroupCallStatusVideo).precomposed(GroupCallTheme.greenStatusColor)
    }
    public static var status_video_red: CGImage {
        AnsibleThemeHooks.shared.image(.iconGroupCallStatusVideo).precomposed(GroupCallTheme.speakLockedColor)
    }
    public static var status_screencast_gray: CGImage {
        AnsibleThemeHooks.shared.image(.iconGroupCallStatusScreencast).precomposed(GroupCallTheme.grayStatusColor)
    }
    public static var status_screencast_accent: CGImage {
        AnsibleThemeHooks.shared.image(.iconGroupCallStatusScreencast).precomposed(GroupCallTheme.blueStatusColor)
    }
    public static var status_screencast_green: CGImage {
        AnsibleThemeHooks.shared.image(.iconGroupCallStatusScreencast).precomposed(GroupCallTheme.greenStatusColor)
    }
    public static var status_screencast_red: CGImage {
        AnsibleThemeHooks.shared.image(.iconGroupCallStatusScreencast).precomposed(GroupCallTheme.speakLockedColor)
    }
    public static var status_muted_red: CGImage {
        AnsibleThemeHooks.shared.image(.iconGroupCallStatusMuted).precomposed(GroupCallTheme.speakLockedColor)
    }
    public static var status_unmuted_accent: CGImage {
        AnsibleThemeHooks.shared.image(.iconGroupCallStatusUnmuted).precomposed(GroupCallTheme.blueStatusColor)
    }
    public static var status_unmuted_green: CGImage {
        AnsibleThemeHooks.shared.image(.iconGroupCallStatusUnmuted).precomposed(GroupCallTheme.greenStatusColor)
    }
    public static var status_unmuted_gray: CGImage {
        AnsibleThemeHooks.shared.image(.iconGroupCallStatusUnmuted).precomposed(GroupCallTheme.grayStatusColor)
    }
    public static var invite_listener: CGImage {
        AnsibleThemeHooks.shared.image(.iconVoiceChatInviteListener).precomposed(GroupCallTheme.customTheme.accentColor, flipVertical: true)
    }
    public static var invite_speaker: CGImage {
        AnsibleThemeHooks.shared.image(.iconVoiceChatInviteSpeaker).precomposed(customTheme.accentColor, flipVertical: true)
    }
    public static var invite_link: CGImage {
        AnsibleThemeHooks.shared.image(.iconInviteViaLink).precomposed(GroupCallTheme.customTheme.accentColor, flipVertical: true)
    }
    public static var unpin_window: CGImage {
        AnsibleThemeHooks.shared.image(.iconGroupCallUnpin).precomposed(.white)
    }
    public static var hide_peers: CGImage {
        AnsibleThemeHooks.shared.image(.iconVoiceChatHidePeers).precomposed(GroupCallTheme.customTheme.accentColor, flipHorizontal: true)
    }

    public static let smallTableWidth: CGFloat = 160
    public static let fullScreenThreshold: CGFloat = 500

    public static let tileTableWidth: CGFloat = 200
    
    public static var minSize:NSSize {
        return NSMakeSize(380, 600)
    }
    public static var minFullScreenSize:NSSize {
        return NSMakeSize(380, 380)
    }
    

    private static var switchAppearance: SwitchViewAppearance {
        return SwitchViewAppearance(backgroundColor: GroupCallTheme.membersColor, stateOnColor: GroupCallTheme.blueStatusColor, stateOffColor: GroupCallTheme.grayStatusColor, disabledColor: GroupCallTheme.grayStatusColor.withAlphaComponent(0.5), borderColor: GroupCallTheme.memberSeparatorColor)
    }
    
    public static var customTheme: GeneralRowItem.Theme {
        GeneralRowItem.Theme(backgroundColor: GroupCallTheme.membersColor,
                                        grayBackground: GroupCallTheme.windowBackground,
                                        grayForeground: GroupCallTheme.grayStatusColor,
                                        highlightColor: GroupCallTheme.windowBackground.withAlphaComponent(0.25),
                                        borderColor: GroupCallTheme.memberSeparatorColor,
                                        accentColor: GroupCallTheme.blueStatusColor,
                                        secondaryColor: GroupCallTheme.grayStatusColor,
                                        textColor: NSColor(rgb: 0xffffff),
                                        grayTextColor: GroupCallTheme.grayStatusColor,
                                        underSelectedColor: NSColor(rgb: 0xffffff),
                                        accentSelectColor: GroupCallTheme.blueStatusColor.darker(),
                                        redColor: GroupCallTheme.speakLockedColor,
                                        indicatorColor: NSColor(rgb: 0xffffff),
                                        appearance: darkPalette.appearance,
                                        switchAppearance: switchAppearance,
                                        unselectedImage: generateChatGroupToggleUnselected(foregroundColor: GroupCallTheme.grayStatusColor.withAlphaComponent(0.6), backgroundColor: NSColor.black.withAlphaComponent(0.01)),
                                        selectedImage: generateChatGroupToggleSelected(foregroundColor: GroupCallTheme.blueStatusColor, backgroundColor: NSColor(rgb: 0xffffff)))
    }
        
}
