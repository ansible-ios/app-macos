import Cocoa

import Foundation
import TelegramCore

import SwiftSignalKit
import Postbox
import AnsibleMediaResources
#if SHARE
import AnsibleThemeShare
#else
import AnsibleTheme
#endif

public func fetchExternalMusicAlbumArtResource(engine: TelegramEngine, file: FileMediaReference?, resource: ExternalMusicAlbumArtResource) -> Signal<EngineMediaResource.Fetch.Result, EngineMediaResource.Fetch.Error> {
    return engine.resources.fetchAlbumCover(file: file, title: resource.title, performer: resource.performer, isThumbnail: resource.isThumbnail)
}

