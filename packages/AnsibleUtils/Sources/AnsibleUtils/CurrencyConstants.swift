import Foundation

public let XTR: String = "XTR"
// Older language packs sometimes use a literal star in place of the currency icon.
public func replacingLegacyCurrencyStar(in text: String, with replacement: String) -> String {
    return text.replacingOccurrences(of: "⭐️", with: replacement)
        .replacingOccurrences(of: "⭐", with: replacement)
}

public let XTR_ICON = "Icon_Menu_Star"
public let TINY_SPACE = "\u{2009}\u{2009}"

public func unsupportedPaymentCurrency(_ currency: String) -> Bool {
    return ["TON", "GRAM"].contains(currency.uppercased())
}
