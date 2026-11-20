import Cocoa
import TelegramCore
import Localization
import Postbox
import SwiftSignalKit
import AnsibleUIKit
import InAppSettings
import ColorPalette
import ThemeSettings

func isLite(_ key: LiteModeKey = .any) -> Bool {
    return appDelegate?.sharedApplicationContextValue?.sharedContext.isLite(key) ?? false
}
