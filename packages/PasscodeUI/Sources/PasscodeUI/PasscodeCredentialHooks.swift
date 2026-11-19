import Foundation
import SwiftSignalKit

public enum PasscodeCredentialSyncError: Error, Equatable {
    case invalidCode
    case cooldown(Int)
    case failed
}


public typealias PasscodeCredentialSyncCompletion = (Result<Void, PasscodeCredentialSyncError>) -> Void

public struct PasscodeCredentialHooks {
    public var passcodeInstalled: (String, @escaping PasscodeCredentialSyncCompletion) -> Void = { _, completion in completion(.success(())) }
    public var passcodeChanged: (String, String, @escaping PasscodeCredentialSyncCompletion) -> Void = { _, _, completion in completion(.success(())) }
    public var passcodeDisabled: (String, @escaping PasscodeCredentialSyncCompletion) -> Void = { _, completion in completion(.success(())) }
    public var passcodeUnlocked: (String) -> Void = { _ in }

    public init() {
    }

    public private(set) static var shared = PasscodeCredentialHooks()

    public static func install(_ hooks: PasscodeCredentialHooks) {
        shared = hooks
    }
}
