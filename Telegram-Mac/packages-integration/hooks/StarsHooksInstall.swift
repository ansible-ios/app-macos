import Cocoa
import TGUIKit
import Postbox
import TelegramCore
import SwiftSignalKit
import StarsUI
import GiftCraftingUI
import TelegramMedia
import InputView
import InputTextView
import AppAnalytics

private func giftsContext(_ context: any AccountContextProtocol) -> AccountContext? {
    return context as? AccountContext
}

func installStarsUIHooks() {
    var hooks = StarsHooks(openChat: { context, peerId, action in
        guard let context = giftsContext(context) else { return }
        context.bindings.rootNavigation().push(ChatAdditionController(context: context, chatLocation: .peer(peerId), initialAction: action))
    }, openChatAt: { context, messageId in
        guard let context = giftsContext(context) else { return }
        context.bindings.rootNavigation().push(ChatAdditionController(context: context, chatLocation: .peer(messageId.peerId), focusTarget: .init(messageId: messageId)))
    }, openChatIfNotCurrent: { context, peerId in
        guard let context = giftsContext(context) else { return }
        let controller = context.bindings.rootNavigation().controller as? ChatController
        if controller?.chatLocation.peerId != peerId {
            context.bindings.rootNavigation().push(ChatAdditionController(context: context, chatLocation: .peer(peerId)))
        }
    }, isBubbledServiceItem: { item in
        if let item = item as? ChatServiceItem {
            return item.isBubbled
        }
        return false
    }, wearGiftBoostLevel: { context in
        guard let context = giftsContext(context) else { return 0 }
        return BoostSubject.wearGift.requiredLevel(context: context, group: false, configuration: .with(appConfiguration: context.appConfiguration))
    }, openBoostForWear: { context, channel, stats, myStatus, window in
        guard let context = giftsContext(context), let stats = stats else { return }
        showModal(with: BoostChannelModalController(context: context, peer: channel, boosts: stats, myStatus: myStatus, infoOnly: false, source: .wearStatus, presentation: theme), for: window)
    }, makeGiftMessagePreview: { initialSize, stableId, context, gift, message, send in
        guard let context = giftsContext(context) else {
            preconditionFailure("gift message preview requires a concrete AccountContext")
        }
        return AddGiftMessagePreviewItem(initialSize, stableId: stableId, context: context, gift: gift, message: message, send: send)
    }, openInviteHash: { context, inviteHash, joined in
        guard let context = giftsContext(context) else { return }
        execute(inapp: .joinchat(link: "", inviteHash, context: context, callback: { peerId, _, _, _ in
            joined(peerId)
        }))
    }, showEmojiPicker: { context, control, insertAnimated, insertText in
        guard let context = giftsContext(context) else { return }
        let emojis = EmojiesController(context, ignorePremium: true)
        emojis.analyticsScreen = .appEmojiPicker
        emojis._frameRect = NSMakeRect(0, 0, 350, 300)
        let interactions = EntertainmentInteractions(.emoji, peerId: context.peerId)
        emojis.update(with: interactions, chatInteraction: ChatInteraction(chatLocation: .peer(context.peerId), context: context))
        interactions.sendAnimatedEmoji = { sticker, _, _, _, _ in
            let file = sticker.file._parse()
            insertAnimated(file, file.customEmojiText ?? file.stickerText ?? clown)
        }
        interactions.sendEmoji = { string, _ in
            insertText(string)
        }
        showPopover(for: control, with: emojis)
    }, makeInputTextRow: { initialSize, stableId, context, state, placeholder, limit, filter, updateState in
        guard let context = giftsContext(context) else {
            preconditionFailure("input text row requires a concrete AccountContext")
        }
        return InputTextDataRowItem(initialSize, stableId: stableId, context: context, state: state, viewType: .lastItem, placeholder: nil, inputPlaceholder: placeholder, filter: filter, updateState: updateState, limit: limit, hasEmoji: true)
    }, openPeerInfo: { context, peerId in
        guard let context = giftsContext(context) else { return }
        PeerInfoController.push(navigation: context.bindings.rootNavigation(), context: context, peerId: peerId)
    }, openGiftsProfile: { context, peerId, starGiftsProfile in
        guard let context = giftsContext(context) else { return }
        PeerInfoController.push(navigation: context.bindings.rootNavigation(), context: context, peerId: peerId, mediaMode: .gifts, shake: false, starGiftsProfile: starGiftsProfile)
    }, makeStickerView: { frame in
        return MediaAnimatedStickerView(frame: frame)
    }, applyMessageEntities: { entities, text, context, fontSize, openInfo, textColor, isDark, bubbled in
        guard let context = giftsContext(context) else { return NSAttributedString() }
        if let textColor = textColor {
            return ChatMessageItem.applyMessageEntities(with: [TextEntitiesMessageAttribute(entities: entities)], for: text, message: nil, context: context, fontSize: fontSize, openInfo: openInfo, textColor: textColor, isDark: isDark, bubbled: bubbled)
        }
        return ChatMessageItem.applyMessageEntities(with: [TextEntitiesMessageAttribute(entities: entities)], for: text, message: nil, context: context, fontSize: fontSize, openInfo: openInfo, isDark: isDark, bubbled: bubbled)
    }, applyGiftMessagePreviewEntities: { entities, text, context in
        return ChatMessageItem.applyMessageEntities(with: [TextEntitiesMessageAttribute(entities: entities)], for: text, message: nil, context: context, fontSize: theme.fontSize, openInfo: { _, _, _, _ in }, textColor: .white, linkColor: .white, isDark: theme.colors.isDark, bubbled: true)
    }, shareLink: { context, link, window in
        guard let context = giftsContext(context) else { return }
        showModal(with: ShareModalController(ShareLinkObject(context, link: link)), for: window)
    }, openLink: { context, url, openInfo in
        guard let context = giftsContext(context) else { return }
        execute(inapp: inApp(for: url.nsstring, context: context, openInfo: openInfo))
    }, inputTextViewSize: { view, width in
        guard let view = view as? UITextView else { return (.zero, 0) }
        return inputTextViewSize(view, width: width)
    }, openMiniApp: { context, peer in
        guard let context = giftsContext(context) else { return }
        BrowserStateContext.get(context).open(tab: .mainapp(bot: peer, source: .generic))
    }, makeAvatarMenuItem: { context, peer in
        guard let context = giftsContext(context) else { return nil }
        return GroupCallAvatarMenuItem(peer, context: context)
    }, giftTransferBlockchainOption: { context, window, gift, reference, profileGiftsContext in
        return nil
    }, giftMoveToGiftsAction: { _, _, _ in
        return nil
    }, selectContact: { context, window, title, confirmation in
        guard let context = giftsContext(context) else { return .single([]) }
        return selectModalPeers(window: window, context: context, title: title, behavior: SelectContactsBehavior(limit: 1), confirmation: confirmation)
    }, openMultigift: { context, starsOnly in
        guard let context = giftsContext(context) else { return }
        multigift(context: context, type: starsOnly ? .stars : .both)
    }, openStarMonetization: { context, peerId, revenueContext in
        guard let context = giftsContext(context) else { return }
        context.bindings.rootNavigation().push(FragmentStarMonetizationController(context: context, peerId: peerId, revenueContext: revenueContext))
    }, openMessagesPrivacy: { context, noPaidMessages, globalSettings, updated in
        guard let context = giftsContext(context) else { return }
        context.bindings.rootNavigation().push(MessagesPrivacyController(context: context, noPaidMessages: noPaidMessages, globalSettings: globalSettings, updated: updated))
    }, showGalleryMedia: { context, medias, parent, delegate in
        guard let context = giftsContext(context) else { return }
        showGalleryMedia(context: context, medias: medias, parent: parent, firstIndex: 0, firstStableId: ChatHistoryEntryId.mediaId(0, parent), delegate, nil)
    }, makeRecentPeerRow: { initialSize, peer, context, stableId, status, action in
        guard let context = giftsContext(context) else {
            preconditionFailure("recent peer row requires a concrete AccountContext")
        }
        return RecentPeerRowItem(initialSize, peer: peer, account: context.account, context: context, stableId: stableId, statusStyle: ControlStyle(font: .normal(.text), foregroundColor: theme.colors.grayText, highlightColor: .white), status: status, action: action)
    }, makeFilterChipRow: { initialSize, stableId, context, text, selected, select, contextMenu in
        guard let context = giftsContext(context) else {
            preconditionFailure("filter chip row requires a concrete AccountContext")
        }
        return FilterChipRowItem(initialSize, stableId: stableId, context: context, text: text, selected: selected, select: select, contextMenu: contextMenu)
    }, makeSelectGiftsModal: { context, collectionId, peerId, callback in
        guard let context = giftsContext(context) else {
            preconditionFailure("select gifts modal requires a concrete AccountContext")
        }
        return SelectGiftsModalController(context: context, collectionId: collectionId, peerId: peerId, callback: callback)
    }, applyMenuItemEmoji: { item, context, file in
        guard let context = giftsContext(context) else {
            return
        }
        ContextMenuItem.makeEmoji(item, context: context, file: file)
    }, makeLiveMessagePreviewRow: { initialSize, stableId, context, message in
        guard let context = giftsContext(context) else {
            preconditionFailure("live message preview requires a concrete AccountContext")
        }
        return StoryMessageItemRow(initialSize, stableId: stableId, message: message, reactions: nil, arguments: StoryMessageArguments.init(context: context, contextMenuItems: { _, _,_  in return [] }, focusMessage: { _ in }), preview: true)
    }, updateBirthday: { date, context in
        editAccountUpdateBirthday(date, context: context)
    }, openAffiliatePeer: { context, peerId, onlyDemo in
        context.bindings.rootNavigation().push(Affiliate_PeerController(context: context, peerId: peerId, onlyDemo: onlyDemo))
    }, makeCraftAboutFeatureItem: { initialSize, stableId, features in
        return CraftAboutFeatureItem(initialSize, stableId: stableId, features: features)
    }, makeCraftingAreaItem: { initialSize, stableId, data in
        return CraftingAreaItem(initialSize, stableId: stableId, data: data)
    })
    installStarsHooks(hooks)
}

