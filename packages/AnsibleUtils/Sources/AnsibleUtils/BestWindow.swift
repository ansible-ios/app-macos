import Cocoa
import AnsibleUIKit
#if SHARE
import AnsibleContextShare
#else
import AnsibleContext
#endif

public func bestWindow(_ accountContext: any AccountContextProtocol, _ controller: ViewController?) -> Window {
    return controller?.window ?? accountContext.window
}
