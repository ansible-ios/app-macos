import Foundation

struct WidgetData: Equatable {
    var chatData: String?
    var publicData: String?
}

final class Host {
    private(set) var received: [WidgetData] = []

    func setData(_ data: WidgetData) {
        precondition(Thread.isMainThread)
        received.append(data)
    }
}

final class Bubble {
    let lock = NSLock()
    var twidgetPrepared: (value: (host: Host, key: String), key: String)?
    var twidgetHost: Host?

__PRODUCTION__
}

func deliverFromBackground(_ data: WidgetData, to bubble: Bubble) {
    let done = DispatchSemaphore(value: 0)
    DispatchQueue.global().async {
        bubble.updateWidgetData(data)
        done.signal()
    }
    precondition(done.wait(timeout: .now() + 5) == .success)
}

func drainMainQueue() {
    var drained = false
    DispatchQueue.main.async { drained = true }
    let deadline = Date().addingTimeInterval(5)
    while !drained && Date() < deadline {
        RunLoop.main.run(until: Date().addingTimeInterval(0.01))
    }
    precondition(drained)
}

let bubble = Bubble()
let prepared = Host()
let live = Host()
bubble.twidgetPrepared = ((prepared, "prepared"), "row")
bubble.twidgetHost = live

let initial = WidgetData(chatData: "chat:1", publicData: "public:1")
let online = WidgetData(chatData: "chat:2", publicData: "public:2")
let replay = WidgetData(chatData: "chat:3", publicData: nil)
bubble.updateWidgetData(initial)
deliverFromBackground(online, to: bubble)
drainMainQueue()
precondition(live.received == [initial, online])
precondition(prepared.received == live.received)

deliverFromBackground(online, to: bubble)
bubble.updateWidgetData(replay)
drainMainQueue()
precondition(live.received == [initial, online, replay], "Queued live state overwrote replay")
precondition(prepared.received == live.received)
precondition(bubble.widgetData == replay)

let next = WidgetData(chatData: nil, publicData: "public:4")
deliverFromBackground(next, to: bubble)
let replacement = Host()
bubble.twidgetPrepared = ((replacement, "replacement"), "row")
drainMainQueue()
precondition(replacement.received == [next], "Current prepared host missed the update")
precondition(prepared.received == [initial, online, replay])
precondition(live.received.last == next)
print("Widget delivery: live, cleared state after replay, and replacement host PASS")
