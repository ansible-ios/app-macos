import XCTest
import AnsibleUtils
import TelegramCore
import Postbox

final class StickerPackPersistenceTests: XCTestCase {
    private func cover(id: Int64, version: Int32, hint: TelegramMediaImageRepresentation.TypeHint) throws -> TelegramMediaFile {
        let thumbnail = TelegramMediaImageRepresentation(
            dimensions: PixelDimensions(width: 64, height: 64),
            resource: CloudStickerPackThumbnailMediaResource(datacenterId: 2, thumbVersion: version, volumeId: nil, localId: nil),
            progressiveSizes: [], immediateThumbnailData: nil, typeHint: hint
        )
        let pack = StickerPackCollectionInfo(id: ItemCollectionId(namespace: 0, id: id), flags: [], accessHash: 1, title: "Pack", shortName: "pack", thumbnail: thumbnail, thumbnailFileId: nil, immediateThumbnailData: nil, hash: version, count: 1)
        return try XCTUnwrap(pack.coverFile)
    }

    func testCoverCacheTracksPackAndVersion() throws {
        let animated = try cover(id: 10, version: 1, hint: .animated)
        XCTAssertEqual(animated.mimeType, "application/x-ansible-sticker")
        XCTAssertEqual(animated.fileName, "sticker.ass")
        XCTAssertEqual(try cover(id: 10, version: 1, hint: .animated).fileId, animated.fileId)
        for other in [try cover(id: 11, version: 1, hint: .animated), try cover(id: 10, version: 2, hint: .animated)] {
            XCTAssertNotEqual(other.resource.id, animated.resource.id)
            XCTAssertNotEqual(other.fileId, animated.fileId)
        }
        XCTAssertEqual(try cover(id: 10, version: 1, hint: .generic).mimeType, "image/webp")
        XCTAssertEqual(try cover(id: 10, version: 1, hint: .video).mimeType, "video/webm")
    }

    func testEditedCoverAndItemRestoredFromDisk() throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        for emoji in [false, true] {
            let namespace = emoji ? Namespaces.ItemCollection.CloudEmojiPacks : Namespaces.ItemCollection.CloudStickerPacks
            let packId = ItemCollectionId(namespace: namespace, id: 42)
            let id = MediaId(namespace: Namespaces.Media.CloudFile, id: 203)
            let info = StickerPackCollectionInfo(id: packId, flags: emoji ? [.isCreator, .isEmoji] : [.isCreator], accessHash: 1, title: "Edited", shortName: "edited", thumbnail: nil, thumbnailFileId: id.id, immediateThumbnailData: nil, hash: 3, count: 1)
            let resource = CloudDocumentMediaResource(datacenterId: 2, fileId: id.id, accessHash: 2, size: nil, fileReference: nil, fileName: "cover.ass")
            let attribute: TelegramMediaFileAttribute = emoji ? .CustomEmoji(isPremium: false, isSingleColor: false, alt: "🙂", packReference: nil) : .Sticker(displayText: "🙂", packReference: nil, maskData: nil)
            let file = TelegramMediaFile(fileId: id, partialReference: nil, resource: resource, previewRepresentations: [], videoThumbnails: [], immediateThumbnailData: nil, mimeType: "application/x-ansible-sticker", size: nil, attributes: [.FileName(fileName: "cover.ass"), .Animated, attribute], alternativeRepresentations: [])
            let item = StickerPackItem(index: .init(index: 0, id: id.id), file: file, indexKeys: [])
            let infoURL = directory.appendingPathComponent("info")
            let itemURL = directory.appendingPathComponent("item")
            let infoEncoder = PostboxEncoder()
            info.encode(infoEncoder)
            try infoEncoder.makeData().write(to: infoURL, options: .atomic)
            let itemEncoder = PostboxEncoder()
            item.encode(itemEncoder)
            try itemEncoder.makeData().write(to: itemURL, options: .atomic)

            let restored = StickerPackCollectionInfo(decoder: PostboxDecoder(buffer: MemoryBuffer(data: try Data(contentsOf: infoURL))))
            let cover = StickerPackItem(decoder: PostboxDecoder(buffer: MemoryBuffer(data: try Data(contentsOf: itemURL)))).file
            XCTAssertEqual(restored.id, packId)
            XCTAssertEqual(restored.thumbnailFileId, cover.fileId.id)
            XCTAssertEqual(cover.fileName, "cover.ass")
            XCTAssertEqual(cover._parse().mimeType, "application/x-ansible-sticker")
            XCTAssertEqual(cover._parse().isCustomEmoji, emoji)
        }
    }

    func testInstalledFavoriteAndRecentDocumentCodecs() throws {
        for emoji in [false, true] {
            let id = MediaId(namespace: Namespaces.Media.CloudFile, id: 101)
            let resource = CloudDocumentMediaResource(datacenterId: 2, fileId: id.id, accessHash: 1, size: nil, fileReference: nil, fileName: "wave.ass")
            let attribute: TelegramMediaFileAttribute = emoji ? .CustomEmoji(isPremium: false, isSingleColor: false, alt: "wave", packReference: nil) : .Sticker(displayText: "wave", packReference: nil, maskData: nil)
            let file = TelegramMediaFile(fileId: id, partialReference: nil, resource: resource, previewRepresentations: [], videoThumbnails: [], immediateThumbnailData: nil, mimeType: "application/x-ansible-sticker", size: nil, attributes: [.FileName(fileName: "wave.ass"), .Animated, attribute], alternativeRepresentations: [])
            let encoder = PostboxEncoder()
            StickerPackItem(index: .init(index: 0, id: id.id), file: file, indexKeys: []).encode(encoder)
            let installed = StickerPackItem(decoder: PostboxDecoder(buffer: MemoryBuffer(data: encoder.makeData())))
            let favorite = try JSONDecoder().decode(SavedStickerItem.self, from: JSONEncoder().encode(SavedStickerItem(file: file, stringRepresentations: ["wave"])))
            let recent = try JSONDecoder().decode(RecentMediaItem.self, from: JSONEncoder().encode(RecentMediaItem(file)))
            for restored in [installed.file, favorite.file, recent.media] {
                XCTAssertTrue(restored.isAnimatedSticker)
                XCTAssertEqual(restored._parse().mimeType, file.mimeType)
                XCTAssertEqual(restored.fileName, "wave.ass")
                XCTAssertEqual(restored.fileId, id)
                XCTAssertEqual(restored._parse().isCustomEmoji, emoji)
            }
        }
    }
}
