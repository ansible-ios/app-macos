import Cocoa
import SwiftSignalKit
import PasscodeUI
import PasscodeCore
import BuildConfig
import ApiCredentials
import LocalAuthentication

func passcodeCredentialKind(for code: String) -> PasscodeKind {
    let normalized = PasscodeKind.digits4.normalize(code)
    if normalized.allSatisfy({ $0.isASCII && $0.isNumber }) {
        if normalized.count == 4 {
            return .digits4
        }
        if normalized.count == 6 {
            return .digits6
        }
    }
    return .alphanumeric
}

private func passcodeRootPath() -> String? {
    return ApiEnvironment.containerURL?.path
}

@available(macOS 10.15, *)
func syncPasscodeCredential(code: String, rootPath: String) {
    let encryption = AppEncryptionParameters(path: rootPath)
    guard encryption.hasPasscode() else {
        return
    }
    encryption.applyPasscode(code)
    guard encryption.decrypt() != nil else {
        return
    }
    try? adoptPasscodeCredential(code: code)
}

@available(macOS 10.15, *)
func adoptPasscodeCredential(code: String, isNewPasscode: Bool = false) throws {
    let store = PasscodeCredentialStore.shared
    switch try store.managedReference() {
    case .none where !isNewPasscode:
        _ = try store.migrateLegacy(code: code, kind: passcodeCredentialKind(for: code))
    case .none, .some(.none):
        _ = try store.setPasscode(code, kind: passcodeCredentialKind(for: code), session: nil)
    case .some(.some):
        break
    }
    UserDefaults.standard.set(true, forKey: walletPasscodeCredentialManagedKey)
}

@available(macOS 10.15, *)
private func passcodeSettingsSession(code: String) throws -> PasscodeSession {
    if let rootPath = passcodeRootPath() {
        syncPasscodeCredential(code: code, rootPath: rootPath)
    }
    return try PasscodeCredentialStore.shared.verify(code, scope: .settings)
}

private func passcodeCredentialOperation(_ completion: @escaping PasscodeCredentialSyncCompletion, _ operation: @escaping () throws -> Void) {
    Queue.concurrentDefaultQueue().async {
        let result: Result<Void, PasscodeCredentialSyncError>
        do {
            try operation()
            result = .success(())
        } catch PasscodeError.invalidCode {
            result = .failure(.invalidCode)
        } catch let PasscodeError.cooldown(seconds) {
            result = .failure(.cooldown(seconds))
        } catch {
            result = .failure(.failed)
        }
        Queue.mainQueue().async {
            completion(result)
        }
    }
}

func installPasscodeUIHooks() {
    var hooks = PasscodeCredentialHooks()
    hooks.passcodeInstalled = { code, completion in
        guard #available(macOS 10.15, *) else {
            completion(.success(()))
            return
        }
        passcodeCredentialOperation(completion) {
            try adoptPasscodeCredential(code: code, isNewPasscode: true)
        }
    }
    hooks.passcodeChanged = { current, code, completion in
        guard #available(macOS 10.15, *) else {
            completion(.success(()))
            return
        }
        passcodeCredentialOperation(completion) {
            let session = try passcodeSettingsSession(code: current)
            defer {
                session.invalidate()
            }
            _ = try PasscodeCredentialStore.shared.setPasscode(code, kind: passcodeCredentialKind(for: code), session: session)
        }
    }
    hooks.passcodeDisabled = { current, completion in
        guard #available(macOS 10.15, *) else {
            completion(.success(()))
            return
        }
        passcodeCredentialOperation(completion) {
            let session = try passcodeSettingsSession(code: current)
            try PasscodeCredentialStore.shared.disablePasscode(session: session)
        }
    }
    hooks.passcodeUnlocked = { code in
        guard #available(macOS 10.15, *), let rootPath = passcodeRootPath() else {
            return
        }
        Queue.concurrentDefaultQueue().async {
            syncPasscodeCredential(code: code, rootPath: rootPath)
        }
    }
    PasscodeCredentialHooks.install(hooks)
}
