import Cocoa
import AnsibleUIKit
import AnsibleContext
import AudioPlayerCore
import Localization
import AnsibleUtils
import AnsibleMediaUtils
import AnsibleTheme
import TelegramCore
import SwiftSignalKit
import RangeSet


public final class InstantPageAnchorItem: InstantPageItem {
    public var frame: CGRect

    public let medias: [InstantPageMedia] = []
    public let wantsView: Bool = false
    public let hasLinks: Bool = false
    public let isInteractive: Bool = false
    public let separatesTiles: Bool = false

    public let anchor: String
    
    public init(frame: CGRect, anchor: String) {
        self.anchor = anchor
        self.frame = frame
    }
    
    public func drawInTile(context: CGContext) {
        
    }
    
    public func matchesAnchor(_ anchor: String) -> Bool {
        return self.anchor == anchor
    }
    
    public func matchesView(_ node: InstantPageView) -> Bool {
        return false
    }
    
    public func view(arguments: InstantPageItemArguments, currentExpandedDetails: [Int : Bool]?) -> (InstantPageView & NSView)? {
        return nil
    }
    
    public func linkSelectionViews() -> [InstantPageLinkSelectionView] {
        return []
    }
    
    public func distanceThresholdGroup() -> Int? {
        return nil
    }
    
    public func distanceThresholdWithGroupCount(_ count: Int) -> CGFloat {
        return 0.0
    }
    
}
