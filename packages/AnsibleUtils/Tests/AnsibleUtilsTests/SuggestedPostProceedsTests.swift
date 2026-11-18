import TelegramCore
import AnsibleUtils
import XCTest

final class SuggestedPostProceedsTests: XCTestCase {
    private func proceeds(_ units: Int64, currency: CurrencyAmount.Currency, rate: Int32) -> Int64 {
        let offer = CurrencyAmount(amount: StarsAmount(value: units, nanos: 0), currency: currency)
        return offer.recipientProceeds(permille: rate).amount.value
    }

    func testDiamondRecipientShareRoundsUpToWholeDiamonds() {
        XCTAssertEqual(proceeds(100, currency: .stars, rate: 850), 85)
        XCTAssertEqual(proceeds(101, currency: .stars, rate: 850), 86)
        XCTAssertEqual(proceeds(1, currency: .stars, rate: 850), 1)
        XCTAssertEqual(proceeds(0, currency: .stars, rate: 850), 0)
        XCTAssertEqual(proceeds(.max, currency: .stars, rate: 1000), .max)
    }

    func testTonShareUsesBaseUnits() {
        XCTAssertEqual(proceeds(1_500_000_001, currency: .ton, rate: 850), 1_275_000_000)
    }
}
