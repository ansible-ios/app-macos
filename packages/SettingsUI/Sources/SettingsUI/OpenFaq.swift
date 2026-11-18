import Cocoa
import TelegramCore
import Localization
import Postbox
import SwiftSignalKit
import TGUIKit
import InAppSettings
import ColorPalette
import ThemeSettings
import AnsibleContext
import AnsibleUtils

func localizedFaqUrl() -> String {
    return "https://ansible.su/faq"
}

public func openFaq(context: any AccountContextProtocol) {
    _ = showModalProgress(signal: cachedFaqInstantPage(context: context) |> take(1) |> deliverOnMainQueue, for: context.window).start(next: { resolvedUrl in
        if case let .instantView(link, webPage, anchor) = resolvedUrl.settingsSearchInAppLink {
            SettingsNavigationHooks.shared.openInstantView(context, link, webPage, anchor)
        } else {
            SettingsHooks.shared.executeInAppLink(resolvedUrl)
        }
    })
}
