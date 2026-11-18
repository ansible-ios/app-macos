import Cocoa
import TGUIKit
import AnsibleTheme
import SettingsUI

func installLiteModeUIHooks() {
    LiteModeHooks.install(LiteModeHooks(
        updateTheme: { theme, animated in
        ansibleUpdateTheme(theme, animated: animated) }
    ))
}
