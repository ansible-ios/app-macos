import Foundation

public var currencyGroupingSeparator: String {
    return Locale.current.groupingSeparator ?? ","
}

public func groupedCurrencyNumber(_ count: Int64, _ groupingSeparator: String) -> String {
    let sign = count < 0 ? "-" : ""
    let digits = "\(count.magnitude)"
    guard !groupingSeparator.isEmpty, digits.count > 3 else {
        return sign + digits
    }
    var grouped = ""
    for (offset, character) in digits.enumerated() {
        if offset > 0, (digits.count - offset).isMultiple(of: 3) {
            grouped += groupingSeparator
        }
        grouped.append(character)
    }
    return sign + grouped
}
