import Cocoa
import TelegramCore
import AnsibleContext

public func formatPhoneNumber(context: any AccountContextProtocol, number: String) -> String {
    if let pattern = lookupPatternByNumber(number, configuration: PhoneNumberUtilsHooks.shared.currentCountriesConfiguration(context).with { $0 }) {
        return "+\(formatPhoneNumberToMask(number, mask: pattern))"
    } else {
        return formatPhoneNumber(number)
    }
}
