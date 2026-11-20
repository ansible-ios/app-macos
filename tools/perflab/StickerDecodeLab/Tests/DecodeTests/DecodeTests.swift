@testable import class AnsibleUIKit.PathDataReader
@testable import class AnsibleUIKitBaseline.PathDataReader
@testable import func AnsibleUIKit.renderPath
@testable import func AnsibleUIKitBaseline.renderPath
@testable import func AnsibleUIKit.decodeCommandStorageForLab
@testable import func AnsibleUIKitBaseline.decodeCommandStorageForLab
import Cocoa
@testable import func AnsibleUIKit.decodeStickerThumbnailData
@testable import func AnsibleUIKit.decodeFallbackForLab
@testable import func AnsibleUIKit.decodeLengthForLab
@testable import func AnsibleUIKitBaseline.decodeStickerThumbnailData
import Foundation
import XCTest

struct DecodeRandom {
    var state: UInt64 = 0xabcdef
    mutating func next(_ limit: Int) -> Int {
        state = state &* 6364136223846793005 &+ 1442695040888963407
        return Int((state >> 32) % UInt64(limit))
    }
}

final class DecodeTests: XCTestCase {
    func testEveryByteAndPair() {
        XCTAssertEqual(AnsibleUIKit.decodeStickerThumbnailData(Data()), "Mz")
        for first in UInt8.min...UInt8.max {
            let data = Data([first])
            XCTAssertEqual(AnsibleUIKitBaseline.decodeStickerThumbnailData(data), AnsibleUIKit.decodeStickerThumbnailData(data))
            XCTAssertEqual(AnsibleUIKitBaseline.decodeStickerThumbnailData(data), AnsibleUIKit.decodeFallbackForLab(data))
            XCTAssertEqual(AnsibleUIKitBaseline.decodeStickerThumbnailData(data).utf8.count, AnsibleUIKit.decodeLengthForLab(data))
            for second in UInt8.min...UInt8.max {
                let data = Data([first, second])
                XCTAssertEqual(AnsibleUIKitBaseline.decodeStickerThumbnailData(data), AnsibleUIKit.decodeStickerThumbnailData(data))
                XCTAssertEqual(AnsibleUIKitBaseline.decodeStickerThumbnailData(data), AnsibleUIKit.decodeFallbackForLab(data))
                XCTAssertEqual(AnsibleUIKitBaseline.decodeStickerThumbnailData(data).utf8.count, AnsibleUIKit.decodeLengthForLab(data))
            }
        }
    }
    func testRandomPayloadsAndSlicedData() {
        var random = DecodeRandom()
        for iteration in 0..<5000 {
            let source = Data((0..<(1 + random.next(1024))).map { _ in UInt8(random.next(256)) })
            let lower = random.next(source.count), upper = lower + random.next(source.count - lower + 1)
            let data = iteration % 2 == 0 ? source : source[lower..<upper]
            XCTAssertEqual(AnsibleUIKitBaseline.decodeStickerThumbnailData(data), AnsibleUIKit.decodeStickerThumbnailData(data))
            XCTAssertEqual(AnsibleUIKitBaseline.decodeStickerThumbnailData(data), AnsibleUIKit.decodeFallbackForLab(data))
            XCTAssertEqual(AnsibleUIKitBaseline.decodeStickerThumbnailData(data).utf8.count, AnsibleUIKit.decodeLengthForLab(data))
        }
    }
    func testBridgedDataAndAllByteOrderings() {
        for count in [0, 1, 15, 16, 31, 32, 255, 256, 1024, 65536] {
            for mode in 0..<3 {
                let bytes = (0..<count).map { UInt8(mode == 0 ? $0 % 256 : mode == 1 ? 255 - $0 % 256 : 170) }
                let data = bytes.withUnsafeBytes { Data(referencing: NSData(bytes: $0.baseAddress, length: $0.count)) }
                XCTAssertEqual(AnsibleUIKitBaseline.decodeStickerThumbnailData(data), AnsibleUIKit.decodeStickerThumbnailData(data))
                XCTAssertEqual(AnsibleUIKitBaseline.decodeStickerThumbnailData(data), AnsibleUIKit.decodeFallbackForLab(data))
                XCTAssertEqual(AnsibleUIKitBaseline.decodeStickerThumbnailData(data).utf8.count, AnsibleUIKit.decodeLengthForLab(data))
            }
        }
    }
}

private final class DecodeFailures {
    private let lock = NSLock()
    private var count = 0
    func add() { lock.lock(); count += 1; lock.unlock() }
    var value: Int { lock.lock(); defer { lock.unlock() }; return count }
}

extension DecodeTests {
    func testConcurrentNativeAndFallbackDecoding() {
        let inputs = (0..<64).map { length in Data((0..<(length * 19)).map { UInt8(($0 * 17) % 256) }) }
        let expected = inputs.map { AnsibleUIKitBaseline.decodeStickerThumbnailData($0) }
        let failures = DecodeFailures()
        DispatchQueue.concurrentPerform(iterations: 1024) { index in
            let selected = index % inputs.count
            if AnsibleUIKit.decodeStickerThumbnailData(inputs[selected]) != expected[selected] { failures.add() }
            if AnsibleUIKit.decodeFallbackForLab(inputs[selected]) != expected[selected] { failures.add() }
            if AnsibleUIKit.decodeLengthForLab(inputs[selected]) != expected[selected].utf8.count { failures.add() }
        }
        XCTAssertEqual(failures.value, 0)
    }

    func testReturnedStringsOwnTheirStorageAndCommandTableIsCompact() {
        var expected = ""
        let result: (String, String) = autoreleasepool {
            var data = Data((0..<4096).map { UInt8(($0 * 17) % 256) })
            expected = AnsibleUIKitBaseline.decodeStickerThumbnailData(data)
            let result = (AnsibleUIKit.decodeStickerThumbnailData(data), AnsibleUIKit.decodeFallbackForLab(data))
            data.resetBytes(in: 0..<data.count)
            return result
        }
        XCTAssertEqual(result.0, expected); XCTAssertEqual(result.1, expected)
        XCTAssertEqual(AnsibleUIKitBaseline.decodeCommandStorageForLab(), 1024)
        XCTAssertEqual(AnsibleUIKit.decodeCommandStorageForLab(), 64)
    }

    func testForcedFallbackRendersIdenticalPixels() {
        let inputs = placeholderPaths.map { encodedPath($0) } + compactDecodePaths().map { $0.1 }
        var count = 0
        for input in inputs {
            let reference = AnsibleUIKitBaseline.PathDataReader(input: AnsibleUIKitBaseline.decodeStickerThumbnailData(input)).read()
            let fallback = AnsibleUIKit.PathDataReader(input: AnsibleUIKit.decodeFallbackForLab(input)).read()
            for scale in [1, 2, 3] {
                for variant in 0..<3 {
                    XCTAssertTrue(pathPixels(scale: scale, variant: variant) { AnsibleUIKitBaseline.renderPath(reference, context: $0) } == pathPixels(scale: scale, variant: variant) { AnsibleUIKit.renderPath(fallback, context: $0) })
                    count += 1
                }
            }
        }
        XCTAssertEqual(count, 99)
    }
}
