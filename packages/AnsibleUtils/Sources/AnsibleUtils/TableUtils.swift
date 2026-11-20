import Cocoa

import AnsibleUIKit
import TelegramCore
#if SHARE
import AnsibleThemeShare
#else
import AnsibleTheme
#endif


public protocol TableItemListNodeEntry: Comparable, Identifiable {
    associatedtype ItemGenerationArguments
    
    func item(_ arguments: ItemGenerationArguments, initialSize: NSSize) -> TableRowItem
}

public protocol ItemListItemTag {
    func isEqual(to other: ItemListItemTag) -> Bool
}

