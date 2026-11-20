import Foundation
import SwiftSignalKit

typealias PeerId = Int64
struct ChannelFlags: OptionSet {
    let rawValue: Int
    static let isForum = Self(rawValue: 1)
    static let displayForumAsTabs = Self(rawValue: 2)
    static let displayForumAsSidebar = Self(rawValue: 4)
}
struct Channel { let flags: ChannelFlags }
enum EnginePeer {
    typealias Id = PeerId
    case channel(Channel)
}
enum ForumDisplayMode { case list, tabs, sidebar }
enum Api {
    enum Bool: Equatable { case boolTrue, boolFalse }
    struct InputChannel {}
    struct Updates { let id: Int }
    struct Request {
        let enabled: Bool
        let tabs: Bool
        let sidebar: Bool
    }
    enum functions {
        enum channels {
            static func toggleForum(channel: InputChannel, enabled: Api.Bool, tabs: Api.Bool, sidebar: Api.Bool) -> Request {
                Request(enabled: enabled, tabs: tabs, sidebar: sidebar)
            }
        }
    }
}
struct MTRpcError { let description: String }
final class Transaction {
    var hasPeer = true
    var inputAvailable = true
    func getPeer(_ id: PeerId) -> Transaction? { hasPeer ? self : nil }
}
func apiInputChannel(_ peer: Transaction) -> Api.InputChannel? { peer.inputAvailable ? Api.InputChannel() : nil }
final class Postbox {
    let value = Transaction()
    func transaction<T>(_ action: @escaping (Transaction) -> T) -> Signal<T, NoError> { .single(action(value)) }
}
final class Network {
    var requests: [Api.Request] = []
    var fail: ((String) -> Void)?
    var succeed: (() -> Void)?
    var cancelled = 0
    func request(_ value: Api.Request) -> Signal<Api.Updates, MTRpcError> {
        return Signal { subscriber in
            self.requests.append(value)
            self.fail = { subscriber.putError(MTRpcError(description: $0)) }
            self.succeed = { subscriber.putNext(Api.Updates(id: self.requests.count)); subscriber.putCompletion() }
            return ActionDisposable { self.cancelled += 1 }
        }
    }
}
final class AccountStateManager {
    var updates: [Api.Updates] = []
    func addUpdates(_ value: Api.Updates) { updates.append(value) }
}
__CORE__
final class Account {
    let postbox = Postbox()
    let network = Network()
    let stateManager = AccountStateManager()
}
final class EnginePeers {
    let account: Account
    init(_ account: Account) { self.account = account }
__FACADE__
}
final class Engine {
    let peers: EnginePeers
    init(_ account: Account) { peers = EnginePeers(account) }
}
final class Window { var alerts = 0 }
final class Context {
    let account = Account()
    lazy var engine = Engine(account)
    let window = Window()
}
func showModalProgress<T, E>(signal: Signal<T, E>, for window: Window) -> Signal<T, E> { signal }
func alert(for window: Window, info: String) { window.alerts += 1 }
struct Strings { let unknownError = "Error" }
func strings() -> Strings { Strings() }
final class Arguments {
    let toggleForum: () -> Void
    let selectMode: (ForumDisplayMode) -> Void
    init(context: Context, toggleForum: @escaping () -> Void, selectMode: @escaping (ForumDisplayMode) -> Void) {
        self.toggleForum = toggleForum
        self.selectMode = selectMode
    }
}
__STATE__
struct Harness {
    let actions: Arguments
    let receive: (EnginePeer?) -> Void
    let state: () -> State
    let close: () -> Void
}
func makeHarness(_ context: Context) -> Harness {
    let peerId: PeerId = 111
    let actionsDisposable = DisposableSet()
__SETUP__
    var window: Window { context.window }
__ACTIONS__
    let receive: (EnginePeer?) -> Void = { peer in
__RECEIVE__
    }
    return Harness(actions: arguments, receive: receive, state: { stateValue.with { $0 } }, close: { actionsDisposable.dispose() })
}
var checks = 0
func expect(_ value: @autoclosure () -> Bool, _ name: String) {
    guard value() else { fatalError("FAIL: " + name) }
    checks += 1
}
func drain() { RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.02)) }

