import Cocoa
import AnsibleUIKit
import Postbox
import TelegramCore
import SwiftSignalKit
import ProxyUI

func installProxyUIHooks() {
    installProxyHooks(.init(currentContext: {
        return appDelegate?.currentContext
    }))
}
