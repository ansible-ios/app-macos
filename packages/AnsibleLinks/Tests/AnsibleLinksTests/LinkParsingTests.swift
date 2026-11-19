import XCTest
import Postbox
import TelegramCore
@testable import AnsibleLinks

final class LinkParsingTests: XCTestCase {
    private var enabled: InAppLinkParsingOptions {
        InAppLinkParsingOptions(hasContext: true, hasOpenInfo: true, hasHashtag: true, hasCommand: true, hasApplyProxy: true)
    }

    private func parse(_ value: String, options: InAppLinkParsingOptions? = nil) -> ParsedInAppLink {
        parseInAppLink(value as NSString, options: options ?? enabled)
    }

    private func assertPeer(_ value: String, username: String, post: Int32? = nil, action: ParsedChatLinkAction? = nil, options: InAppLinkParsingOptions? = nil, file: StaticString = #filePath, line: UInt = #line) {
        guard case let .followResolvedName(_, actualName, actualPost, _, actualAction) = parse(value, options: options) else {
            return XCTFail("Expected a peer link: \(value)", file: file, line: line)
        }
        XCTAssertEqual(actualName, username, file: file, line: line)
        XCTAssertEqual(actualPost, post, file: file, line: line)
        XCTAssertEqual(actualAction, action, file: file, line: line)
    }

    func testTelegramDomainsAndSubdomains() {
        for domain in ["asme.su", "www.asme.su"] {
            assertPeer("https://\(domain)/alice/42", username: "alice", post: 42)
        }
        assertPeer("https://alice.asme.su/42", username: "alice", post: 42)
        assertPeer("@alice", username: "alice")
        assertPeer("AS://resolve?domain=alice&post=42", username: "alice", post: 42)
        assertPeer("as://resolve?domain=alice&post=42", username: "alice", post: 42)
        assertPeer("AS://resolve?domain=alice&post=42", username: "alice", post: 42)
    }

    func testForeignApplicationLinksRemainExternal() {
        for value in ["https://t.me/alice", "https://telegram.me/alice", "tg://resolve?domain=alice", "ansible://resolve?domain=alice"] {
            guard case .external = parse(value) else {
                return XCTFail("Foreign application link must remain external: \(value)")
            }
        }
    }

    func testFreeMessageLinks() {
        let cases = [
            ("asme.su/user?free=AAAA", "user", "AAAA"),
            ("as://resolve?username=user&free=AAAA", "user", "AAAA"),
            ("asme.su/+1112223333?free=AAAA", "1112223333", "AAAA"),
            ("as://resolve?phone=1112223333&free=AAAA", "1112223333", "AAAA"),
            ("https://asme.su/user?free=AbC_123-xy", "user", "AbC_123-xy"),
            ("https://asme.su/+1112223333?free=AbC_123-xy", "1112223333", "AbC_123-xy"),
            ("as://resolve?domain=user&free=AbC_123-xy", "user", "AbC_123-xy"),
            ("AS://resolve?username=user&free=AbC%2B123%3D", "user", "AbC+123=")
        ]
        for (value, expectedTarget, expectedToken) in cases {
            guard case let .noPaidMessagesToken(link, target, token) = parse(value) else {
                XCTFail("Expected a free message link: \(value)")
                continue
            }
            XCTAssertEqual(link, normalizeURLScheme(value as NSString) as String)
            XCTAssertEqual(target, expectedTarget, value)
            XCTAssertEqual(token, expectedToken, value)
        }
    }

    func testContactLinksPreserveFreeMessageToken() {
        for value in ["https://asme.su/contact/XXXX:YYYZZZ?free=AABBCC", "as://contact?token=XXXX%3AYYYZZZ&free=AABBCC"] {
            guard case let .contactToken(_, token, freeToken) = parse(value) else {
                XCTFail("Expected contact link: \(value)")
                continue
            }
            XCTAssertEqual(token, "XXXX:YYYZZZ")
            XCTAssertEqual(freeToken, "AABBCC")
        }
        for value in ["asme.su/contact/XXXX:YYYZZZ", "as://contact?token=XXXX:YYYZZZ&free="] {
            guard case let .contactToken(_, token, freeToken) = parse(value) else {
                XCTFail("Expected ordinary contact link: \(value)")
                continue
            }
            XCTAssertEqual(token, "XXXX:YYYZZZ")
            XCTAssertNil(freeToken)
        }
    }

