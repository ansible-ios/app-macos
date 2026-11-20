import Cocoa
import AnsibleUIKit
import AnsibleTheme
import GeneralRows

extension ChatListFilterVisibilityItem {
    public convenience init(_ initialSize: NSSize, stableId: AnyHashable, sidebar: Bool, viewType: GeneralViewType, source: Source = .folders, toggle: @escaping (Bool) -> Void) {
        self.init(initialSize, images: sidebarImage, stableId: stableId, sidebar: sidebar, viewType: viewType, source: source, toggle: toggle)
    }
}

public func sidebarImage(_ image: SidebarImage) -> NSImage {
    switch image {
    case .iconSharedFolder: return AnsibleThemeHooks.shared.image(.iconSharedFolder)
    case .tabsselectTopGray: return AnsibleThemeHooks.shared.image(.tabsselectTopGray)
    case .tabsselectTopSystemcol: return AnsibleThemeHooks.shared.image(.tabsselectTopSystemcol)
    case .tabsselectLeftGray: return AnsibleThemeHooks.shared.image(.tabsselectLeftGray)
    case .tabsselectLeftSystemcol: return AnsibleThemeHooks.shared.image(.tabsselectLeftSystemcol)
    case .iconForumTabs: return AnsibleThemeHooks.shared.image(.iconForumTabs)
    case .iconForumList: return AnsibleThemeHooks.shared.image(.iconForumList)
    }
}
