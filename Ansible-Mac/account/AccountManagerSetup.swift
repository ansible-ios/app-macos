import Foundation
import TelegramCore
import PasscodeCore
import BuildConfig

let unscopedPasscodeCredentialManagedKey = "wallet.passcodeCredentialManaged"

var passcodeCredentialManagedKey: String {
    if let scope = PasscodeEnvironment.shared.keychainScope {
        return unscopedPasscodeCredentialManagedKey + "." + scope
    }
    return unscopedPasscodeCredentialManagedKey
}



func makeAccountManagerAccessChallenge(basePath: String, isTemporary: Bool, isReadOnly: Bool) -> AccountManagerAccessChallenge {
    let isMainProcess = PasscodeEnvironment.shared.isMainApp
    return AccountManagerAccessChallenge(prepare: { isFreshInstallation in
        guard #available(macOS 10.15, *) else {
            return
        }
        _ = try PasscodeEnvironment.shared.sharedAccessGroup()
        PasscodeCredentialStore.shared.configureLock(directory: basePath)
        #if !SHARE
        if isMainProcess, UserDefaults.standard.bool(forKey: passcodeCredentialManagedKey) {
            if try PasscodeCredentialStore.shared.hasStoredCredential() {
                PasscodeCredentialStore.shared.requireExistingCredential()
            }
        }
        #endif
    }, resolve: { current, _ in
        guard current == nil else {
            return nil
        }
        let encryption = AppEncryptionParameters(path: (basePath as NSString).deletingLastPathComponent)
        let challenge: PostboxAccessChallengeData = encryption.hasPasscode() ? .plaintextPassword(value: "") : .none
        return challenge
    }, finishInitialization: {
        guard #available(macOS 10.15, *), isMainProcess else {
            return
        }
        try PasscodeCredentialStore.shared.resumeCleanup()
    })
}