    func testContactLinksRequireNavigation() {
        for options in [InAppLinkParsingOptions(), InAppLinkParsingOptions(hasContext: true), InAppLinkParsingOptions(hasOpenInfo: true)] {
            guard case .external = parse("https://asme.su/contact/XXXX:YYYZZZ?free=AABBCC", options: options) else {
                return XCTFail("Web contact links require navigation")
            }
            guard case .nothing = parse("as://contact?token=XXXX:YYYZZZ&free=AABBCC", options: options) else {
                return XCTFail("Contact scheme links require navigation")
            }
        }
    }

    func testFreeMessageLinksRequireTokenAndNavigation() {
        for query in ["free", "free="] {
            assertPeer("https://asme.su/user?\(query)", username: "user")
            assertPeer("https://asme.su/+1112223333?\(query)", username: "1112223333")
            assertPeer("as://resolve?domain=user&\(query)", username: "user")
            assertPeer("as://resolve?phone=1112223333&\(query)", username: "1112223333")
        }
        for options in [InAppLinkParsingOptions(), InAppLinkParsingOptions(hasContext: true), InAppLinkParsingOptions(hasOpenInfo: true)] {
            for value in ["https://asme.su/user?free=AAAA", "https://asme.su/+1112223333?free=AAAA"] {
                guard case .external = parse(value, options: options) else {
                    XCTFail("A free message web link requires context and openInfo: \(value)")
                    continue
                }
            }
            for value in ["as://resolve?username=user&free=AAAA", "as://resolve?domain=user&free=AAAA", "as://resolve?phone=1112223333&free=AAAA"] {
                guard case .nothing = parse(value, options: options) else {
                    XCTFail("A free message scheme link requires context and openInfo: \(value)")
                    continue
                }
            }
        }
        guard case .nothing = parse("as://resolve?free=AAAA") else {
            return XCTFail("A free message link requires a recipient")
        }
    }

    func testContextAndCallbackAvailabilityPreservesFallback() {
        for options in [InAppLinkParsingOptions(), InAppLinkParsingOptions(hasContext: true), InAppLinkParsingOptions(hasOpenInfo: true)] {
            guard case .external = parse("https://asme.su/alice", options: options) else {
                return XCTFail("A peer web link requires context and openInfo")
            }
            guard case .nothing = parse("as://resolve?domain=alice", options: options) else {
                return XCTFail("A recognized scheme without its requirements returns nothing")
            }
        }
        guard case let .external(value, confirm) = parse("https://example.com", options: InAppLinkParsingOptions(confirm: true)) else {
            return XCTFail("Expected external link")
        }
        XCTAssertEqual(value, "https://example.com")
        XCTAssertTrue(confirm)
    }

    func testCommandsAndHashtagsRequireOnlyTheirCallbackCapability() {
        guard case let .botCommand(command) = parse("/help", options: InAppLinkParsingOptions(hasCommand: true)) else {
            return XCTFail("Expected command")
        }
        XCTAssertEqual(command, "/help")
        for value in ["#topic", "$topic"] {
            guard case let .hashtag(tag) = parse(value, options: InAppLinkParsingOptions(hasHashtag: true)) else {
                return XCTFail("Expected hashtag")
            }
            XCTAssertEqual(tag, value)
        }
        for value in ["/help", "#topic"] {
            guard case .external = parse(value, options: InAppLinkParsingOptions()) else {
                return XCTFail("Missing callbacks must preserve external fallback")
            }
        }
    }

