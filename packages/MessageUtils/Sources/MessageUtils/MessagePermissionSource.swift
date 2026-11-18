import Foundation
import Postbox
import AnsibleContext
import ChatModeTypes

public protocol MessagePermissionSource: AnyObject {
    var permissionMode: ChatMode { get }
    var permissionCachedData: CachedPeerData? { get }
    var permissionContext: any AccountContextProtocol { get }
}
