import Cocoa
import AnsibleUIKit
import Postbox
import SettingsUI

func installLogoutUIHooks() {
    LogoutHooks.install(LogoutHooks(
        makeStorageUsageController: { context in
        StorageUsageController(context as! AccountContext) },
        makeChatController: { context, peerId in
        ChatController(context: context as! AccountContext, chatLocation: .peer(peerId)) },
        openFaq: { context in
        openFaq(context: context as! AccountContext) },
        logoutConfirmationText: { context in
        .single(strings().accountConfirmLogoutText) }
    ))
}