    func testChatActionPayloads() {
        assertPeer("https://asme.su/alice?start=hello%20world", username: "alice", action: .start(parameter: "hello world", behavior: .none))
        assertPeer("as://resolve?domain=alice&text=hello%20world", username: "alice", action: .inputText(text: "hello world", behavior: .automatic))
        assertPeer("as://resolve?domain=alice&voicechat", username: "alice", action: .joinVoiceChat(nil))
        assertPeer("as://resolve?domain=alice&voicechat=abc", username: "alice", action: .joinVoiceChat("abc"))
        assertPeer("as://resolve?domain=alice&videochat", username: "alice", action: .joinVoiceChat(nil))
        assertPeer("as://resolve?domain=alice&videochat=abc", username: "alice", action: .joinVoiceChat("abc"))
        assertPeer("as://resolve?domain=alice&livestream=abc", username: "alice", action: .joinVoiceChat("abc"))
        assertPeer("https://asme.su/alice?videochat", username: "alice", action: .joinVoiceChat(nil))
        assertPeer("https://asme.su/alice?videochat=abc", username: "alice", action: .joinVoiceChat("abc"))
        assertPeer("https://asme.su/alice?voicechat", username: "alice", action: .joinVoiceChat(nil))
        assertPeer("as://resolve?domain=alice&startapp", username: "alice", action: .makeWebview(appname: "", command: nil))
        assertPeer("as://resolve?domain=alice&attach=bot&choose=users+groups", username: "alice", action: .attachBot("bot", nil, ["bot"]))
        assertPeer("as://resolve?domain=alice&direct", username: "alice", action: .direct)
        assertPeer("https://asme.su/alice/app?startapp=payload", username: "alice", action: .makeWebview(appname: "app", command: "payload"))
        assertPeer("https://asme.su/alice/a/4", username: "alice", action: .album(album: 4, mode: .stories))
        assertPeer("https://asme.su/alice/c/5", username: "alice", action: .album(album: 5, mode: .gifts))
    }

    func testSourceMessageTimecodesAndPollOptions() {
        let peerId = PeerId(namespace: Namespaces.Peer.CloudUser, id: PeerId.Id._internalFromInt64Value(1))
        let messageId = MessageId(peerId: peerId, namespace: Namespaces.Message.Cloud, id: 7)
        var options = enabled
        options.messageId = messageId
        assertPeer("https://asme.su/alice/42", username: "alice", post: 42, action: .source(messageId, nil), options: options)
        assertPeer("https://asme.su/alice/42?t=1h2m3s", username: "alice", post: 42, action: .openMedia(3723))
        assertPeer("https://asme.su/c/123/42?t=90", username: "_private_123", post: 42, action: .openMedia(90))
        assertPeer("https://asme.su/alice/42?t=90&option=AQ", username: "alice", post: 42, action: .pollOption(Data([1])))
    }

    func testOutOfRangeTimecodesAreIgnored() {
        let outOfRange = [
            "3000000000000000h",
            "153722867280912931m",
            "9223372036854775807s",
            "2562047788015215h1000000m",
            "99999999999999999999h",
            "596524h",
            "596523h14m8s",
            "3000000000",
        ]
        for t in outOfRange {
            assertPeer("https://asme.su/x/1?t=\(t)", username: "x", post: 1)
            assertPeer("https://asme.su/c/123/42?t=\(t)", username: "_private_123", post: 42)
        }
        assertPeer("https://asme.su/x/1?t=596523h14m7s", username: "x", post: 1, action: .openMedia(Int32.max))
        assertPeer("https://asme.su/x/1?t=596523h", username: "x", post: 1, action: .openMedia(2147482800))
    }

    func testTopicsCommentsAndStories() {
        guard case let .comments(_, username, thread, comment) = parse("https://asme.su/alice/42?comment=7") else {
            return XCTFail("Expected comments")
        }
        XCTAssertEqual(username, "alice")
        XCTAssertEqual(thread, 42)
        XCTAssertEqual(comment, 7)
        guard case let .topic(_, name, topic, post) = parse("https://asme.su/c/123/4/42") else {
            return XCTFail("Expected private topic")
        }
        XCTAssertEqual(name, "_private_123")
        XCTAssertEqual(topic, 4)
        XCTAssertEqual(post, 42)
        guard case let .story(_, storyName, id, _) = parse("https://asme.su/alice/s/9") else {
            return XCTFail("Expected story")
        }
        XCTAssertEqual(storyName, "alice")
        XCTAssertEqual(id, 9)
    }

