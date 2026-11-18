import Foundation
import Postbox
import TelegramCore

public struct AnsibleContextHooks {
    public let peerTitle: (Peer) -> String

    public init(peerTitle: @escaping (Peer) -> String) {
        self.peerTitle = peerTitle
    }

    public static var shared: AnsibleContextHooks = AnsibleContextHooks(peerTitle: { _ in return "" })
}

public func installAnsibleContextHooks(_ hooks: AnsibleContextHooks) {
    AnsibleContextHooks.shared = hooks
}