for failure in ["CHAT_ADMIN_REQUIRED", "NETWORK_ERROR", "INTERNAL"] {
    let account = Account()
    var errors = 0
    var completed = 0
    let disposable = EnginePeers(account).setChannelForumMode(id: 111, isForum: true, displayForumAsTabs: true, displayForumAsSidebar: true).start(error: { _ in errors += 1 }, completed: { completed += 1 })
    account.network.fail?(failure)
    expect(errors == 1 && completed == 0, failure + " propagates instead of success")
    expect(account.stateManager.updates.isEmpty, failure + " publishes no updates")
    disposable.dispose()
}
for missingPeer in [false, true] {
    let account = Account()
    account.postbox.value.hasPeer = !missingPeer
    account.postbox.value.inputAvailable = missingPeer
    var errors = 0
    let disposable = EnginePeers(account).setChannelForumMode(id: 111, isForum: true, displayForumAsTabs: true, displayForumAsSidebar: true).start(error: { _ in errors += 1 })
    expect(errors == 1 && account.network.requests.isEmpty, "missing peer/input fails without network")
    disposable.dispose()
}
for enabled in [false, true] {
    for tabs in [false, true] {
        for sidebar in [false, true] {
            let account = Account()
            var completed = 0
            let disposable = EnginePeers(account).setChannelForumMode(id: 111, isForum: enabled, displayForumAsTabs: tabs, displayForumAsSidebar: sidebar).start(completed: { completed += 1 })
            let request = account.network.requests[0]
            expect(request.enabled == (enabled ? .boolTrue : .boolFalse) && request.tabs == (tabs ? .boolTrue : .boolFalse) && request.sidebar == (sidebar ? .boolTrue : .boolFalse), "all Layer 233 mode arguments preserved")
            account.network.succeed?()
            expect(completed == 1 && account.stateManager.updates.count == 1, "success applies updates exactly once")
            disposable.dispose()
        }
    }
}
let context = Context()
let h = makeHarness(context)
h.actions.toggleForum()
expect(context.account.network.requests.isEmpty, "no edits before peer load")
h.receive(.channel(Channel(flags: [.isForum])))
h.actions.selectMode(.sidebar)
expect(h.state().isUpdating && h.state().mode == .sidebar, "sidebar change in flight")
h.actions.selectMode(.tabs)
h.actions.toggleForum()
expect(context.account.network.requests.count == 1 && h.state().mode == .sidebar, "rapid actions cannot race pending request")
context.account.network.fail?("CHAT_ADMIN_REQUIRED")
drain()
expect(h.state().mode == .list && !h.state().isUpdating && context.window.alerts == 1, "failure restores confirmed mode and shows error")
h.actions.selectMode(.tabs)
context.account.network.succeed?()
drain()
expect(!h.state().isUpdating && h.state().mode == .tabs && context.account.stateManager.updates.count == 1, "retry succeeds and releases pending state")
h.receive(.channel(Channel(flags: [.isForum, .displayForumAsTabs, .displayForumAsSidebar])))
expect(h.state().mode == .sidebar, "live peer change updates selected mode")
h.actions.toggleForum()
h.receive(.channel(Channel(flags: [.isForum, .displayForumAsTabs])))
context.account.network.fail?("NETWORK_ERROR")
drain()
expect(h.state().isForum && h.state().mode == .tabs, "rollback follows latest authoritative live state")
h.actions.selectMode(.sidebar)
let before = context.account.network.cancelled
h.close()
expect(context.account.network.cancelled > before, "closing controller cancels its request")
let alerts = context.window.alerts
context.account.network.fail?("NETWORK_ERROR")
drain()
expect(context.window.alerts == alerts, "cancelled controller receives no late error")
print("Forum/sidebar errors: \(checks) checks PASS")