    func testInvitesAndBotInvitation() {
        for url in ["https://asme.su/+abc", "https://asme.su/joinchat/abc", "as://join?invite=abc"] {
            guard case let .joinchat(_, hash) = parse(url) else { return XCTFail("Expected invite: \(url)") }
            XCTAssertEqual(hash, "abc")
        }
        guard case let .inviteBotToGroup(_, name, action, rights, isChannel) = parse("as://resolve?domain=bot&startchannel&admin=post_messages") else {
            return XCTFail("Expected bot invite")
        }
        XCTAssertEqual(name, "bot")
        XCTAssertNil(action)
        XCTAssertEqual(rights, "post_messages")
        XCTAssertTrue(isChannel)
    }

    func testSettingsDestinationsAndUnknownSections() {
        let cases: [(String, InAppSettingsSection)] = [
            ("as://settings", .general),
            ("as://settings/privacy/auto-delete/delete-all", .privacy(.auto_delete(.delete_all))),
            ("as://settings/appearance/stickers-and-emoji/emoji", .appearance(.stickers_and_emoji(.emoji))),
            ("as://settings/data/proxy/add", .data(.proxy(.add))),
            ("as://settings/notifications/groups/sound", .notifications(.groups(.sound))),
            ("as://settings/notifications/private-chats/add-exception", .notifications(.private_chats(.add_exception))),
            ("as://settings/notifications/channels/preview", .notifications(.channels(.preview))),
            ("as://settings/notifications/stories/show-sender", .notifications(.stories(.show_sender))),
            ("as://settings/notifications/reactions", .notifications(.reactions(nil))),
            ("as://settings/notifications/reactions/messages", .notifications(.reactions(.messages))),
            ("as://settings/notifications/reset", .notifications(.reset)),
            ("as://settings/edit/username", .edit_profile(.username)),
            ("as://settings/privacy/unknown", .privacy(nil))
        ]
        for (url, expected) in cases {
            guard case let .settings(_, section) = parse(url) else { return XCTFail("Expected settings: \(url)") }
            XCTAssertEqual(section, expected)
        }
        guard case .nothing = parse("as://settings/unknown") else { return XCTFail("Expected nothing") }
    }

    func testStickerPackKindsAndPeerIdentifiers() {
        let peerId = PeerId(namespace: Namespaces.Peer.CloudUser, id: PeerId.Id._internalFromInt64Value(9))
        var options = enabled
        options.peerId = peerId
        guard case let .stickerPack(_, source, actualPeer) = parse("https://asme.su/addstickers/cats", options: options) else {
            return XCTFail("Expected stickers")
        }
        XCTAssertEqual(source, .stickers("cats"))
        XCTAssertEqual(actualPeer, peerId)
        guard case let .stickerPack(_, emoji, schemePeer) = parse("as://addemoji?set=cats", options: options) else {
            return XCTFail("Expected emoji")
        }
        XCTAssertEqual(emoji, .emoji("cats"))
        XCTAssertNil(schemePeer)
    }

