import Cocoa
import AnsibleUIKit

public enum EditControllerSettings {
    case disableSizes(dimensions: SelectionRectDimensions, circle: Bool)
    case plain
}