enum TelegramMediaActionType {
    enum ForumTopicEditComponent: Equatable {
        case title(String)
        case iconFileId(Int64?)
        case isClosed(Bool)
        case isHidden(Bool)
    }
}
__TOPIC__
__WIDGET_CHANGE__
struct TelegramMediaWidget: Equatable {
    let width: Int32
    let height: Int32
    let payload: Data
    let isCopy: Bool
    let canQuery: Bool
    let backgroundQuery: Bool
    let chatData: Data?
    let publicData: Data?
    let publicDataHash: Int64?
    let widgetId: Int64?
}
__WIDGET_UPDATE__
let priorChecks = checks
expect(forumTopicEditComponents(title: nil, iconEmojiId: nil, closed: nil, hidden: nil).isEmpty, "absent topic fields leave state unchanged")
expect(forumTopicEditComponents(title: "", iconEmojiId: 0, closed: .boolFalse, hidden: .boolFalse) == [.title(""), .iconFileId(nil), .isClosed(false), .isHidden(false)], "empty title, zero icon and false flags are applied")
expect(forumTopicEditComponents(title: "Topic", iconEmojiId: 777, closed: .boolTrue, hidden: .boolTrue) == [.title("Topic"), .iconFileId(777), .isClosed(true), .isHidden(true)], "all positive topic fields applied")
expect(messageWidgetDataChange(nil) == .unchanged, "absent widget field is unchanged")
expect(messageWidgetDataChange("") == .set(nil), "empty widget field clears stored data")
expect(messageWidgetDataChange("Привет") == .set(Data("Привет".utf8)), "widget state preserves Unicode")
let old = Data("old".utf8)
let replacement = Data("new".utf8)
let widget = TelegramMediaWidget(width: 200, height: 100, payload: Data([1,2,3]), isCopy: false, canQuery: true, backgroundQuery: true, chatData: old, publicData: old, publicDataHash: 11, widgetId: 987)
let changes: [MessageWidgetDataChange] = [.unchanged, .set(nil), .set(replacement)]
for chat in changes {
    for shared in changes {
        let updated = widget.withUpdatedState(chatData: chat, publicData: shared, publicDataHash: 22)
        var expectedChat: Data? = old
        var expectedShared: Data? = old
        var expectedHash: Int64? = 11
        if case let .set(value) = chat { expectedChat = value }
        if case let .set(value) = shared { expectedShared = value; expectedHash = 22 }
        expect(updated.chatData == expectedChat && updated.publicData == expectedShared && updated.publicDataHash == expectedHash, "independent absent/clear/replace widget states and hash")
        expect(updated.width == widget.width && updated.height == widget.height && updated.payload == widget.payload && updated.isCopy == widget.isCopy && updated.canQuery == widget.canQuery && updated.backgroundQuery == widget.backgroundQuery && updated.widgetId == widget.widgetId, "widget updates preserve identity, payload, flags and dimensions")
        expect(updated.withUpdatedState(chatData: chat, publicData: shared, publicDataHash: 22) == updated, "repeated widget data update is idempotent")
    }
}
print("Layer 233 topic/widget semantics: \(checks - priorChecks) checks PASS")

enum CreateChannelError { case generic }
func finishForumCreation(postbox: Postbox, network: Network, stateManager: AccountStateManager, peerId: PeerId) -> Signal<PeerId, CreateChannelError> {
__CREATION__
}
for failure in [false, true] {
    let account = Account()
    var result: PeerId?
    var errors = 0
    let disposable = finishForumCreation(postbox: account.postbox, network: account.network, stateManager: account.stateManager, peerId: 111).start(next: { result = $0 }, error: { _ in errors += 1 })
    if failure { account.network.fail?("CHAT_ADMIN_REQUIRED") } else { account.network.succeed?() }
    expect(failure ? (errors == 1 && result == nil) : (errors == 0 && result == 111), "forum creation continuation preserves errors and success")
    disposable.dispose()
}
print("Forum creation continuation: 2 checks PASS")