    func testProxyLinksAndMissingRequirements() {
        for url in ["as://socks?server=localhost&port=1080&user=alice&pass=secret", "https://asme.su/socks?server=localhost&port=1080&user=alice&pass=secret"] {
            guard case let .socks(_, settings) = parse(url) else { return XCTFail("Expected socks proxy") }
            XCTAssertEqual(settings.host, "localhost")
            XCTAssertEqual(settings.port, 1080)
            guard case let .socks5(username, password) = settings.connection else { return XCTFail("Expected SOCKS5") }
            XCTAssertEqual(username, "alice")
            XCTAssertEqual(password, "secret")
        }
        let secret = String(repeating: "01", count: 16)
        guard case let .socks(_, settings) = parse("as://proxy?server=localhost&port=443&secret=\(secret)") else {
            return XCTFail("Expected MTProto proxy")
        }
        guard case .mtp = settings.connection else { return XCTFail("Expected MTProto") }
        guard case .socks = parse("as://webproxy?server=example.com&secret=\(secret)") else {
            return XCTFail("Expected web proxy")
        }
        for url in ["as://socks?server=localhost&port=bad", "as://proxy?server=localhost&port=443&secret=invalid"] {
            guard case .nothing = parse(url) else { return XCTFail("Malformed proxy must not be accepted") }
        }
        guard case .nothing = parse("as://socks?server=localhost&port=1080", options: InAppLinkParsingOptions(hasContext: true)) else {
            return XCTFail("Proxy links require applyProxy")
        }
        XCTAssertNotNil(proxySettings(from: "as://socks?server=localhost&port=1080").0)
        XCTAssertNil(proxySettings(from: "https://asme.su/socks?server=localhost&port=1080").0)
    }

    func testUnsupportedWalletRoutes() {
        for link in ["ton://transfer/address?amount=123", "tc://connect", "tonsite://alice.ton", "https://alice.ton/path", "as://grams", "as://sendgrams?to=@alice", "https://asme.su/sendgrams", "as://settings/ton", "https://ASME.SU/GrAmS", "as://sendgrams&to=alice", "https://alice.ton./path", "gram://transfer", "tg://?v=2&r=payload"] {
            guard case .nothing = parse(link) else { return XCTFail(link) }
        }
    }

    func testTelegramLinkQueryNormalization() {
        XCTAssertEqual(
            normalizedAnsibleLinkQuery("as://sendgrams&startapp=tonconnect-v__2"),
            "as://sendgrams?startapp=tonconnect-v__2"
        )
        XCTAssertEqual(
            normalizedAnsibleLinkQuery("telegram://sendgrams&startapp=a&b=c"),
            "telegram://sendgrams&startapp=a&b=c"
        )
        for unchanged in [
            "as://sendgrams?startapp=a&b=c",
            "as://resolve?domain=alice",
            "as://sendgrams",
            "https://asme.su/sendgrams&startapp=a"
        ] {
            XCTAssertEqual(normalizedAnsibleLinkQuery(unchanged), unchanged, unchanged)
        }
    }


    func testURLAuthenticationPrecedence() {
        var options = enabled
        options.urlAuthDomains = ["t.me"]
        guard case .urlAuth = parse("https://asme.su/alice", options: options) else { return XCTFail("Authentication precedes peer parsing") }
        options.hasContext = false
        guard case .external = parse("https://asme.su/alice", options: options) else { return XCTFail("Authentication requires context") }
    }

    func testWallpaperSettings() {
        guard case let .wallpaper(_, .gradient(_, colors, settings)) = parse("https://asme.su/bg/ff0000~00ff00?rotation=45&intensity=20&mode=blur") else {
            return XCTFail("Expected gradient")
        }
        XCTAssertEqual(colors.count, 2)
        XCTAssertEqual(settings.rotation, 45)
        XCTAssertEqual(settings.intensity, 20)
        XCTAssertTrue(settings.blur)
        guard case let .wallpaper(_, .slug(slug, invalidSettings)) = parse("as://bg?slug=wallpaper&rotation=46") else {
            return XCTFail("Expected wallpaper slug")
        }
        XCTAssertEqual(slug, "wallpaper")
        XCTAssertNil(invalidSettings.rotation)
    }

    func testSecureIDLegacyAndModernPayloads() {
        let cases = [
            ("as://passport?bot_id=123&scope=identity&public_key=key&payload=abc", false, "identity"),
            ("as://resolve?domain=telegrampassport&bot_id=123&scope=%7B%7D&public_key=key&nonce=abc", true, "{}")
        ]
        for (url, modern, scope) in cases {
            guard case let .requestSecureId(_, request) = parse(url) else { return XCTFail("Expected secure ID") }
            XCTAssertEqual(request.scope, scope)
            XCTAssertEqual(request.isModern, modern)
            XCTAssertEqual(request.publicKey, "key")
            XCTAssertEqual(request.nonce, Data("abc".utf8))
        }
    }

