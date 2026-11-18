import Foundation

private let currencyNoun = #"(?:diamonds?|stars?|зв[её]зд(?:ами|ам|ах|ой|ою|а|ы|у|е)?|зір(?:ок|к[а-яіїє]*)|stern(?:e|en)?|estrellas?|stell[ae]|sterren|estrelas?)"#
private let productName = #"(?:Telegram|Ansible|Телеграм(?:е|а|ом|у)?)"#
private let legacyBrandTokens = try! NSRegularExpression(
    pattern: #"(?i)\]\(stars\)|(?:https?://|(?<![\w./@])(?=(?:t\.me|telegram\.me|(?:www\.)?fragment\.com)/))[^\s)\]<>"]+|(?<![\w@./])(?:\#(productName) \#(currencyNoun)|\#(currencyNoun)(?: (?:(?:de|di|do|van|von) )?\#(productName))?|Telegram|Телеграм(?:е|а|ом|у)?|Fragment)(?!\w|\.\w|/)"#
)
private let marketplaceOrMessenger = #"^(?:https?://)?(?:t\.me|telegram\.me|(?:www\.)?fragment\.com)(?=/|[?#]|$)"#

func brandedLanguageValue(_ value: String, key: String) -> String {
    let matches = legacyBrandTokens.matches(in: value, range: NSRange(value.startIndex..., in: value))
    guard !matches.isEmpty else { return value }
    let result = NSMutableString(string: value)
    for match in matches.reversed() {
        let token = result.substring(with: match.range)
        let replacement: String
        switch token.lowercased() {
        case "](stars)":
            replacement = "](diamonds)"
        case "ansible diamonds", "ansible diamond":
            continue
        case "telegram", "телеграм", "телеграме", "телеграма", "телеграмом", "телеграму":
            replacement = "Ansible"
        case "fragment":
            guard token == "Fragment" || key.contains("Fragment") else { continue }
            replacement = "Crystal Piece"
        case "https://telegram.org/blog/coronavirus":
            replacement = "https://www.who.int/health-topics/coronavirus"
        default:
            if token.contains("://") || token.contains("/") {
                guard let authority = token.range(of: marketplaceOrMessenger, options: [.regularExpression, .caseInsensitive]) else { continue }
                let host = token[authority].lowercased().hasSuffix("fragment.com") ? "crystalpiece.su" : "asme.su"
                replacement = "https://" + host + String(token[authority.upperBound...])
            } else {
                guard !key.contains("RatingStars"), !key.contains("ShapeStar") else { continue }
                guard token.contains(" ") || key.localizedCaseInsensitiveContains("star") || NativeLocalization(key).localizedCaseInsensitiveContains("diamond") else { continue }
                replacement = ["diamond", "star"].contains(token.lowercased()) ? "Ansible Diamond" : "Ansible Diamonds"
            }
        }
        result.replaceCharacters(in: match.range, with: replacement)
    }
    return result as String
}
