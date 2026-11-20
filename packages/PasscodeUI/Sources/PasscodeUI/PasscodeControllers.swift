import Cocoa
import Foundation
import AnsibleUIKit
import TelegramCore
import Postbox
import SwiftSignalKit
import Localization
import ColorPalette
import InAppSettings
import AnsibleTheme
import AnsibleContext
import AnsibleUtils
import AlertsUI
import SystemPermissions
import BuildConfig
import LocalAuthentication
import InputDataUI
import GeneralRows
import AppAnalytics


public enum PasscodeMode : Equatable {
    case install
    case change
    case disable
}

private struct PasscodeState : Equatable {
    public let mode: PasscodeMode
    public let data: [InputDataIdentifier : InputDataValue]
    public let errors: [InputDataIdentifier : InputDataValueError]
    public init(mode: PasscodeMode, data: [InputDataIdentifier : InputDataValue], errors: [InputDataIdentifier : InputDataValueError]) {
        self.mode = mode
        self.data = data
        self.errors = errors
    }
    
    public func withUpdatedError(_ error: InputDataValueError?, for key: InputDataIdentifier) -> PasscodeState {
        var errors = self.errors
        if let error = error {
            errors[key] = error
        } else {
            errors.removeValue(forKey: key)
        }
        return PasscodeState(mode: self.mode, data: self.data, errors: errors)
    }
    
    public func withUpdatedValue(_ value: InputDataValue, for key: InputDataIdentifier) -> PasscodeState {
        var data = self.data
        data[key] = value
        return PasscodeState(mode: self.mode, data: data, errors: self.errors)
    }

}

private let _id_input_new_passcode = InputDataIdentifier("_id_input_new_passcode")
private let _id_input_re_new_passcode = InputDataIdentifier("_id_input_re_new_passcode")

private let _id_input_current = InputDataIdentifier("_id_input_current")

private let passcodeSyncFailedText = strings().passcodeControllerSyncFailed

private func passcodeCooldownText(_ seconds: Int) -> String {
    return strings().passcodeControllerCooldownOther(seconds)
}

private func passcodeEntries(_ state: PasscodeState) -> [InputDataEntry] {
    var entries: [InputDataEntry] = []
    
    var sectionId: Int32 = 0
    var index: Int32 = 0
    
    entries.append(.sectionId(sectionId, type: .normal))
    sectionId += 1
    
    switch state.mode {
    case .install:

        entries.append(.desc(sectionId: sectionId, index: index, text: .plain(strings().passcodeControllerHeaderNew), data: InputDataGeneralTextData(viewType: .textTopItem)))
        index += 1
        
        
        entries.append(InputDataEntry.input(sectionId: sectionId, index: index, value: .string(state.data[_id_input_new_passcode]?.stringValue), error: state.errors[_id_input_new_passcode], identifier: _id_input_new_passcode, mode: .secure, data: InputDataRowData(viewType: .firstItem), placeholder: nil, inputPlaceholder: strings().passcodeControllerEnterPasscodePlaceholder, filter: { $0 }, limit: 255))
        index += 1
        
        entries.append(InputDataEntry.input(sectionId: sectionId, index: index, value: .string(state.data[_id_input_re_new_passcode]?.stringValue), error: state.errors[_id_input_re_new_passcode], identifier: _id_input_re_new_passcode, mode: .secure, data: InputDataRowData(viewType: .lastItem), placeholder: nil, inputPlaceholder: strings().passcodeControllerReEnterPasscodePlaceholder, filter: { $0 }, limit: 255))
        index += 1
        
        
    case .change:
        
        entries.append(.desc(sectionId: sectionId, index: index, text: .plain(strings().passcodeControllerHeaderCurrent), data: InputDataGeneralTextData(viewType: .textTopItem)))
        index += 1
        
        entries.append(InputDataEntry.input(sectionId: sectionId, index: index, value: .string(state.data[_id_input_current]?.stringValue), error: state.errors[_id_input_current], identifier: _id_input_current, mode: .secure, data: InputDataRowData(viewType: .singleItem), placeholder: nil, inputPlaceholder: strings().passcodeControllerCurrentPlaceholder, filter: { $0 }, limit: 255))
        index += 1
        
        entries.append(.sectionId(sectionId, type: .normal))
        sectionId += 1

        
        entries.append(.desc(sectionId: sectionId, index: index, text: .plain(strings().passcodeControllerHeaderNew), data: InputDataGeneralTextData(viewType: .textTopItem)))
        index += 1
        
        entries.append(InputDataEntry.input(sectionId: sectionId, index: index, value: .string(state.data[_id_input_new_passcode]?.stringValue), error: state.errors[_id_input_new_passcode], identifier: _id_input_new_passcode, mode: .secure, data: InputDataRowData(viewType: .firstItem), placeholder: nil, inputPlaceholder: strings().passcodeControllerEnterPasscodePlaceholder, filter: { $0 }, limit: 255))
        index += 1
        
        entries.append(InputDataEntry.input(sectionId: sectionId, index: index, value: .string(state.data[_id_input_re_new_passcode]?.stringValue), error: state.errors[_id_input_re_new_passcode], identifier: _id_input_re_new_passcode, mode: .secure, data: InputDataRowData(viewType: .lastItem), placeholder: nil, inputPlaceholder: strings().passcodeControllerReEnterPasscodePlaceholder, filter: { $0 }, limit: 255))
        index += 1
        
        
        
    case .disable:
        entries.append(.desc(sectionId: sectionId, index: index, text: .plain(strings().passcodeControllerHeaderCurrent), data: InputDataGeneralTextData(viewType: .textTopItem)))
        index += 1
        
        entries.append(InputDataEntry.input(sectionId: sectionId, index: index, value: .string(state.data[_id_input_current]?.stringValue), error: state.errors[_id_input_current], identifier: _id_input_current, mode: .secure, data: InputDataRowData(viewType: .singleItem), placeholder: nil, inputPlaceholder: strings().passcodeControllerCurrentPlaceholder, filter: { $0 }, limit: 255))
        index += 1
    }
    
        entries.append(.desc(sectionId: sectionId, index: index, text: .plain(strings().passcodeControllerText), data: InputDataGeneralTextData(detectBold: false, viewType: .textBottomItem)))
    index += 1
    
    entries.append(.sectionId(sectionId, type: .normal))
    sectionId += 1
    
    return entries
}