    func testSharingAndLoginWithoutNavigation() {
        guard case let .shareUrl(_, url, text) = parse("as://msg_url?url=https%3A%2F%2Fexample.com&text=hello+world") else {
            return XCTFail("Expected share data")
        }
        XCTAssertEqual(url, "https://example.com")
        XCTAssertEqual(text, "hello world")
        guard case let .loginCode(_, code) = parse("as://login?code=12345", options: InAppLinkParsingOptions()) else {
            return XCTFail("Login code does not require context")
        }
        XCTAssertEqual(code, "12345")
    }

    func testUnknownAndFileSchemes() {
        guard case .nothing = parse("file:///tmp/example") else { return XCTFail("File links must not execute") }
        guard case let .unsupportedScheme(_, path) = parse("as://unknown?value=1") else { return XCTFail("Expected unsupported scheme") }
        XCTAssertEqual(path, "unknown")
        guard case .external = parse("as://unknown", options: InAppLinkParsingOptions()) else { return XCTFail("Expected external fallback") }
        guard case .nothing = parse("as://resolve") else { return XCTFail("Missing required arguments") }
    }

    func testFeatureRoutePayloads() {
        let cases: [(String, (ParsedInAppLink) -> Bool)] = [
            ("as://confirmphone?phone=123&hash=abc", { if case .confirmPhone(_, "123", "abc") = $0 { return true }; return false }),
            ("as://setlanguage?lang=en", { if case .applyLocalization(_, "en") = $0 { return true }; return false }),
            ("https://asme.su/addtheme/night", { if case .theme(_, "night") = $0 { return true }; return false }),
            ("as://invoice?slug=invoice", { if case .invoice(_, "invoice") = $0 { return true }; return false }),
            ("as://premium_offer?ref=test", { if case .premiumOffer(_, "test") = $0 { return true }; return false }),
            ("as://restore_purchases", { if case .restorePurchase = $0 { return true }; return false }),
            ("as://addlist?slug=folder", { if case .folder(_, "folder") = $0 { return true }; return false }),
            ("as://boost?channel=123", { if case .boost(_, "_private_123") = $0 { return true }; return false }),
            ("as://giftcode?slug=gift", { if case .gift(_, "gift") = $0 { return true }; return false }),
            ("as://message?slug=business", { if case .businessLink(_, "business") = $0 { return true }; return false }),
            ("as://stars_topup?balance=100&purpose=test", { if case .starsTopup(_, 100, "test") = $0 { return true }; return false }),
            ("as://premium_multigift", { if case .multigift = $0 { return true }; return false }),
            ("as://nft?slug=gift", { if case .nft(_, "gift") = $0 { return true }; return false }),
            ("as://call?slug=call", { if case .joinCall(_, "call") = $0 { return true }; return false }),
            ("as://stars", { if case .starsInfo = $0 { return true }; return false }),
            ("as://ton", { if case .nothing = $0 { return true }; return false }),
            ("as://stargift_auction?slug=gift", { if case .auction(_, "gift") = $0 { return true }; return false }),
            ("as://oauth?token=token", { if case .oauth(_, "token") = $0 { return true }; return false }),
            ("as://newbot?manager=owner&username=bot&name=My%20Bot", { if case .createBot(_, "owner", "bot", "My Bot") = $0 { return true }; return false }),
            ("https://asme.su/addstyle/style", { if case .addStyle(_, "style") = $0 { return true }; return false })
        ]
        for (url, matches) in cases {
            XCTAssertTrue(matches(parse(url)), "Incorrect payload for \(url)")
        }
    }

