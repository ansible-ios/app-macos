import Cocoa
import TGUIKit
import AnsibleMediaUtils
import CallsUI

func installCallSettingsUIHooks() {
    CallSettingsHooks.install(CallSettingsHooks(devicesContext: { sharedContext in
        return (sharedContext as! SharedAccountContext).devicesContext
    }))
}
