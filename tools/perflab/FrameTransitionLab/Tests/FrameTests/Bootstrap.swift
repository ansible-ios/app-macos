import Cocoa
import struct AnsibleUIKit.System
import struct AnsibleUIKitBaseline.System

enum FrameBootstrap {
    private static var retained: [NSImage] = []
    private static let installed: Void = {
        _ = NSApplication.shared
        NSApp.setActivationPolicy(.accessory)
        AnsibleUIKit.System.updateScaleFactor(2)
        AnsibleUIKitBaseline.System.updateScaleFactor(2)
        AnsibleUIKit.System.liquidGlass = false
        AnsibleUIKitBaseline.System.liquidGlass = false
        for name in ["Icon_SearchField", "Icon_SearchClear", "Icon_Quote", "Icon_Quote_Collapse", "Icon_Quote_Expand", "Icon_CopyCode"] {
            let image = NSImage(size: NSSize(width: 16, height: 16), flipped: false) { rect in
                NSColor.black.setFill()
                rect.insetBy(dx: 4, dy: 4).fill()
                return true
            }
            _ = image.setName(name)
            retained.append(image)
        }
    }()
    static func install() { _ = installed }
}
