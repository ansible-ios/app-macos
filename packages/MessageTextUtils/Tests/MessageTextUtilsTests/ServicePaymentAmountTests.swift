import MessageTextUtils
import XCTest

final class ServicePaymentAmountTests: XCTestCase {
    func testDiamondAttachmentIsUsedOnlyForRichText() {
        let rich = servicePaymentAmount(21, currency: "XTR", embedDiamond: true)
        XCTAssertEqual(rich.filter { $0 == "\u{fffc}" }.count, 1)
        XCTAssertTrue(rich.hasSuffix("21"))

        let plain = servicePaymentAmount(21, currency: "XTR", embedDiamond: false)
        XCTAssertTrue(plain.hasPrefix("21 "))
        XCTAssertFalse(plain.contains("\u{fffc}"))
        XCTAssertFalse(plain.contains("XTR"))
    }

    func testOtherCurrenciesKeepTheirUnitInBothPresentations() {
        for embedDiamond in [false, true] {
            XCTAssertEqual(servicePaymentAmount(1_000_000_000, currency: "TON", embedDiamond: embedDiamond), "1 TON")
            XCTAssertEqual(servicePaymentAmount(125, currency: "TEST", embedDiamond: embedDiamond), "125 TEST")
        }
    }
}
