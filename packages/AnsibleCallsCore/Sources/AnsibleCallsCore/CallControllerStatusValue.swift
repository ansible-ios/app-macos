import Foundation
import Localization
import ColorPalette
import AnsibleContext
import AnsibleUtils
import AVFoundation
import AnsibleMediaUtils
import SystemPermissions
import ProxyUtils

public enum CallControllerStatusValue: Equatable {
    case text(String, Int32?)
    case timer(Double, Int32?)
    case startsIn(Int)
    
    public var hasTimer: Bool {
        switch self {
        case .timer, .startsIn:
            return true
        default:
            return false
        }
    }
}