private func passcodeCredentialSyncCompletion(_ completion: @escaping PasscodeCredentialSyncCompletion) -> PasscodeCredentialSyncCompletion {
    return { result in
        Queue.mainQueue().async {
            completion(result)
        }
    }
}

public func PasscodeController(sharedContext: (any SharedAccountContextProtocol), mode: PasscodeMode) -> ViewController {
    
    
    let initialState = PasscodeState(mode: mode, data: [:], errors: [:])
    
    let statePromise = ValuePromise(initialState, ignoreRepeated: false)
    let stateValue = Atomic(value: initialState)
    let updateState: ((PasscodeState) -> PasscodeState) -> Void = { f in
        statePromise.set(stateValue.modify (f))
    }
    
    let dataSignal = statePromise.get() |> map {
        return passcodeEntries($0)
    }
    
    let title: String
    switch mode {
    case .install:
        title = strings().passcodeControllerInstallTitle
    case .change:
        title = strings().passcodeControllerChangeTitle
    case .disable:
        title = strings().passcodeControllerDisableTitle
    }
    
    var shouldMakeNextResponderAfterTransition: InputDataIdentifier? = nil

    let actionsDisposable = DisposableSet()

    weak var weakController: InputDataController?

    let alertSyncFailure: (String) -> Void = { text in
        if let window = weakController?.window {
            alert(for: window, info: text)
        }
    }

    let rootPath = sharedContext.accountManager.basePath.nsstring.deletingLastPathComponent
    let verifyCurrent: (String) -> Bool = { current in
        let appEncryption = AppEncryptionParameters(path: rootPath)
        appEncryption.applyPasscode(current)
        return appEncryption.decrypt() != nil
    }

    let commitPasscode: (PostboxAccessChallengeData, @escaping () -> Void, Result<Void, PasscodeCredentialSyncError>, @escaping (InputDataValidation) -> Void) -> Void = { challenge, applyEncryption, result, f in
        applyEncryption()
        actionsDisposable.add((sharedContext.accountManager.transaction { transaction in
            transaction.setAccessChallengeData(challenge)
        } |> deliverOnMainQueue).start(completed: {
            switch mode {
            case .install:
                Analytics.shared.send(AnalyticsEvents.settingsChange(.privacyPasscode(.enabled)))
            case .disable:
                Analytics.shared.send(AnalyticsEvents.settingsChange(.privacyPasscode(.disabled)))
            default:
                break
            }
            f(.success(.navigationBackWithPushAnimation))
            if case .failure = result {
                alertSyncFailure(passcodeSyncFailedText)
            }
        }))
    }

    
    let controller = InputDataController(dataSignal: dataSignal |> map { InputDataSignalValue(entries: $0) }, title: title, validateData: { data in
        
        
        return .fail(.doSomething { f in
            let state = stateValue.with { $0 }
            
            switch state.mode {
            case .install:
                let passcode = state.data[_id_input_new_passcode]?.stringValue ?? ""
                let confirm = state.data[_id_input_re_new_passcode]?.stringValue ?? ""
                
                var fields:[InputDataIdentifier : InputDataValidationFailAction] = [:]
                
                if !passcode.isEmpty, !confirm.isEmpty, passcode != confirm {
                    fields[_id_input_new_passcode] = .shake
                    fields[_id_input_re_new_passcode] = .shake
                    
                    updateState {
                        $0.withUpdatedError(InputDataValueError(description: strings().passcodeControllerErrorDifferent, target: .data), for: _id_input_re_new_passcode)
                    }
                }
                if passcode.isEmpty {
                    fields[_id_input_new_passcode] = .shake
                    shouldMakeNextResponderAfterTransition = _id_input_new_passcode
                }
                if confirm.isEmpty {
                    fields[_id_input_re_new_passcode] = .shake
                    if shouldMakeNextResponderAfterTransition == nil {
                        shouldMakeNextResponderAfterTransition = _id_input_re_new_passcode
                    }
                }
                if !fields.isEmpty {
                    f(.fail(.fields(fields)))
                } else {
                    PasscodeCredentialHooks.shared.passcodeInstalled(passcode, passcodeCredentialSyncCompletion({ result in
                        commitPasscode(.plaintextPassword(value: ""), {
                            sharedContext.appEncryptionValue.change(passcode)
                        }, result, f)
                    }))
                }
                
            case .change:
                let current = state.data[_id_input_current]?.stringValue ?? ""
                
                let passcode = state.data[_id_input_new_passcode]?.stringValue ?? ""
                let confirm = state.data[_id_input_re_new_passcode]?.stringValue ?? ""
                
                var fields:[InputDataIdentifier : InputDataValidationFailAction] = [:]
                
                if !verifyCurrent(current) {
                    fields[_id_input_current] = .shake
                    if shouldMakeNextResponderAfterTransition == nil {
                        shouldMakeNextResponderAfterTransition = _id_input_current
                    }
                    updateState {
                        $0.withUpdatedError(InputDataValueError(description: strings().passcodeControllerErrorCurrent, target: .data), for: _id_input_current)
                    }
                    f(.fail(.fields(fields)))
                    return
                }
                
                if !passcode.isEmpty, !confirm.isEmpty, passcode != confirm {
                    fields[_id_input_new_passcode] = .shake
                    fields[_id_input_re_new_passcode] = .shake
                    
                    updateState {
                        $0.withUpdatedError(InputDataValueError(description: strings().passcodeControllerErrorDifferent, target: .data), for: _id_input_re_new_passcode)
                    }
                }
                if passcode.isEmpty {
                    fields[_id_input_new_passcode] = .shake
                    if shouldMakeNextResponderAfterTransition == nil {
                        shouldMakeNextResponderAfterTransition = _id_input_new_passcode
                    }
                }
                if confirm.isEmpty {
                    fields[_id_input_re_new_passcode] = .shake
                    if shouldMakeNextResponderAfterTransition == nil {
                        shouldMakeNextResponderAfterTransition = _id_input_re_new_passcode
                    }
                }
                if !fields.isEmpty {
                    f(.fail(.fields(fields)))
                } else {
                    PasscodeCredentialHooks.shared.passcodeChanged(current, passcode, passcodeCredentialSyncCompletion({ result in
                        if case let .failure(.cooldown(seconds)) = result {
                            updateState {
                                $0.withUpdatedError(InputDataValueError(description: passcodeCooldownText(seconds), target: .data), for: _id_input_current)
                            }
                            f(.fail(.fields([_id_input_current : .shake])))
                            return
                        }
                        commitPasscode(.plaintextPassword(value: ""), {
                            sharedContext.appEncryptionValue.change(passcode)
                        }, result, f)
                    }))
                }
            case .disable:
                let current = state.data[_id_input_current]?.stringValue ?? ""
                
                if !verifyCurrent(current) {
                    updateState {
                        $0.withUpdatedError(InputDataValueError(description: strings().passcodeControllerErrorCurrent, target: .data), for: _id_input_current)
                    }
                    f(.fail(.fields([_id_input_current : .shake])))
                    
                } else {
                    PasscodeCredentialHooks.shared.passcodeDisabled(current, passcodeCredentialSyncCompletion({ result in
                        if case let .failure(.cooldown(seconds)) = result {
                            updateState {
                                $0.withUpdatedError(InputDataValueError(description: passcodeCooldownText(seconds), target: .data), for: _id_input_current)
                            }
                            f(.fail(.fields([_id_input_current : .shake])))
                            return
                        }
                        commitPasscode(.none, {
                            sharedContext.appEncryptionValue.remove()
                        }, result, f)
                    }))
                }
            }
            
            updateState {
                $0
            }
        })
    }, updateDatas: { data in
        updateState { state in
            var state = state
            if let value = data[_id_input_new_passcode] {
                state = state.withUpdatedValue(value, for: _id_input_new_passcode).withUpdatedError(nil, for: _id_input_new_passcode)
            }
            if let value = data[_id_input_re_new_passcode] {
                state = state.withUpdatedValue(value, for: _id_input_re_new_passcode).withUpdatedError(nil, for: _id_input_re_new_passcode)
            }
            if let value = data[_id_input_current] {
                state = state.withUpdatedValue(value, for: _id_input_current).withUpdatedError(nil, for: _id_input_current)
            }
            return state
        }
       
        
        return .none
    }, afterDisappear: {
        actionsDisposable.dispose()
    }, afterTransaction: { controller in
        if let identifier = shouldMakeNextResponderAfterTransition {
            controller.makeFirstResponderIfPossible(for: identifier)
        }
        shouldMakeNextResponderAfterTransition = nil
    })

    weakController = controller

    controller.analyticsScreen = .settingsPrivacyPasscodeSetup

    return controller
    
}
