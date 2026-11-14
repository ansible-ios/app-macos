import Foundation

public enum AnsiblePhoneNumber {
    public static let prefix = "777"

    public static func digits(_ value: String) -> String {
        return String(value.filter { $0 >= "0" && $0 <= "9" })
    }

    public static func hasPrefix(_ value: String) -> Bool {
        return digits(value).hasPrefix(prefix)
    }

    public static func isValid(_ value: String) -> Bool {
        let value = digits(value)
        return value.hasPrefix(prefix) && (1...8).contains(value.count - prefix.count)
    }

    public static func formatted(_ value: String) -> String {
        let value = digits(value)
        let number = value.dropFirst(prefix.count)
        return "+" + prefix + (number.isEmpty ? "" : " " + number)
    }
}
