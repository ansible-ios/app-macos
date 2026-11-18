import Cocoa
import TGUIKit
import AnsibleMedia
import AnsibleTheme
import LocalAnimations
import Localization
import AnsibleUtils

extension PanelSearchStatusView {
    func updateSearchStatus(_ status: PanelSearchPresentation, kind: PanelSearchPlaceholderKind, query: String, theme: AnsiblePresentationTheme, clearBackground: Bool = false) {
        let reduceMotion = NSWorkspace.shared.accessibilityDisplayShouldReduceMotion
        update(status: status, kind: kind, title: strings().requestJoinListSearchEmptyHeader, detail: query.isEmpty ? "" : strings().requestJoinListSearchEmpty(String(query.prefix(80))), loadingLabel: strings().voiceOverCommonLoading, backgroundColor: clearBackground ? .clear : theme.colors.background, frosted: clearBackground && System.liquidGlass && System.liquidGlassAvailable && !AnsibleUtilsHooks.shared.isLite(.blur), isDark: theme.colors.isDark, textColor: theme.colors.text, detailColor: theme.colors.grayText, reduceMotion: reduceMotion, makeAnimation: {
            guard let data = LocalAnimatedSticker.duck_empty.data else { return nil }
            let view = LottiePlayerView(frame: NSMakeRect(0, 0, 120, 120))
            view.set(LottieAnimation(compressed: data, key: .init(key: .bundle(LocalAnimatedSticker.duck_empty.rawValue), size: view.frame.size), cachePurpose: .none, playPolicy: reduceMotion ? .framesCount(1) : .onceEnd, maximumFps: 30))
            return view
        })
    }
}