extension StoryMessageItemRow: @retroactive StarsLiveMessagePreviewRow {

}

extension MediaAnimatedStickerView: @retroactive StarsStickerView {
    public var starsStickerReady: Signal<Bool, NoError> {
        return firstFrameReady
    }

    public func updateStarsSticker(file: TelegramMediaFile, size: NSSize, context: any AccountContextProtocol, colors: [LottieColor], playback: StarsStickerPlayback, animated: Bool) {
        guard let context = context as? AccountContext else { return }
        let parameters: ChatAnimatedStickerMediaLayoutParameters?
        switch playback {
        case .standard:
            parameters = colors.isEmpty ? nil : ChatAnimatedStickerMediaLayoutParameters(playPolicy: .loop, alwaysAccept: true, media: file, colors: colors, noThumb: true)
        case .previewFrames:
            parameters = ChatAnimatedStickerMediaLayoutParameters(playPolicy: .framesCount(2), alwaysAccept: true, cache: .temporaryLZ4(.thumb), hidePlayer: false, media: file)
        case .onceEnd:
            parameters = ChatAnimatedStickerMediaLayoutParameters(playPolicy: .onceEnd, media: file)
        case .loopHidden:
            let value = ChatAnimatedStickerMediaLayoutParameters(playPolicy: .loop, hidePlayer: true, media: file)
            value.colors = colors
            parameters = value
        }
        if let parameters = parameters {
            self.update(with: file, size: size, context: context, table: nil, parameters: parameters, animated: animated)
        } else {
            self.update(with: file, size: size, context: context, table: nil, animated: animated)
        }
    }
}

extension FilterChipRowItem: @retroactive StarsFilterChipRow {

}
