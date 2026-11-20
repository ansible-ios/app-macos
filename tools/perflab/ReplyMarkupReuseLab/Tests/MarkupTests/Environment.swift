import Cocoa
import AnsibleUIKit

public struct ReplyMarkupButton {
    public enum Action { case url(String), payment, switchInline, openUserProfile, openWebApp, openWebView, copyText, callback }
    let title: String
    let action: Action
    var style: NSColor? = nil
    var embedded = false
}
public struct ReplyMarkupRow { let buttons: [ReplyMarkupButton] }
public struct ReplyMarkupMessageFlags: OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) { self.rawValue = rawValue }
}
public final class ReplyMarkupInteractions {
    let context: FixtureContext
    var actions: [String] = []
    init(_ context: FixtureContext = FixtureContext()) { self.context = context }
    func proccess(_ button: ReplyMarkupButton, _ completion: (Bool) -> Void) { actions.append(button.title) }
}
struct FixtureColors { var grayForeground = NSColor.gray }
struct FixtureChat {
    func chatActionUrl(theme: AnsiblePresentationTheme) -> CGImage { theme.icon }
    func chatInvoiceAction(theme: AnsiblePresentationTheme) -> CGImage { theme.icon }
    func chatActionShare(theme: AnsiblePresentationTheme) -> CGImage { theme.icon }
    func chatActionProfile(theme: AnsiblePresentationTheme) -> CGImage { theme.icon }
    func chatActionWebUrl(theme: AnsiblePresentationTheme) -> CGImage { theme.icon }
    func chatActionCopy(theme: AnsiblePresentationTheme) -> CGImage { theme.icon }
}
public struct AnsiblePresentationTheme {
    var colors = FixtureColors()
    var chat = FixtureChat()
    var hasWallpaper = false
    var shouldBlurService = false
    var blurServiceColor = NSColor.red.withAlphaComponent(0.2)
    var chatServiceItemColor = NSColor.green
    let icon: CGImage = generateImage(NSSize(width: 9, height: 7), contextGenerator: { size, ctx in
        ctx.clear(size.bounds)
        ctx.setFillColor(NSColor.red.cgColor)
        ctx.fill(CGRect(x: 1, y: 1, width: 4, height: 5))
    })!
}
struct AnsibleUtilsHooks {
    static var shared = AnsibleUtilsHooks()
    var isLite: (LiteFeature) -> Bool = { _ in false }
}
extension String { var isSingleEmoji: Bool { self == "😀" } }
public final class ReplyMarkupButtonLayout {
    public private(set) var width: CGFloat = 0
    public let text: TextViewLayout
    public let button: ReplyMarkupButton
    public let presentation: AnsiblePresentationTheme
    public let styleBackgroundColor: NSColor?
    init(button: ReplyMarkupButton, theme: AnsiblePresentationTheme, isInput: Bool, paid: Bool, xtrAmount: Int64?) {
        self.button = button
        self.presentation = theme
        self.styleBackgroundColor = button.style
        let attr = NSMutableAttributedString(string: button.title, attributes: [.font: NSFont.systemFont(ofSize: 13), .foregroundColor: NSColor.white])
        if button.embedded && attr.length > 0 { attr.addAttribute(TextInputAttributes.embedded, value: "fixture-icon", range: NSRange(location: 0, length: 1)) }
        text = TextViewLayout(attr, maximumNumberOfLines: 1, truncationType: .middle, alignment: .center, alwaysStaticItems: true)
    }
    func measure(_ width: CGFloat) { self.width = width; text.measure(width: width - 8) }
}
