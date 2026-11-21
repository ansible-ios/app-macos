import XCTest
import Security
import LocalAuthentication
@testable import PasscodeCore

final class BiometricMigrationTests: XCTestCase {
    func testExistingItemWinsAndCancellationNeverFallsBack() throws {
        let current = Data([1])
        let unused: () -> Data? = { XCTFail("Unexpected legacy lookup"); return nil }
        let unexpectedRename: () -> OSStatus = { XCTFail("Unexpected rename"); return errSecParam }
        XCTAssertEqual(try PasscodeKeychain.readMigratingBiometric(current: { current }, legacy: unused, rename: unexpectedRename), current)
        XCTAssertThrowsError(try PasscodeKeychain.readMigratingBiometric(current: { throw PasscodeError.cancelled }, legacy: unused, rename: unexpectedRename))
        XCTAssertThrowsError(try PasscodeKeychain.readMigratingBiometric(current: { nil }, legacy: { throw PasscodeError.cancelled }, rename: unexpectedRename))
        XCTAssertThrowsError(try PasscodeKeychain.readMigratingBiometric(current: { nil }, legacy: { current }, rename: { errSecUserCanceled }))
    }

    func testRenameFailureAllowsAuthenticatedUnlockAndRetry() throws {
        let key = Data([7])
        var current: Data?
        var attempts = 0
        for _ in 0..<3 {
            let value = try PasscodeKeychain.readMigratingBiometric(current: { current }, legacy: { key }, rename: {
                attempts += 1
                if attempts == 1 { return errSecInteractionNotAllowed }
                current = key
                return errSecSuccess
            })
            XCTAssertEqual(value, key)
        }
        XCTAssertEqual(attempts, 2)
    }

    func testConcurrentMigrationUsesWinningItem() throws {
        for status in [errSecDuplicateItem, errSecItemNotFound] {
            var current: Data?
            let winner = Data([2])
            let value = try PasscodeKeychain.readMigratingBiometric(current: { current }, legacy: { Data([1]) }, rename: { current = winner; return status })
            XCTAssertEqual(value, winner)
        }
    }

    func testRealKeychainRenameAndCleanupAreScopedToAccountAndChannel() throws {
        let id = UUID().uuidString
        let old = "org.ansible.tests.legacy." + id
        let new = "org.ansible.tests.current." + id
        let account = "biometric." + id
        func store(_ service: String, _ scope: String?, legacy: String? = nil) throws -> PasscodeKeychain {
            let env = PasscodeEnvironment()
            try env.configure(PasscodeConfiguration(appGroupIdentifier: "org.ansible.tests", processRole: .mainApp, biometricKeychainService: service, legacyBiometricKeychainService: legacy, keychainScope: scope), privateAccessGroup: { "org.ansible.tests" })
            return PasscodeKeychain(environment: env)
        }
        let legacy = try store(old, id)
        let unscoped = try store(old, nil)
        let target = try store(new, id, legacy: old)
        let currentOnly = try store(new, id)
        let other = account + ".other"
        defer {
            try? target.remove(account)
            try? legacy.remove(other)
            try? unscoped.remove(account)
        }
        try legacy.write(Data([1]), account: account)
        try legacy.write(Data([2]), account: other)
        try unscoped.write(Data([3]), account: account)
        XCTAssertEqual(try target.read(account, context: LAContext()), Data([1]))
        XCTAssertNil(try legacy.read(account))
        XCTAssertEqual(try currentOnly.read(account), Data([1]))
        try legacy.write(Data([4]), account: account)
        XCTAssertEqual(try target.read(account), Data([1]))
        try target.remove(account)
        XCTAssertNil(try legacy.read(account))
        XCTAssertNil(try currentOnly.read(account))
        XCTAssertEqual(try legacy.read(other), Data([2]))
        XCTAssertEqual(try unscoped.read(account), Data([3]))
    }
}
