import Cocoa
import AnsibleUIKit
import Postbox
import SettingsUI

func installBlockedPeersUIHooks() {
    BlockedPeersHooks.install(BlockedPeersHooks(
        openPeerInfo: { navigation, context, peerId in
        PeerInfoController.push(navigation: navigation, context: context as! AccountContext, peerId: peerId) }
    ))
}
