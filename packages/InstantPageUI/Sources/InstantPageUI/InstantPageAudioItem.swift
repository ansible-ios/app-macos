import Cocoa
import TGUIKit
import AnsibleContext
import AudioPlayerCore
import Localization
import AnsibleUtils
import AnsibleMediaUtils
import AnsibleTheme
import Postbox
import TelegramCore
import SwiftSignalKit
import RangeSet
import Localization
import ColorPalette
import InAppSettings
import AnsibleTheme
import AnsibleMediaUtils
import AnsibleMedia


public final class InstantPageAudioItem: InstantPageItem {
    public let wantsView: Bool = true
    public let hasLinks: Bool = false
    public var isInteractive: Bool {
        return true
    }
    public let separatesTiles: Bool = false

    public func linkSelectionViews() -> [InstantPageLinkSelectionView] {
        return []
    }
    
    public var frame: CGRect
    public let medias: [InstantPageMedia]
    
    public let media: InstantPageMedia
    
    public init(frame: CGRect, media: InstantPageMedia) {
        self.frame = frame
        self.media = media
        self.medias = [media]
    }
    
    public func view(arguments: InstantPageItemArguments, currentExpandedDetails: [Int : Bool]?) -> (InstantPageView & NSView)? {
        let context = arguments.context
        return InstantPageAudioView(context: context, media: media)
    }
    
    public func matchesAnchor(_ anchor: String) -> Bool {
        return false
    }
    
    public func matchesView(_ node: InstantPageView) -> Bool {
        if let node = node as? InstantPageAudioView {
            return self.media == node.media
        } else {
            return false
        }
    }
    
    public func distanceThresholdGroup() -> Int? {
        return 4
    }
    
    public func distanceThresholdWithGroupCount(_ count: Int) -> CGFloat {
        if count > 3 {
            return 1000.0
        } else {
            return CGFloat.greatestFiniteMagnitude
        }
    }
    
    public func linkSelectionRects(at point: CGPoint) -> [CGRect] {
        return []
    }
    
    public func drawInTile(context: CGContext) {
    }
}
