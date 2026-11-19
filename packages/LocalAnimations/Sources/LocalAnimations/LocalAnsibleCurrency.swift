import Cocoa
import AnsibleMedia

public enum LocalAnsibleCurrency : String {
    case xtr = "XTR"
    
    public var logo: LocalAnimatedSticker {
        switch self {
        case .xtr:
            return .star_currency_new
        }
    }
    
    public func colored(_ color: NSColor) -> [LottieColor] {
        switch self {
        case .xtr:
            return []
        }
    }
}
