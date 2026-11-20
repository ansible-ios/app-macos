import Cocoa

extension NSTextField {
    open override func accessibilityParent() -> Any? {
        return AnsibleUIKitAccessibility.parent(of: self, default: { super.accessibilityParent() })
    }
}
extension NSSecureTextField {
    open override func accessibilityParent() -> Any? {
        return AnsibleUIKitAccessibility.parent(of: self, default: { super.accessibilityParent() })
    }
}