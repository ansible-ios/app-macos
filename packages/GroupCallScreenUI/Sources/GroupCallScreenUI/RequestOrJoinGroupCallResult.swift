import Foundation
import Postbox
import TelegramCore
import TgVoipWebrtc
import SwiftSignalKit
import AnsibleCallsCore

public enum RequestOrJoinGroupCallResult {
    case success(GroupCallContext)
    case fail
    case samePeer(GroupCallContext)
}
