import Cocoa
import TelegramCore

import Postbox
import SwiftSignalKit
#if SHARE
import AnsibleThemeShare
import AnsibleContextShare
#else
import AnsibleTheme
import AnsibleContext
#endif







public func upgradedAccounts(accountManager: AccountManager<TelegramAccountManagerTypes>, rootPath: String, encryptionParameters: ValueBoxEncryptionParameters) -> Signal<Float, NoError> {
    return .complete()
}
