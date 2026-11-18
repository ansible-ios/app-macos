import Cocoa
import TGUIKit
import AnsibleTheme
import ColorPalette

enum StorageUsageResources {
    private static func image(_ name: String) -> NSImage {
        guard let image = Bundle.module.image(forResource: NSImage.Name(name)) else {
            preconditionFailure("Missing storage usage image: \(name)")
        }
        return image
    }

    static func particle(for category: StorageUsageCategory) -> CGImage {
        let image: NSImage
        switch category {
        case .photos:
            image = AnsibleThemeHooks.shared.image(.iconSvgParticlePhotos)
        case .videos:
            image = AnsibleThemeHooks.shared.image(.iconSvgParticleVideos)
        case .files:
            image = AnsibleThemeHooks.shared.image(.iconSvgParticleFiles)
        case .music:
            image = AnsibleThemeHooks.shared.image(.iconSvgParticleMusic)
        case .stickers:
            image = self.image("StorageParticleStickers")
        case .avatars:
            image = self.image("StorageParticleAvatars")
        case .other, .misc, .stories:
            image = AnsibleThemeHooks.shared.image(.iconSvgParticleOther)
        }
        return image.precomposed()
    }

    static var storiesIcon: CGImage {
        let icon = image("StorageStories").precomposed(.white, flipVertical: true)
        return generateImage(NSMakeSize(24, 24), contextGenerator: { size, context in
            context.clear(size.bounds)
            let path = CGPath(roundedRect: size.bounds, cornerWidth: 6.4, cornerHeight: 6.4, transform: nil)
            context.addPath(path)
            context.clip()
            context.setFillColor(NSColor(rgb: 0x5E5CE6).cgColor)
            context.fill(size.bounds)
            context.draw(icon, in: size.bounds)
        })!
    }
}