    func testBotCreationLinksFollowTheSubmoduleUrlRules() {
        func createBot(_ value: String) -> (manager: String, username: String, title: String?)? {
            guard case let .createBot(_, manager, username, title) = parse(value) else {
                return nil
            }
            return (manager, username, title)
        }

        let full = createBot("https://asme.su/newbot/OpenClawBot/durgerkingbot?name=Durger+King")
        XCTAssertEqual(full?.manager, "OpenClawBot")
        XCTAssertEqual(full?.username, "durgerkingbot")
        XCTAssertEqual(full?.title, "Durger King")

        let managerOnly = createBot("https://asme.su/newbot/OpenClawBot")
        XCTAssertEqual(managerOnly?.manager, "OpenClawBot")
        XCTAssertEqual(managerOnly?.username, "")
        XCTAssertNil(managerOnly?.title)

        XCTAssertEqual(createBot("https://asme.su/newbot/OpenClawBot?name=Durger%20King")?.title, "Durger King")
        XCTAssertEqual(createBot("https://asme.su/newbot/OpenClawBot?name=1%2B1")?.title, "1 1")
        XCTAssertNil(createBot("https://asme.su/newbot/OpenClawBot?title=Durger")?.title)

        let scheme = createBot("as://newbot?manager=OpenClawBot&username=durgerkingbot&name=Durger%20King")
        XCTAssertEqual(scheme?.manager, "OpenClawBot")
        XCTAssertEqual(scheme?.username, "durgerkingbot")
        XCTAssertEqual(scheme?.title, "Durger King")

        let schemeManagerOnly = createBot("as://newbot?manager=OpenClawBot")
        XCTAssertEqual(schemeManagerOnly?.username, "")
        XCTAssertNil(schemeManagerOnly?.title)
        XCTAssertEqual(createBot("as://newbot?manager=OpenClawBot&name=Durger+King")?.title, "Durger+King")

        XCTAssertNil(createBot("as://newbot?username=durgerkingbot&name=Durger"))
        XCTAssertNil(createBot("as://newbot?manager=&username=durgerkingbot"))
        XCTAssertNil(createBot("https://asme.su/newbot/"))
        XCTAssertNil(createBot("https://asme.su/newbot"))
        if case .createBot = parse("as://newbot?manager=OpenClawBot", options: InAppLinkParsingOptions()) {
            XCTFail("A bot creation link needs a context")
        }
        if case .createBot = parse("https://asme.su/newbot/OpenClawBot", options: InAppLinkParsingOptions()) {
            XCTFail("A bot creation link needs a context")
        }
    }

    func testMalformedAndRepeatedValuesKeepExistingBehavior() {
        assertPeer("as://resolve?domain=first&domain=last", username: "last")
        assertPeer("as://resolve?domain=alice&text=hello%2520world", username: "alice", action: .inputText(text: "hello world", behavior: .automatic))
        assertPeer("as://resolve?domain=alice&post=invalid", username: "alice", post: 0)
        guard case .nothing = parse("as://stars_topup?balance=invalid&purpose=test") else {
            return XCTFail("Invalid numeric payload must not produce a top-up")
        }
        guard case let .external(value, _) = parse("https://example.com/?text=%ZZ") else {
            return XCTFail("Malformed percent encoding must retain external fallback")
        }
        XCTAssertEqual(value, "https://example.com/?text=%ZZ")
    }

    func testURLHelpersPreserveDecodingAndEmptyFlags() {
        let (values, flags) = urlVars(with: "https://example.com/?TEXT=a%3Db%2520c&text=last&flag&empty=&token=a=b")
        XCTAssertEqual(values["text"], "last")
        XCTAssertEqual(values["empty"], "")
        XCTAssertEqual(values["token"], "a=b")
        XCTAssertEqual(flags, ["flag"])
        XCTAssertEqual(urlVars(with: "text=a%2520b").0["text"], "a%20b")
        XCTAssertEqual(escape(with: "a%20b", addPercent: false), "a b")
        XCTAssertEqual(normalizeURLScheme("AS://resolve?domain=Alice"), "as://resolve?domain=Alice")
        XCTAssertEqual(explicitUrl("example.com"), "https://example.com")
        XCTAssertEqual(addUrlParameter(value: "x=1", to: "https://example.com"), "https://example.com/x=1")
        XCTAssertEqual(urlWithoutScheme(from: URL(string: "https://example.com/path?q=1#part")!)?.url, "example.com/path?q=1#part")
    }
}
