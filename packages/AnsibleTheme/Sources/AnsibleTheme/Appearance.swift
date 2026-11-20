import Cocoa
import AnsibleUIKit
import TelegramCore
import InAppSettings
import SwiftSignalKit
import Postbox
import AnsibleIconsTheme
import ColorPalette
import ThemeSettings
import Localization
#if !SHARE
#endif







#if !SHARE
#endif


public func generalPrepaidGiveawayIcon(_ bgColor: NSColor, count: NSAttributedString) -> CGImage {
    let layout = TextNode.layoutText(count, nil, 1, .end, NSMakeSize(.greatestFiniteMagnitude, .greatestFiniteMagnitude), nil, false, .center)
    let image = AnsibleThemeHooks.shared.image(.iconBoostPrepaid).precomposed(bgColor, flipVertical: true)

    return generateImage(NSMakeSize(layout.0.size.width + 10 + image.backingSize.width + 5, 24), rotatedContext: { size, ctx in
        ctx.clear(size.bounds)
        ctx.round(size, size.height / 2)
        ctx.setFillColor(bgColor.withAlphaComponent(0.2).cgColor)
        ctx.fill(size.bounds)
        
        var rect = size.bounds.focus(layout.0.size)
        rect.origin.x = size.width - rect.size.width - 5
        layout.1.draw(rect, in: ctx, backingScaleFactor: 2, backgroundColor: .clear)
        
        var imageRect = size.bounds.focus(image.backingSize)
        imageRect.origin.x = 5
        ctx.draw(image, in: imageRect)
    })!
}







#if !SHARE
public func generateDisclosureActionBoostLevelBadgeImage(text: String) -> CGImage {
    let attributedText = NSAttributedString(string: text, attributes: [
        .font: NSFont.medium(12.0),
        .foregroundColor: NSColor.white
    ])
    let bounds = attributedText.boundingRect(with: CGSize(width: 100.0, height: 100.0), options: .usesLineFragmentOrigin, context: nil)
    let leftInset: CGFloat = 16.0
    let rightInset: CGFloat = 4.0
    let size = CGSize(width: leftInset + rightInset + ceil(bounds.width), height: 20.0)
    return generateImage(size, rotatedContext: { size, context in
        context.clear(CGRect(origin: CGPoint(), size: size))
        let path = CGMutablePath()
        path.addRoundedRect(in: CGRect(origin: CGPoint(), size: size), cornerWidth: 4, cornerHeight: 4)
        context.addPath(path)
        context.clip()
        
        var locations: [CGFloat] = [0.0, 1.0]
        let colors: [CGColor] = [NSColor(rgb: 0x9076FF).cgColor, NSColor(rgb: 0xB86DEA).cgColor]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: &locations)!
        context.drawLinearGradient(gradient, start: CGPoint(x: 0.0, y: 0.0), end: CGPoint(x: size.width, y: 0.0), options: CGGradientDrawingOptions())
        
        context.resetClip()
        
        let image = AnsibleThemeHooks.shared.image(.iconEmojiLock).precomposed(flipVertical: true)
        
        if let image = generateTintedImage(image: image, color: .white) {
            let imageFit: CGFloat = 14.0
            let imageSize = image.size.aspectFitted(CGSize(width: imageFit, height: imageFit))
            let imageRect = CGRect(origin: CGPoint(x: 2.0, y: floorToScreenPixels((size.height - imageSize.height) * 0.5)), size: imageSize)
            context.draw(image, in: imageRect)
        }
        
        let layout = TextViewLayout(attributedText, maximumNumberOfLines: 1, truncationType: .middle)
        layout.measure(width: size.width)
        let line = layout.lines[0]
        
        context.textMatrix = CGAffineTransform(scaleX: 1.0, y: 1.0)
        context.textPosition = CGPoint(x: leftInset, y: floorToScreenPixels((size.height - bounds.height) * 0.5) + 4.0)
        CTLineDraw(line.line, context)
        
    })!
}
#endif









private func generateAvatarStarBadge(color: NSColor) -> CGImage {
    let image = AnsibleThemeHooks.shared.image(.iconStarCurrency).precomposed()
    let bigImage = AnsibleThemeHooks.shared.image(.iconStarOutline).precomposed()
    return generateImage(bigImage.systemSize, contextGenerator: { size, ctx in
        ctx.clear(size.bounds)
        
        
        ctx.clip(to: size.bounds, mask: bigImage)
        ctx.clear(size.bounds)
        
        ctx.setFillColor(color.cgColor)
        ctx.fill(size.bounds)

        ctx.draw(image, in: size.bounds.focus(image.backingSize))
    })!
}

private func generateAvatarStarBadgeLarge(color: NSColor) -> CGImage {
    let image = AnsibleThemeHooks.shared.image(.iconStarCurrencyBigSize).precomposed()
    let bigImage = AnsibleThemeHooks.shared.image(.iconStarOutlineBigSize).precomposed()
    return generateImage(bigImage.backingSize, contextGenerator: { size, ctx in
        ctx.clear(size.bounds)
        
        
        ctx.clip(to: size.bounds, mask: bigImage)
        ctx.clear(size.bounds)
        
        ctx.setFillColor(color.cgColor)
        ctx.fill(size.bounds)

        ctx.draw(image, in: size.bounds.focus(image.backingSize))
    })!
}










public func generateStarBalanceIcon(_ text: String) -> CGImage {
    return generateBalanceIcon(text: text, icon: AnsibleThemeHooks.shared.image(.iconStarCurrency).precomposed(flipVertical: true, zoom: 0.75), spacing: 1)
}



private func generateBalanceIcon(text: String, icon: CGImage, spacing: CGFloat) -> CGImage {
    let textNode = TextNode.layoutText(.initialize(string: text, color: theme.colors.grayText, font: .normal(.text)), nil, 1, .end, NSMakeSize(.greatestFiniteMagnitude, 20), nil, false, .center)
    let icon = icon
    var size = textNode.0.size
    
    size.width += icon.backingSize.width + spacing
    size.height = max(size.height, icon.backingSize.height)
    return generateImage(size, rotatedContext: { size, ctx in
        ctx.clear(size.bounds)
        
        let iconRect = size.bounds.focusY(icon.backingSize, x: 0)
        let textRect = size.bounds.focusY(textNode.0.size, x: iconRect.maxX + spacing)
        ctx.draw(icon, in: iconRect)
        
        textNode.1.draw(textRect, in: ctx, backingScaleFactor: System.backingScale, backgroundColor: .clear)
    })!
}




public func generateLiveStreamBadge(fontSize: CGFloat = .small, outerColor: NSColor? = nil) -> CGImage {
    let inner = generateTextIcon_AccentBadge(text: "LIVE", bgColor: AnsibleThemeHooks.shared.liveStreamBadgeColor(), textColor: NSColor.white, fontSize: fontSize, round: true)
    
    if let outerColor {
        let size = inner.backingSize.bounds.insetBy(dx: -2, dy: -2).size
        return generateImage(size, contextGenerator: { size, ctx in
            ctx.clear(size.bounds)
            ctx.setFillColor(outerColor.cgColor)
            ctx.round(size, size.height / 2)
            ctx.fill(size.bounds)
            
            ctx.draw(inner, in: size.bounds.focus(inner.backingSize))
        })!
    } else {
        return inner
    }
}


private func generateGradientBubble(_ colors: [NSColor]) -> CGImage {
    var colors = colors
    if !System.supportsTransparentFontDrawing {
        let blended = colors.reduce(colors.first!, {
            $0.blended(withFraction: 0.5, of: $1)!
        })
        for (i, _) in colors.enumerated() {
            colors[i] = blended
        }
    }
    
    return generateImage(CGSize(width: 32, height: 32), opaque: true, scale: 1.0, rotatedContext: { size, context in
        
        if colors.count > 1 {
            if colors.count == 2 {
                let gradient = CGGradient.evenlySpaced(colors, colorSpace: DeviceGraphicsContextSettings.shared.colorSpace)!
                
                context.drawLinearGradient(gradient, start: CGPoint(), end: CGPoint(x: 0.0, y: size.height), options: CGGradientDrawingOptions())
            } else {
                let preview = AnimatedGradientBackgroundView.generatePreview(size: NSMakeSize(32, 32), colors: colors)
                context.draw(preview, in: size.bounds)
            }
           
        } else if let color = colors.first {
            context.setFillColor(color.cgColor)
            context.fill(size.bounds)
        }
    })!
}

private func generateProfileIcon(_ image: CGImage, backgroundColor: NSColor) -> CGImage {
    return generateImage(image.backingSize, contextGenerator: { size, ctx in
        let rect = CGRect(origin: CGPoint(), size: size)
        ctx.clear(rect)
        

        
        ctx.setFillColor(backgroundColor.cgColor)
        ctx.fillEllipse(in: NSMakeRect(2, 2, rect.width - 4, rect.height - 4))
        
        ctx.clip(to: CGRect(origin: CGPoint(), size: size), mask: image)
        
        ctx.clear(rect)
     
        
 //      ctx.clip(to: rect)
//
//        ctx.setFillColor(NSColor.red.cgColor)
//        ctx.fillEllipse(in: NSMakeRect(2, 2, rect.width - 4, rect.height - 4))

        
    })!
}

private func generateChatTabFiltersIcon(_ image: CGImage) -> CGImage {
    return generateImage(image.backingSize, contextGenerator: { size, ctx in
        let rect = CGRect(origin: CGPoint(), size: size)
        ctx.clear(rect)
        
        ctx.draw(image, in: CGRect(origin: CGPoint(), size: size))
        
        ctx.setBlendMode(.clear)
        
        var x: CGFloat = 14
        ctx.fillEllipse(in: NSMakeRect(x, 17, 3, 3))
        x += (3 + 2)
        ctx.fillEllipse(in: NSMakeRect(x, 17, 3, 3))
        x += (3 + 2)
        ctx.fillEllipse(in: NSMakeRect(x, 17, 3, 3))

    })!
}

private func generateChatAction(_ image: CGImage, background: NSColor) -> CGImage {
    return generateImage(NSMakeSize(36, 36), contextGenerator: { size, ctx in
        let rect = CGRect(origin: CGPoint(), size: size)
        ctx.clear(rect)
        
        ctx.setFillColor(NSColor.clear.cgColor)
        ctx.fillEllipse(in: rect)
        ctx.draw(image, in: rect.focus(image.backingSize))
        
    })!
}

private func generateTodoSelection(color: NSColor) -> CGImage {
    return generateImage(NSMakeSize(19, 19), rotatedContext: { size, ctx in
        ctx.clear(size.bounds)
        ctx.setFillColor(color.cgColor)
        ctx.fillEllipse(in: size.bounds.focus(NSMakeSize(6, 6)))
    })!
}
private func generateTodoSelected(color: NSColor) -> CGImage {
    let image = AnsibleThemeHooks.shared.image(.iconTodoOtherCheck).precomposed(color)
    return generateImage(NSMakeSize(19, 19), contextGenerator: { size, ctx in
        ctx.clear(size.bounds)
        ctx.draw(image, in: size.bounds.focus(image.backingSize))
    })!
}

private func generatePollIcon(_ image: NSImage, backgound: NSColor) -> CGImage {
    return generateImage(NSMakeSize(19, 19), contextGenerator: { size, ctx in
        let rect = NSMakeRect(0, 0, size.width, size.height)
        ctx.clear(rect)
        
        ctx.setBlendMode(.copy)
        ctx.round(size, size.height / 2)
        
        
        if backgound != NSColor(0xffffff) {
            ctx.setFillColor(NSColor(0xffffff).cgColor)
            ctx.fillEllipse(in: rect)
        }
        
        ctx.setFillColor(backgound.cgColor)
        ctx.fillEllipse(in: rect.insetBy(dx: 1, dy: 1))
        
        
        ctx.setBlendMode(.normal)
        let image = image.cgImage(forProposedRect: nil, context: nil, hints: nil)!
        if backgound == NSColor(0xffffff) {
            ctx.clip(to: rect, mask: image)
            ctx.clear(rect)
        } else {
            
         
            ctx.draw(image, in: rect.focus(image.backingSize))
        }
    })!
}

private func generateSecretThumbSmall(_ image: CGImage) -> CGImage {
    return generateImage(NSMakeSize(floor(image.size.width * 0.7), floor(image.size.height * 0.7)), contextGenerator: { size, ctx in
        let rect = NSMakeRect(0, 0, size.width, size.height)
        ctx.clear(rect)
        ctx.clip(to: rect, mask: image)
        ctx.setBlendMode(.difference)
        ctx.setFillColor(.white)
        ctx.fill(rect)
        ctx.draw(image, in: rect)
    }, scale: 1.0)!
}

private func generateSecretThumb(_ image: CGImage) -> CGImage {
    return generateImage(image.size, contextGenerator: { size, ctx in
        let rect = NSMakeRect(0, 0, size.width, size.height)
        ctx.clear(rect)
        ctx.clip(to: rect, mask: image)
        ctx.setBlendMode(.difference)
        ctx.setFillColor(.white)
        ctx.fill(rect)
        ctx.draw(image, in: rect)
    }, scale: 1.0)!
}

private func generateLoginQrEmptyCap() -> CGImage {
    return generateImage(NSMakeSize(60, 60), contextGenerator: { size, ctx in
        ctx.clear(CGRect(origin: CGPoint(), size: size))
    })!
}

private func generateSendIcon(_ image: NSImage, _ color: NSColor) -> CGImage {
    let image = image.precomposed(color)
    if color.lightness > 0.7 {
        return image
    } else {
        return generateImage(image.backingSize, contextGenerator: { size, ctx in
            let rect = CGRect(origin: CGPoint(), size: size)
            ctx.clear(rect)
            
            ctx.setFillColor(.white)
            ctx.fillEllipse(in: rect.focus(NSMakeSize(rect.width - 8, rect.height - 8)))
            
            ctx.draw(image, in: CGRect(origin: CGPoint(), size: size))
        })!
    }
}

private func generateUnslectedCap(_ color: NSColor) -> CGImage {
    return generateImage(NSMakeSize(22, 22), contextGenerator: { size, ctx in
        let rect = CGRect(origin: CGPoint(), size: size)
        ctx.clear(rect)
        
        ctx.setStrokeColor(color.withAlphaComponent(0.7).cgColor)
        ctx.setLineWidth(1.0)
        ctx.strokeEllipse(in: NSMakeRect(1, 1, size.width - 2, size.height - 2))
    })!
}

private func generatePollSquareUnselected(_ color: NSColor) -> CGImage {
    return generateImage(NSMakeSize(19, 19), contextGenerator: { size, ctx in
        let rect = CGRect(origin: CGPoint(), size: size)
        ctx.clear(rect)
        drawPollSquareUnselected(ctx, rect: rect, borderColor: color.withAlphaComponent(0.35))
    })!
}

private func generatePollSquareIcon(_ image: NSImage, backgound: NSColor) -> CGImage {
    return generateImage(NSMakeSize(19, 19), contextGenerator: { size, ctx in
        let rect = NSMakeRect(0, 0, size.width, size.height)
        ctx.clear(rect)
        drawPollSquareSelected(ctx, rect: rect, image: image, backgroundColor: backgound)
    })!
}

private func generatePollAddOption(_ color: NSColor) -> CGImage {
    let image = AnsibleThemeHooks.shared.image(.iconPollAddOption).precomposed(color)
    return generateImage(image.backingSize, contextGenerator: { size, ctx in
        ctx.clear(CGRect(origin: CGPoint(), size: size))
        
        ctx.setFillColor(.white)
        ctx.fillEllipse(in: NSMakeRect(0, 0, size.width, size.height))
        
        ctx.draw(image, in: CGRect(origin: CGPoint(), size: size))
    })!
}

public func generateThemePreview(for palette: ColorPalette, wallpaper: Wallpaper, backgroundMode: TableBackgroundMode) -> CGImage {
    return generateImage(NSMakeSize(320, 320), rotatedContext: { size, ctx in
        let rect = NSMakeRect(0, 0, size.width, size.height)
        ctx.clear(rect)
        
        ctx.setFillColor(palette.chatBackground.cgColor)
        ctx.fill(rect)
        
        #if !SHARE
        switch wallpaper {
        case .builtin, .file, .color, .gradient:
            ctx.saveGState()
            ctx.translateBy(x: size.width / 2.0, y: size.height / 2.0)
            ctx.scaleBy(x: 1.0, y: -1.0)
            ctx.translateBy(x: -size.width / 2.0, y: -size.height / 2.0)
            drawBg(backgroundMode, palette: palette, bubbled: true, rect: rect, in: ctx)
            ctx.restoreGState()
        default:
            break
        }
        #endif
        
        
        ctx.setFillColor(palette.background.cgColor)
        ctx.fill(NSMakeRect(0, 0, rect.width, 50))
        ctx.setFillColor(palette.background.cgColor)
        ctx.fill(NSMakeRect(0, rect.height - 50, rect.width, 50))
        
        
        
        ctx.setFillColor(palette.border.cgColor)
        ctx.fill(NSMakeRect(0, 50, rect.width, .borderSize))
        
        ctx.setFillColor(palette.border.cgColor)
        ctx.fill(NSMakeRect(0, rect.height - 50, rect.width, .borderSize))
        
        
        ctx.setFillColor(palette.grayForeground.cgColor)
        ctx.fillEllipse(in: NSMakeRect(20, (50 - 36) / 2, 36, 36))
        
        let chatAction = AnsibleThemeHooks.shared.image(.iconChatActions).precomposed(palette.accentIcon)
        ctx.draw(chatAction, in: NSMakeRect(rect.width - 20 - chatAction.backingSize.width, (50 - chatAction.backingSize.height) / 2, chatAction.backingSize.width, chatAction.backingSize.height))
        
        let inputAttach = AnsibleThemeHooks.shared.image(.iconChatAttach).precomposed(palette.grayIcon, flipVertical: true)
        ctx.draw(inputAttach, in: NSMakeRect(20, rect.height - 50 + ((50 - inputAttach.backingSize.height) / 2), inputAttach.backingSize.width, inputAttach.backingSize.height))
        
        let micro = AnsibleThemeHooks.shared.image(.iconRecordVoice).precomposed(palette.grayIcon, flipVertical: true)
        ctx.draw(micro, in: NSMakeRect(rect.width - 20 - inputAttach.backingSize.width, (rect.height - 50 + (50 - micro.backingSize.height) / 2), micro.backingSize.width, micro.backingSize.height))
        
        let chatServiceItemColor: NSColor
        
        
        switch wallpaper {
        case .builtin, .file, .color, .gradient:
            switch backgroundMode {
            case let .background(image, _, colors, _, _):
                if let colors = colors, let first = colors.first {
                    let blended = colors.reduce(first, { color, with in
                        return color.blended(withFraction: 0.5, of: with)!
                    })
                    chatServiceItemColor = getAverageColor(blended)
                } else {
                    chatServiceItemColor = getAverageColor(image)
                }
            case let .color(color):
                if color != palette.background {
                    chatServiceItemColor = getAverageColor(color)
                } else {
                    chatServiceItemColor = color
                }
            case let .gradient(colors, _):
                let blended = colors.reduce(colors.first!, { color, with in
                    return color.blended(withFraction: 0.5, of: with)!
                })
                chatServiceItemColor = getAverageColor(blended)
            case let .tiled(image):
                chatServiceItemColor = getAverageColor(image)
            case .plain:
                chatServiceItemColor = palette.chatBackground
            }
        default:
            chatServiceItemColor = getAverageColor(palette.chatBackground)
        }
        
        
        
        ctx.setFillColor(chatServiceItemColor.cgColor)
        let path = CGMutablePath()
        path.addRoundedRect(in: NSMakeRect(rect.width / 2 - 30, rect.height - 50 - 10 - 60 - 5 - 20 - 5, 60, 20), cornerWidth: 10, cornerHeight: 10)
        
        ctx.addPath(path)
        ctx.closePath()
        ctx.fillPath()
        
        
        CATransaction.begin()
        if true {
            
            let image = generateImage(NSMakeSize(150, 30), rotatedContext: { size, ctx in
                ctx.clear(NSMakeRect(0, 0, size.width, size.height))
                let data = messageBubbleImageModern(incoming: false, fillColor: palette.blendedOutgoingColors, strokeColor: .clear, neighbors: .none)
                
                let layer = CALayer()
                layer.frame = NSMakeRect(0, 0, 150, 30)
                layer.contentsScale = 2.0
                let imageSize = data.0.backingSize
                let insets = data.1
                let halfPixelFudge: CGFloat = 0.49
                let otherPixelFudge: CGFloat = 0.02
                var contentsCenter: CGRect  = NSMakeRect(0.0, 0.0, 1.0, 1.0);
                if (insets.left > 0 || insets.right > 0) {
                    contentsCenter.origin.x = ((insets.left + halfPixelFudge) / imageSize.width);
                    contentsCenter.size.width = (imageSize.width - (insets.left + insets.right + 1.0) + otherPixelFudge) / imageSize.width;
                }
                if (insets.top > 0 || insets.bottom > 0) {
                    contentsCenter.origin.y = ((insets.top + halfPixelFudge) / imageSize.height);
                    contentsCenter.size.height = (imageSize.height - (insets.top + insets.bottom + 1.0) + otherPixelFudge) / imageSize.height;
                }
                layer.contentsGravity = .resize;
                layer.contentsCenter = contentsCenter;
                layer.contents = data.0
                
                layer.render(in: ctx)
            })!
            
            var bubble = image
            bubble = generateImage(NSMakeSize(150, 30), contextGenerator: { size, ctx in
                let colors = palette.bubbleBackground_outgoing.map { $0.withAlphaComponent(1.0) }
                let rect = NSMakeRect(0, 0, size.width, size.height)
                ctx.clear(rect)
                ctx.clip(to: rect, mask: image)
                
                if colors.count > 1 {
                    let gradient = CGGradient.evenlySpaced(colors)!
                    ctx.drawLinearGradient(gradient, start: CGPoint(x: 0.0, y: 0.0), end: CGPoint(x: 0.0, y: rect.height), options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
                } else if colors.count == 1 {
                    ctx.setFillColor(colors[0].cgColor)
                    ctx.fill(rect)
                }
                
            })!
            ctx.draw(bubble, in: NSMakeRect(160, 230, 150, 30))
           
        }
        
        if true {
            let image = generateImage(NSMakeSize(150, 30), rotatedContext: { size, ctx in
                ctx.clear(NSMakeRect(0, 0, size.width, size.height))
                let data = messageBubbleImageModern(incoming: true, fillColor: palette.bubbleBackground_incoming, strokeColor: .clear, neighbors: .none)
                
                let layer = CALayer()
                layer.frame = NSMakeRect(0, 0, 150, 30)
                layer.contentsScale = 2.0
                let imageSize = data.0.backingSize
                let insets = data.1
                let halfPixelFudge: CGFloat = 0.49
                let otherPixelFudge: CGFloat = 0.02
                var contentsCenter: CGRect  = NSMakeRect(0.0, 0.0, 1.0, 1.0);
                if (insets.left > 0 || insets.right > 0) {
                    contentsCenter.origin.x = ((insets.left + halfPixelFudge) / imageSize.width);
                    contentsCenter.size.width = (imageSize.width - (insets.left + insets.right + 1.0) + otherPixelFudge) / imageSize.width;
                }
                if (insets.top > 0 || insets.bottom > 0) {
                    contentsCenter.origin.y = ((insets.top + halfPixelFudge) / imageSize.height);
                    contentsCenter.size.height = (imageSize.height - (insets.top + insets.bottom + 1.0) + otherPixelFudge) / imageSize.height;
                }
                layer.contentsGravity = .resize;
                layer.contentsCenter = contentsCenter;
                layer.contents = data.0
                
                layer.render(in: ctx)
            })!
            
            ctx.draw(image, in: NSMakeRect(10, 200, 150, 30))

        }
        CATransaction.commit()
        
    })!
}

func generateLockPremium(_ palette: ColorPalette) -> CGImage {
    let image = AnsibleThemeHooks.shared.image(.iconPremiumLock).precomposed(palette.accent)
    return generateImage(image.backingSize, contextGenerator: { size, ctx in
        ctx.clear(size.bounds)
        

        
        ctx.clip(to: size.bounds, mask: image)

        let gradient = CGGradient.evenlySpaced([NSColor(hexString: "#ffffff")!, NSColor(hexString: "#ffffff")!], colorSpace: deviceColorSpace)!
        
        ctx.drawLinearGradient(gradient, start: CGPoint(x: size.width, y: 0), end: CGPoint(x: 0.0, y: size.height), options: CGGradientDrawingOptions())
    })!
}



func generateStickerPackPremium() -> CGImage {
    
    let draw: (NSSize, CGContext)->Void = { size, ctx in
        ctx.clear(CGRect(origin: CGPoint(), size: size))

        let image = AnsibleThemeHooks.shared.image(.iconPremiumStickerPack).precomposed()
        ctx.clip(to: size.bounds, mask: image)

        let gradient = CGGradient.evenlySpaced(premiumGradient.compactMap { $0.cgColor }, colorSpace: deviceColorSpace)!
        
        ctx.drawLinearGradient(gradient, start: CGPoint(x: size.width, y: 0), end: CGPoint(x: 0.0, y: size.height), options: CGGradientDrawingOptions())
        
    }
    return generateImage(NSMakeSize(24, 24), contextGenerator: { size, ctx in
        draw(size, ctx)
    })!
}

func generateDialogVerify(background: NSColor, foreground: NSColor, reversed: Bool = false) -> CGImage {
    if reversed {
        return generateImage(NSMakeSize(16, 16), contextGenerator: { size, ctx in
            ctx.clear(CGRect(origin: CGPoint(), size: size))

            let image = AnsibleThemeHooks.shared.image(.iconVerifyDialog).precomposed(foreground)
            
            ctx.setFillColor(background.cgColor)
            ctx.fillEllipse(in: NSMakeRect(4, 4, size.width - 8, size.height - 8))
            
            ctx.draw(image, in: CGRect(origin: CGPoint(), size: size))
        })!
    } else {
        return generateImage(NSMakeSize(16, 16), rotatedContext: { size, ctx in
            ctx.clear(CGRect(origin: CGPoint(), size: size))

            let image = AnsibleThemeHooks.shared.image(.iconVerifyDialog).precomposed(foreground)
            
            ctx.setFillColor(background.cgColor)
            ctx.fillEllipse(in: NSMakeRect(4, 4, size.width - 8, size.height - 8))
            
            ctx.draw(image, in: CGRect(origin: CGPoint(), size: size))
        })!
    }
}


func generateDialogVerifyLeft(background: NSColor, foreground: NSColor, reversed: Bool = false) -> CGImage {
    if reversed {
        return generateImage(NSMakeSize(16, 16), contextGenerator: { size, ctx in
            ctx.clear(CGRect(origin: CGPoint(), size: size))

            let image = AnsibleThemeHooks.shared.image(.iconVerifiedAnsible).precomposed(foreground)
            
            ctx.setFillColor(background.cgColor)
            ctx.fillEllipse(in: NSMakeRect(4, 4, size.width - 8, size.height - 8))
            
            ctx.draw(image, in: CGRect(origin: CGPoint(), size: size))
        })!
    } else {
        return generateImage(NSMakeSize(16, 16), rotatedContext: { size, ctx in
            ctx.clear(CGRect(origin: CGPoint(), size: size))

            let image = AnsibleThemeHooks.shared.image(.iconVerifiedAnsible).precomposed(foreground)
            
            ctx.setFillColor(background.cgColor)
            ctx.fillEllipse(in: NSMakeRect(4, 4, size.width - 8, size.height - 8))
            
            ctx.draw(image, in: CGRect(origin: CGPoint(), size: size))
        })!
    }
}


private func generatePollDeleteOption(_ color: NSColor) -> CGImage {
    let image = AnsibleThemeHooks.shared.image(.iconPollDeleteOption).precomposed(color)
    return generateImage(image.backingSize, contextGenerator: { size, ctx in
        ctx.clear(CGRect(origin: CGPoint(), size: size))
        
        ctx.setFillColor(.white)
        ctx.fillEllipse(in: NSMakeRect(0, 0, size.width, size.height))
        
        ctx.draw(image, in: CGRect(origin: CGPoint(), size: size))
    })!
}

private func generateStickerPackSelection(_ color: NSColor) -> CGImage {
    return generateImage(NSMakeSize(30, 30), contextGenerator: { size, ctx in
        ctx.interpolationQuality = .low
        ctx.clear(CGRect(origin: CGPoint(), size: size))
        ctx.round(size, .cornerRadius)
        ctx.setFillColor(color.cgColor)
        ctx.fill(NSMakeRect(0, 0, size.width, size.height))
    })!
}

private func generateHitActiveIcon(activeColor: NSColor, backgroundColor: NSColor) -> CGImage {
    return generateImage(NSMakeSize(12, 12), contextGenerator: { size, ctx in
        ctx.interpolationQuality = .high
        ctx.clear(CGRect(origin: CGPoint(), size: size))
        ctx.round(size, size.width / 2)
        ctx.setFillColor(backgroundColor.cgColor)
        ctx.fillEllipse(in: NSMakeRect(0, 0, size.width, size.height))
        
        ctx.setFillColor(activeColor.cgColor)
        ctx.fillEllipse(in: NSMakeRect(2, 2, 8, 8))
    })!
}


func generateScamIcon(foregroundColor: NSColor, backgroundColor: NSColor, text: String = strings().markScam, isReversed: Bool = false) -> CGImage {
    let textNode = TextNode.layoutText(.initialize(string: text, color: foregroundColor, font: .medium(9)), nil, 1, .end, NSMakeSize(.greatestFiniteMagnitude, 20), nil, false, .center)
    
    let draw: (CGSize, CGContext) -> Void = { size, ctx in
        ctx.interpolationQuality = .high
        ctx.clear(CGRect(origin: CGPoint(), size: size))
        
        
        let borderPath = CGMutablePath()
        borderPath.addRoundedRect(in: NSMakeRect(1, 1, size.width - 2, size.height - 2), cornerWidth: 2, cornerHeight: 2)
        
        ctx.setStrokeColor(foregroundColor.cgColor)
        ctx.addPath(borderPath)
        ctx.closePath()
        ctx.strokePath()
        
        let textRect = NSMakeRect((size.width - textNode.0.size.width) / 2, (size.height - textNode.0.size.height) / 2 + 1, textNode.0.size.width, textNode.0.size.height)
        textNode.1.draw(textRect, in: ctx, backingScaleFactor: System.backingScale, backgroundColor: backgroundColor)
    }
    if !isReversed {
        return generateImage(NSMakeSize(textNode.0.size.width + 8, 16), contextGenerator: draw)!
    } else {
        return generateImage(NSMakeSize(textNode.0.size.width + 8, 16), rotatedContext: draw)!
    }
}

public func generateScamIconReversed(foregroundColor: NSColor, backgroundColor: NSColor) -> CGImage {
    return generateScamIcon(foregroundColor: foregroundColor, backgroundColor: backgroundColor, isReversed: true)
}

public func generateFakeIconReversed(foregroundColor: NSColor, backgroundColor: NSColor) -> CGImage {
    return generateScamIcon(foregroundColor: foregroundColor, backgroundColor: backgroundColor, text: strings().markFake, isReversed: true)
}

private func generateEditMessageMediaIcon(_ icon: CGImage, background: NSColor) -> CGImage {
    return generateImage(NSMakeSize(icon.backingSize.width + 1, icon.backingSize.height + 1), contextGenerator: { size, ctx in
        ctx.clear(CGRect(origin: CGPoint(), size: size))
        ctx.round(size, size.width / 2)
        
        ctx.setFillColor(background.cgColor)
        ctx.fillEllipse(in: NSMakeRect(0, 0, size.width, size.height))
        
        let imageRect = NSMakeRect(floorToScreenPixels(System.backingScale, (size.width - icon.backingSize.width) / 2), floorToScreenPixels(System.backingScale, (size.height - icon.backingSize.height) / 2), icon.backingSize.width, icon.backingSize.height)
        ctx.draw(icon, in: imageRect)
        
    })!
}

private func generateUnreadFeaturedStickers(_ icon: CGImage, _ color: NSColor) -> CGImage {
    return generateImage(NSMakeSize(icon.systemSize.width, icon.systemSize.height), contextGenerator: { size, ctx in
        ctx.clear(CGRect(origin: CGPoint(), size: size))

        let imageRect = size.bounds
        ctx.draw(icon, in: imageRect)

//        ctx.setFillColor(color.cgColor)
//        ctx.fillEllipse(in: NSMakeRect(size.width - 10, size.height - 10, 6, 6))

    }, scale: System.backingScale)!
}


private func generatePlayerListAlbumPlaceholder(_ icon: CGImage?, background: NSColor, radius: CGFloat) -> CGImage {
    return generateImage(NSMakeSize(40, 40), contextGenerator: { size, ctx in
        ctx.clear(CGRect(origin: CGPoint(), size: size))
        ctx.round(size, radius)
        
        ctx.setFillColor(background.cgColor)
        ctx.fill(NSMakeRect(0, 0, size.width, size.height))
        
        if let icon = icon {
            let imageRect = NSMakeRect(floorToScreenPixels(System.backingScale, (size.width - icon.backingSize.width) / 2), floorToScreenPixels(System.backingScale, (size.height - icon.backingSize.height) / 2), icon.backingSize.width, icon.backingSize.height)
            ctx.draw(icon, in: imageRect)
        }
       
    })!
}

private func generateFolderLinkIcon(palette: ColorPalette, revoked: Bool) -> CGImage {
    return generateImage(NSMakeSize(35, 35), contextGenerator: { size, ctx in
        ctx.clear(size.bounds)
        ctx.setFillColor(revoked ? palette.redUI.cgColor : palette.accent.cgColor)
        ctx.fillEllipse(in: size.bounds)
        
        let image = AnsibleThemeHooks.shared.image(.iconInviteViaLink).precomposed(palette.underSelectedColor)
        ctx.draw(image, in: size.bounds.focus(NSMakeSize(25, 25)))
    })!
}

private func generateLocationPinIcon(_ background: NSColor) -> CGImage {
    return generateImage(NSMakeSize(40, 40), contextGenerator: { size, ctx in
        ctx.clear(CGRect(origin: CGPoint(), size: size))
        ctx.round(size, size.width / 2)
        
        ctx.setFillColor(background.cgColor)
        ctx.fillEllipse(in: NSMakeRect(0, 0, size.width, size.height))
        
        let icon = AnsibleThemeHooks.shared.image(.iconLocationPin).precomposed(.white)
        let imageRect = NSMakeRect(floorToScreenPixels(System.backingScale, (size.width - icon.backingSize.width) / 2), floorToScreenPixels(System.backingScale, (size.height - icon.backingSize.height) / 2), icon.backingSize.width, icon.backingSize.height)
        ctx.draw(icon, in: imageRect)

    })!
}


private func generateTriangle(_ size: NSSize, color: NSColor) -> CGImage {
    return generateImage(size, contextGenerator: { size, ctx in
        let rect = CGRect(origin: CGPoint(), size: size)
        ctx.clear(rect)
        
        ctx.beginPath()
        ctx.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        ctx.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        ctx.addLine(to: CGPoint(x: (rect.midX), y: rect.minY))
        ctx.closePath()
        
        ctx.setFillColor(color.cgColor)
        ctx.fillPath()
    })!
}

private func generateStoryState(_ color: NSColor, bgColor: NSColor, size: NSSize, wide: CGFloat) -> CGImage {
    return generateImage(size, contextGenerator: { size, ctx in
        let rect = CGRect(origin: CGPoint(), size: size)
        ctx.clear(rect)
        
        
        let startAngle = -CGFloat.pi / 2.0
        let endAngle = CGFloat(1.0) * 2.0 * CGFloat.pi + startAngle
        
        let path = CGMutablePath()
        
        path.addArc(center: CGPoint(x: size.width / 2.0, y: size.height / 2.0), radius: size.width / 2 - 1, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        ctx.setStrokeColor(color.cgColor)
        ctx.setLineWidth(wide)
        ctx.setLineCap(.round)
        ctx.addPath(path)
        ctx.strokePath()
        
    })!
}





private func generateLocationMapPinIcon(_ background: NSColor) -> CGImage {
    return generateImage(NSMakeSize(40, 46), contextGenerator: { size, ctx in
        ctx.clear(CGRect(origin: CGPoint(), size: size))
        
        ctx.setFillColor(background.cgColor)
        ctx.fillEllipse(in: NSMakeRect(0, 6, size.width, size.height - 6))
        
        let icon = AnsibleThemeHooks.shared.image(.iconLocationPin).precomposed(.white)
        let imageRect = NSMakeRect(floorToScreenPixels(System.backingScale, (size.width - icon.backingSize.width) / 2), floorToScreenPixels(System.backingScale, (size.height - icon.backingSize.height) / 2) + 3, icon.backingSize.width, icon.backingSize.height)
        ctx.draw(icon, in: imageRect)
        
        let triangle = generateTriangle(NSMakeSize(12, 10), color: background)
        let triangleRect = NSMakeRect(floorToScreenPixels(System.backingScale, (size.width - triangle.backingSize.width) / 2), 0, triangle.backingSize.width, triangle.backingSize.height)
        
        ctx.draw(triangle, in: triangleRect)

    })!
}

func generateLockerBody(_ color: NSColor, backgroundColor: NSColor) -> CGImage {
    return generateImage(NSMakeSize(12.5, 12.5), contextGenerator: { size, ctx in
        ctx.clear(CGRect(origin: CGPoint(), size: size))

        ctx.setFillColor(backgroundColor.cgColor)
        ctx.fillEllipse(in: NSMakeRect(0, 0, size.width, size.height))

        ctx.setFillColor(color.cgColor)
        ctx.setStrokeColor(color.cgColor)
        ctx.setLineWidth(1.0)
        ctx.strokeEllipse(in: CGRect(origin: CGPoint(x: 1.0, y: 1.0), size: CGSize(width: size.width - 2.0, height: size.height - 2.0)))
        ctx.fillEllipse(in: NSMakeRect(floorToScreenPixels(System.backingScale, (size.width - 2)/2), floorToScreenPixels(System.backingScale, (size.height - 2)/2), 2, 2))

    })!
}
func generateLockerHead(_ color: NSColor, backgroundColor: NSColor) -> CGImage {
    return generateImage(NSMakeSize(10, 20), contextGenerator: { size, ctx in
        ctx.clear(CGRect(origin: CGPoint(), size: size))
        ctx.round(size, size.width / 2)

        ctx.setFillColor(color.cgColor)
        ctx.fill(NSMakeRect(0, 0, size.width, size.height))

        ctx.setFillColor(backgroundColor.cgColor)
        ctx.fillEllipse(in: CGRect(origin: CGPoint(x: 1.0, y: 1.0), size: CGSize(width: size.width - 2, height: size.width - 2)))
        ctx.fillEllipse(in: CGRect(origin: CGPoint(x: 1.0, y: size.height - size.width + 1), size: CGSize(width: size.width - 2, height: size.width - 2)))
        ctx.fill(NSMakeRect(1.0, 0, size.width - 1, 14))

        ctx.clear(NSMakeRect(0, 0, size.width, 3))

    })!
}

private func generateChatMention(image: NSImage, backgroundColor: NSColor, border: NSColor, foregroundColor: NSColor) -> CGImage {
    return generateImage(NSMakeSize(38, 38), contextGenerator: { size, ctx in
        ctx.clear(CGRect(origin: CGPoint(), size: size))
       
        let icon = image.precomposed(foregroundColor)
        let imageRect = NSMakeRect(floorToScreenPixels(System.backingScale, (size.width - icon.backingSize.width) / 2), floorToScreenPixels(System.backingScale, (size.height - icon.backingSize.height) / 2), icon.backingSize.width, icon.backingSize.height)
        ctx.draw(icon, in: imageRect)
    })!
}

private func generateChatFailed(backgroundColor: NSColor, border: NSColor, foregroundColor: NSColor) -> CGImage {
    return generateImage(NSMakeSize(38, 38), contextGenerator: { size, ctx in
        ctx.clear(CGRect(origin: CGPoint(), size: size))
        
        let icon = AnsibleThemeHooks.shared.image(.iconDialogSendingError).precomposed(foregroundColor)
        let imageRect = NSMakeRect(floorToScreenPixels(System.backingScale, (size.width - icon.backingSize.width) / 2), floorToScreenPixels(System.backingScale, (size.height - icon.backingSize.height) / 2), icon.backingSize.width, icon.backingSize.height)
        ctx.draw(icon, in: imageRect)
    })!
}


private func generateSettingsActiveIcon(_ icon: CGImage, background: NSColor) -> CGImage {
    return generateImage(NSMakeSize(24, 24), contextGenerator: { size, ctx in
        ctx.clear(CGRect(origin: CGPoint(), size: size))
        ctx.setFillColor(background.cgColor)
        ctx.fill(size.bounds.insetBy(dx: 3, dy: 3))
        ctx.draw(icon, in: CGRect(origin: CGPoint(), size: size))
    }, scale: System.backingScale)!
}

private func generatePremiumIcon(_ icon: CGImage) -> CGImage {
    return generateImage(NSMakeSize(24, 24), contextGenerator: { size, ctx in
        ctx.clear(size.bounds)
        ctx.round(size, 5)
        
        let gradient = CGGradient.evenlySpaced(premiumGradient.compactMap { $0.cgColor }, colorSpace: deviceColorSpace)!
        
        ctx.drawLinearGradient(gradient, start: CGPoint(x: 0, y: size.height), end: CGPoint(x: size.width, y: size.height), options: CGGradientDrawingOptions())

        let icon = generateImage(icon.backingSize, contextGenerator: { size, ctx in
            ctx.clear(size.bounds)
            ctx.clip(to: size.bounds, mask: icon)
            ctx.setFillColor(.white)
            ctx.fill(size.bounds)
        })!
        
        ctx.draw(icon, in: size.bounds.focus(icon.backingSize))
        
    })!
}


private func generateStickersEmptySearch(color: NSColor) -> CGImage {
    return generateImage(NSMakeSize(100, 100), contextGenerator: { size, ctx in
        let rect = CGRect(origin: CGPoint(), size: size)
        ctx.clear(rect)
        
        let icon = AnsibleThemeHooks.shared.image(.iconEmptySearchResults).precomposed(color)
        let imageSize = icon.backingSize.fitted(size)
        ctx.draw(icon, in: rect.focus(imageSize))
    }, scale: 1.0)!
}

private func generateAlertCheckBoxSelected(backgroundColor: NSColor) -> CGImage {
    return generateImage(NSMakeSize(14, 14), contextGenerator: { size, ctx in
        let rect = NSMakeRect(0, 0, size.width, size.height)
        ctx.clear(rect)
        ctx.setFillColor(backgroundColor.cgColor)
        ctx.round(size, 2)
        ctx.fill(rect)

        let icon = AnsibleThemeHooks.shared.image(.iconAlertCheckBoxMark).precomposed()
        ctx.draw(icon, in: NSMakeRect((rect.width - icon.backingSize.width) / 2, (rect.height - icon.backingSize.height) / 2, icon.backingSize.width, icon.backingSize.height))
        
    })!
}
private func generateAlertCheckBoxUnselected(border: NSColor) -> CGImage {
    return generateImage(NSMakeSize(14, 14), contextGenerator: { size, ctx in
        let rect = NSMakeRect(0, 0, size.width, size.height)
        ctx.clear(rect)
        ctx.setStrokeColor(border.cgColor)
        ctx.setLineWidth(3.0)
        ctx.round(size, 2)
        ctx.stroke(rect)
    })!
}


private func generateTransparentBackground() -> CGImage {
    return generateImage(NSMakeSize(20, 20), contextGenerator: { size, ctx in
        ctx.clear(CGRect(origin: CGPoint(), size: size))
        ctx.setFillColor(NSColor(0xcbcbcb).cgColor)
        ctx.fill(NSMakeRect(0, 0, 10, 10))
        ctx.setFillColor(NSColor(0xfdfdfd).cgColor)
        ctx.fill(NSMakeRect(10, 0, 10, 10))
        
        ctx.setFillColor(NSColor(0xfdfdfd).cgColor)
        ctx.fill(NSMakeRect(0, 10, 10, 10))
        ctx.setFillColor(NSColor(0xcbcbcb).cgColor)
        ctx.fill(NSMakeRect(10, 10, 10, 10))

    })!
}

private func generateLottieTransparentBackground() -> CGImage {
    return generateImage(NSMakeSize(10, 10), contextGenerator: { size, ctx in
        ctx.clear(CGRect(origin: CGPoint(), size: size))
        ctx.setFillColor(.black)
        ctx.fill(NSMakeRect(0, 0, 5, 5))
        ctx.setFillColor(NSColor.lightGray.cgColor)
        ctx.fill(NSMakeRect(5, 0, 5, 5))
        
        ctx.setFillColor(NSColor.lightGray.cgColor)
        ctx.fill(NSMakeRect(0, 5, 5, 5))
        ctx.setFillColor(.black)
        ctx.fill(NSMakeRect(5, 5, 5, 5))
        
    })!
}

private func generateIVAudioPlay(color: NSColor) -> CGImage {
    return generateImage(NSMakeSize(40, 40), contextGenerator: { size, ctx in
        ctx.clear(CGRect(origin: CGPoint(), size: size))
        ctx.setStrokeColor(color.cgColor)
        ctx.setLineWidth(3)
        ctx.strokeEllipse(in: NSMakeRect(2, 2, size.width - 4, size.height - 4))
        let icon = AnsibleThemeHooks.shared.image(.iconChatMusicPlay).precomposed(color)
        
        ctx.draw(icon, in: NSMakeRect(floorToScreenPixels(System.backingScale, (size.width - icon.backingSize.width) / 2), floorToScreenPixels(System.backingScale, (size.height - icon.backingSize.height) / 2), icon.backingSize.width, icon.backingSize.height))
        
    })!
}

private func generateIVAudioPause(color: NSColor) -> CGImage {
    return generateImage(NSMakeSize(40, 40), contextGenerator: { size, ctx in
        ctx.clear(CGRect(origin: CGPoint(), size: size))
        ctx.setStrokeColor(color.cgColor)
        ctx.setLineWidth(3)
        ctx.strokeEllipse(in: NSMakeRect(2, 2, size.width - 4, size.height - 4))
        let icon = AnsibleThemeHooks.shared.image(.iconChatMusicPause).precomposed(color)
        ctx.draw(icon, in: NSMakeRect(floorToScreenPixels(System.backingScale, (size.width - icon.backingSize.width) / 2), floorToScreenPixels(System.backingScale, (size.height - icon.backingSize.height) / 2), icon.backingSize.width, icon.backingSize.height))
    })!
}

private func generateBadgeMention(image: NSImage, backgroundColor: NSColor, foregroundColor: NSColor) -> CGImage {
    
    return image.precomposed(backgroundColor)
    

}





private func generateChatGroupToggleSelectionForeground(foregroundColor: NSColor, backgroundColor: NSColor) -> CGImage {
    let icon = AnsibleThemeHooks.shared.image(.iconSelectionUncheck).precomposed(foregroundColor)
    return generateImage(NSMakeSize(icon.backingSize.width + 4, icon.backingSize.height + 4), contextGenerator: { size, ctx in
        ctx.clear(NSMakeRect(0, 0, size.width, size.height))
        ctx.round(size, size.width/2)
        ctx.setFillColor(backgroundColor.cgColor)
        ctx.fill(NSMakeRect(0, 0, size.width, size.height))
        let imageRect = NSMakeRect((size.width - icon.backingSize.width) / 2, (size.height - icon.backingSize.height) / 2, icon.backingSize.width, icon.backingSize.height)
        ctx.draw(icon, in: imageRect)
    })!
}



private func deleteItemIcon(_ color: NSColor) -> CGImage {
    return generateImage(NSMakeSize(24,24), contextGenerator: { (size, ctx) in
        ctx.clear(NSMakeRect(0,0,size.width,size.height))
        ctx.setFillColor(color.cgColor)
        ctx.fillEllipse(in: NSMakeRect(0,0,size.width,size.height))
        ctx.setFillColor(.white)
        ctx.fill(NSMakeRect(6,11,12,2))
    })!
}
private func generateStickerBackground(_ size: NSSize, _ color: NSColor) -> CGImage {
    return generateImage(size, contextGenerator: { size,ctx in
        ctx.clear(NSMakeRect(0, 0, size.width, size.height))
        ctx.round(size)
        ctx.setFillColor(color.cgColor)
        ctx.fill(NSMakeRect(0, 0, size.width, size.height))
    })!
}


private func downloadFilePauseIcon(_ color: NSColor) -> CGImage {
    return generateImage(CGSize(width: 11.0, height: 11.0), contextGenerator: { size, context in
        context.clear(CGRect(origin: CGPoint(), size: size))
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 2.0, y: 0.0, width: 2.0, height: 11.0 - 1.0))
        context.fill(CGRect(x: 2.0 + 2.0 + 2.0, y: 0.0, width: 2.0, height: 11.0 - 1.0))
    })!
}


public func generateSendingFrame(_ color: NSColor) -> CGImage {
    return generateImage(NSMakeSize(12, 12), contextGenerator: {(size,ctx) in
        ctx.clear(NSMakeRect(0, 0, size.width, size.height))
        ctx.setStrokeColor(color.cgColor)
        ctx.setLineWidth(1.0)
        ctx.strokeEllipse(in: NSMakeRect(1.0, 1.0,size.width - 2,size.height - 2))
    })!
}
public func generateClockMinImage(_ color: NSColor) -> CGImage {
    return generateImage(CGSize(width: 10, height: 10), contextGenerator: { size, context in
        context.clear(CGRect(origin: CGPoint(), size: size))
        context.setFillColor(color.cgColor)
        let strokeWidth: CGFloat = 1
        context.fill(CGRect(x: (10 - strokeWidth) / 2.0, y: (10 - strokeWidth) / 2.0, width: 10 / 2.0 - strokeWidth, height: strokeWidth))
    })!
}


private func  generateChatScrolldownImage(backgroundColor: NSColor, borderColor: NSColor, arrowColor: NSColor, reversed: Bool = false) -> CGImage {
    let generator:(NSSize, CGContext)->Void = { size, context in
        context.clear(CGRect(origin: CGPoint(), size: size))
        
        context.setStrokeColor(arrowColor.cgColor)
        context.setLineWidth(1.0)
        let position = CGPoint(x: 9.0 - 0.5, y: 23.0)
        context.move(to: CGPoint(x: position.x + 1.0, y: position.y - 1.0))
        context.addLine(to: CGPoint(x: position.x + 10.0, y: position.y - 10.0))
        context.addLine(to: CGPoint(x: position.x + 19.0, y: position.y - 1.0))
        context.strokePath()
    }
    if !reversed {
        return generateImage(CGSize(width: 38.0, height: 38.0), contextGenerator: generator)!
    } else {
        return generateImage(CGSize(width: 38.0, height: 38.0), rotatedContext: generator)!
    }
}

private func generateConfirmDeleteMessagesAccessory(backgroundColor: NSColor) -> CGImage {
    return generateImage(NSMakeSize(50, 50), contextGenerator: { size, ctx in
        let rect = NSMakeRect(0, 0, size.width, size.height)
        ctx.clear(rect)
        ctx.round(size, size.height / 2)
        ctx.setFillColor(backgroundColor.cgColor)
        ctx.fill(rect)
        let icon = AnsibleThemeHooks.shared.image(.iconConfirmDeleteMessagesAccessory).precomposed()
        let point = NSMakePoint((rect.width - icon.backingSize.width) / 2, (rect.height - icon.backingSize.height) / 2)
        ctx.draw(icon, in: NSMakeRect(point.x, point.y, icon.backingSize.width, icon.backingSize.height))
    })!
}

private func generateConfirmPinAccessory(backgroundColor: NSColor) -> CGImage {
    return generateImage(NSMakeSize(50, 50), contextGenerator: { size, ctx in
        let rect = NSMakeRect(0, 0, size.width, size.height)
        ctx.clear(rect)
        ctx.round(size, size.height / 2)
        ctx.setFillColor(backgroundColor.cgColor)
        ctx.fill(rect)
        let icon = AnsibleThemeHooks.shared.image(.iconConfirmPinAccessory).precomposed()
        let point = NSMakePoint((rect.width - icon.backingSize.width) / 2, (rect.height - icon.backingSize.height) / 2)
        ctx.draw(icon, in: NSMakeRect(point.x, point.y, icon.backingSize.width, icon.backingSize.height))
    })!
}

private func generateConfirmDeleteChatAccessory(backgroundColor: NSColor, foregroundColor: NSColor) -> CGImage {
    return generateImage(NSMakeSize(34, 34), contextGenerator: { size, ctx in
        let rect = NSMakeRect(0, 0, size.width, size.height)
        ctx.clear(rect)
        ctx.round(size, size.height / 2)
        
        ctx.setFillColor(backgroundColor.cgColor)
        ctx.fill(rect)
        
        ctx.setFillColor(foregroundColor.cgColor)
        ctx.fillEllipse(in: NSMakeRect(2, 2, size.width - 4, size.height - 4))
        let icon = AnsibleThemeHooks.shared.image(.iconConfirmDeleteChatAccessory).precomposed()
        let point = NSMakePoint((rect.width - icon.backingSize.width) / 2, (rect.height - icon.backingSize.height) / 2)
        ctx.draw(icon, in: NSMakeRect(point.x, point.y, icon.backingSize.width, icon.backingSize.height))
    })!
}



/*

 */

private func generateRecentActionsTriangle(_ color: NSColor) -> CGImage {
    return generateImage(NSMakeSize(10, 8), contextGenerator: { (size, ctx) in
        let bounds = NSMakeRect(0, 0, size.width, size.height)
        ctx.clear(bounds)
        ctx.beginPath()
        ctx.move(to: NSMakePoint(bounds.minX, bounds.minY))
        ctx.addLine(to: NSMakePoint(bounds.midX, bounds.maxY))
        ctx.addLine(to: NSMakePoint(bounds.maxX, bounds.minY))
        ctx.closePath()
        
        ctx.setFillColor(color.cgColor);
        ctx.fillPath();
        
    }, opaque: false)!
}




public func generateIcons(from palette: ColorPalette, bubbled: Bool) -> AnsibleIconsTheme {
    return AnsibleIconsTheme(dialogMuteImage: { AnsibleThemeHooks.shared.image(.iconDialogMute).precomposed(palette.grayIcon) },
                              dialogMuteImageSelected: { AnsibleThemeHooks.shared.image(.iconDialogMute).precomposed(palette.underSelectedColor) },
                              outgoingMessageImage: { AnsibleThemeHooks.shared.image(.iconMessageCheckMark1).precomposed(palette.accentIcon, flipVertical:true) },
                                               readMessageImage: { AnsibleThemeHooks.shared.image(.iconMessageCheckmark2).precomposed(palette.accentIcon, flipVertical:true) },
                                               outgoingMessageImageSelected: { AnsibleThemeHooks.shared.image(.iconMessageCheckMark1).precomposed(palette.underSelectedColor, flipVertical:true) },
                                               readMessageImageSelected: { AnsibleThemeHooks.shared.image(.iconMessageCheckmark2).precomposed(palette.underSelectedColor, flipVertical:true) },
                                               sendingImage: { AnsibleThemeHooks.shared.image(.iconChatStateSending).precomposed(palette.grayIcon, flipVertical:true) },
                                               sendingImageSelected: { AnsibleThemeHooks.shared.image(.iconChatStateSending).precomposed(palette.underSelectedColor, flipVertical:true) },
                                               secretImage: { AnsibleThemeHooks.shared.image(.iconSecretChatLock).precomposed(palette.accent, flipVertical:true) },
                                               secretImageSelected:{  AnsibleThemeHooks.shared.image(.iconSecretChatLock).precomposed(palette.underSelectedColor, flipVertical:true) },
                                               pinnedImage: { AnsibleThemeHooks.shared.image(.iconChatListPinned).precomposed(palette.grayIcon, flipVertical:true) },
                                               pinnedImageSelected: { AnsibleThemeHooks.shared.image(.iconChatListPinned).precomposed(palette.underSelectedColor, flipVertical:true) },
                                               verifiedImage: { generateDialogVerify(background: palette.underSelectedColor, foreground: palette.basicAccent) },
                                               verifiedImageSelected: { generateDialogVerify(background: palette.underSelectedColor, foreground: palette.basicAccent) },
                                               errorImage: { AnsibleThemeHooks.shared.image(.iconMessageSentFailed).precomposed(flipVertical: true) },
                                               errorImageSelected: { AnsibleThemeHooks.shared.image(.iconDialogSendingError).precomposed(flipVertical: true) },
                                               chatSearch: { AnsibleThemeHooks.shared.image(.iconSearchChatMessages).precomposed(palette.text) },
                                               chatSearchActive: { AnsibleThemeHooks.shared.image(.iconSearchChatMessages).precomposed(palette.text.withAlphaComponent(0.8)) },
                                               chatCall: {  generateChatAction(AnsibleThemeHooks.shared.image(.iconCallNavigationHeader).precomposed(palette.accentIcon), background: palette.background)  },
                                               chatCallActive: { generateChatAction( AnsibleThemeHooks.shared.image(.iconCallNavigationHeader).precomposed(palette.accentIcon), background: palette.grayIcon.withAlphaComponent(0.1)) },
                                               chatActions: { AnsibleThemeHooks.shared.image(.iconChatActionsActive).precomposed(palette.text) },
                                               chatFailedCall_incoming: { AnsibleThemeHooks.shared.image(.iconMessageCallIncoming).precomposed(palette.redUI) },
                                               chatFailedCall_outgoing:  { AnsibleThemeHooks.shared.image(.iconMessageCallOutgoing).precomposed(palette.redUI) },
                                               chatCall_incoming:  { AnsibleThemeHooks.shared.image(.iconMessageCallIncoming).precomposed(palette.greenUI) },
                                               chatCall_outgoing:  { AnsibleThemeHooks.shared.image(.iconMessageCallOutgoing).precomposed(palette.greenUI) },
                                               chatFailedCallBubble_incoming:  { AnsibleThemeHooks.shared.image(.iconMessageCallIncoming).precomposed(palette.redBubble_incoming) },
                                               chatFailedCallBubble_outgoing:  { AnsibleThemeHooks.shared.image(.iconMessageCallOutgoing).precomposed(palette.redBubble_outgoing) },
                                               chatCallBubble_incoming:  { AnsibleThemeHooks.shared.image(.iconMessageCallIncoming).precomposed(palette.greenBubble_incoming) },
                                               chatCallBubble_outgoing:  { AnsibleThemeHooks.shared.image(.iconMessageCallOutgoing).precomposed(palette.greenBubble_outgoing) },
                                               chatFallbackCall: { AnsibleThemeHooks.shared.image(.iconMessageCall).precomposed(palette.accentIcon) },
                                               chatFallbackCallBubble_incoming: { AnsibleThemeHooks.shared.image(.iconCallNavigationHeader).precomposed(palette.textBubble_incoming) },
                                               chatFallbackCallBubble_outgoing: { AnsibleThemeHooks.shared.image(.iconCallNavigationHeader).precomposed(palette.textBubble_outgoing) },
                                               chatFallbackVideoCall: { AnsibleThemeHooks.shared.image(.iconVideoCall).precomposed(palette.accentIcon) },
                                               chatFallbackVideoCallBubble_incoming: { AnsibleThemeHooks.shared.image(.iconVideoCall).precomposed(palette.textBubble_incoming) },
                                               chatFallbackVideoCallBubble_outgoing: { AnsibleThemeHooks.shared.image(.iconVideoCall).precomposed(palette.textBubble_outgoing) },
                                               chatToggleSelected:  { generateChatGroupToggleSelected(foregroundColor: palette.accentIcon, backgroundColor: palette.underSelectedColor) },
                                               chatToggleUnselected:  { generateChatGroupToggleUnselected(foregroundColor: palette.grayIcon.withAlphaComponent(0.6), backgroundColor: NSColor.black.withAlphaComponent(0.01)) },
                                               chatMusicPlay:  { AnsibleThemeHooks.shared.image(.iconChatMusicPlay).precomposed(palette.fileActivityForeground) },
                                               chatMusicPlayBubble_incoming:  { AnsibleThemeHooks.shared.image(.iconChatMusicPlay).precomposed(palette.fileActivityForegroundBubble_incoming) },
                                               chatMusicPlayBubble_outgoing:  { AnsibleThemeHooks.shared.image(.iconChatMusicPlay).precomposed(palette.fileActivityForegroundBubble_outgoing) },
                                               chatMusicPause:  { AnsibleThemeHooks.shared.image(.iconChatMusicPause).precomposed(palette.fileActivityForeground) },
                                               chatMusicPauseBubble_incoming:  { AnsibleThemeHooks.shared.image(.iconChatMusicPause).precomposed(palette.fileActivityForegroundBubble_incoming) },
                                               chatMusicPauseBubble_outgoing:  { AnsibleThemeHooks.shared.image(.iconChatMusicPause).precomposed(palette.fileActivityForegroundBubble_outgoing) },
                                               chatGradientBubble_incoming: { generateGradientBubble([palette.bubbleBackground_incoming]) },
                                               chatGradientBubble_outgoing: { generateGradientBubble(palette.bubbleBackground_outgoing) },
                                               chatBubble_none_incoming_withInset: { messageBubbleImageModern(incoming: true, fillColor: .black, strokeColor: .clear, neighbors: .none) },
                                               chatBubble_none_outgoing_withInset: { messageBubbleImageModern(incoming: false, fillColor: .black, strokeColor: .clear, neighbors: .none) },
                                               chatBubbleBorder_none_incoming_withInset: { messageBubbleImageModern(incoming: true, fillColor: .clear, strokeColor: palette.bubbleBorder_incoming, neighbors: .none) },
                                               chatBubbleBorder_none_outgoing_withInset: { messageBubbleImageModern(incoming: false, fillColor: .clear, strokeColor: palette.bubbleBorder_outgoing, neighbors: .none) },
                                               chatBubble_both_incoming_withInset: { messageBubbleImageModern(incoming: true, fillColor: .black, strokeColor: .clear, neighbors: .both) },
                                               chatBubble_both_outgoing_withInset: { messageBubbleImageModern(incoming: false, fillColor: .black, strokeColor: .clear, neighbors: .both) },
                                               chatBubbleBorder_both_incoming_withInset: { messageBubbleImageModern(incoming: true, fillColor: .clear, strokeColor: palette.bubbleBorder_incoming, neighbors: .both) },
                                               chatBubbleBorder_both_outgoing_withInset: { messageBubbleImageModern(incoming: false, fillColor: .clear, strokeColor: palette.bubbleBorder_outgoing, neighbors: .both) },
                                               composeNewChat: { AnsibleThemeHooks.shared.image(.iconNewMessage).precomposed(palette.accentIcon) },
                                               composeNewChatActive: { AnsibleThemeHooks.shared.image(.iconNewMessage).precomposed(palette.underSelectedColor) },
                                               composeNewGroup: { AnsibleThemeHooks.shared.image(.iconNewGroup).precomposed(palette.accentIcon) },
                                               composeNewSecretChat: { AnsibleThemeHooks.shared.image(.iconNewSecretChat).precomposed(palette.accentIcon) },
                                               composeNewChannel: { AnsibleThemeHooks.shared.image(.iconNewChannel).precomposed(palette.accentIcon) },
                                               contactsNewContact: { AnsibleThemeHooks.shared.image(.iconNewContact).precomposed(palette.accentIcon) },
                                               chatReadMarkInBubble1_incoming: { AnsibleThemeHooks.shared.image(.iconMessageCheckMark1).precomposed(palette.accentIconBubble_incoming) },
                                               chatReadMarkInBubble2_incoming: { AnsibleThemeHooks.shared.image(.iconMessageCheckmark2).precomposed(palette.accentIconBubble_incoming) },
                                               chatReadMarkInBubble1_outgoing: { AnsibleThemeHooks.shared.image(.iconMessageCheckMark1).precomposed(palette.accentIconBubble_outgoing) },
                                               chatReadMarkInBubble2_outgoing: { AnsibleThemeHooks.shared.image(.iconMessageCheckmark2).precomposed(palette.accentIconBubble_outgoing) },
                                               chatReadMarkOutBubble1: { AnsibleThemeHooks.shared.image(.iconMessageCheckMark1).precomposed(palette.accentIcon) },
                                               chatReadMarkOutBubble2: { AnsibleThemeHooks.shared.image(.iconMessageCheckmark2).precomposed(palette.accentIcon) },
                                               chatReadMarkOverlayBubble1: { AnsibleThemeHooks.shared.image(.iconMessageCheckMark1).precomposed(.white) },
                                               chatReadMarkOverlayBubble2: { AnsibleThemeHooks.shared.image(.iconMessageCheckmark2).precomposed(.white) },
                                               sentFailed: { generateImage(NSMakeSize(13, 13), contextGenerator: { size, ctx in
                                                    ctx.clear(NSMakeRect(0, 0, size.width, size.height))
                                                    ctx.draw(AnsibleThemeHooks.shared.image(.iconMessageSentFailed).precomposed(), in: NSMakeRect(0, 0, size.width, size.height))
                                               })! },
                                               chatChannelViewsInBubble_incoming: { AnsibleThemeHooks.shared.image(.iconChannelViews).precomposed(palette.grayIconBubble_incoming) },
                                               chatChannelViewsInBubble_outgoing: { AnsibleThemeHooks.shared.image(.iconChannelViews).precomposed(palette.grayIconBubble_outgoing) },
                                               chatChannelViewsOutBubble: { AnsibleThemeHooks.shared.image(.iconChannelViews).precomposed(palette.grayIcon) },
                                               chatChannelViewsOverlayBubble: { AnsibleThemeHooks.shared.image(.iconChannelViews).precomposed(.white) },
                                               chatPaidMessageInBubble_incoming: { AnsibleThemeHooks.shared.image(.iconPaidMessageStatus).precomposed(palette.grayIconBubble_incoming) },
                                               chatPaidMessageInBubble_outgoing: { AnsibleThemeHooks.shared.image(.iconPaidMessageStatus).precomposed(palette.grayIconBubble_outgoing) },
                                               chatPaidMessageOutBubble: { AnsibleThemeHooks.shared.image(.iconPaidMessageStatus).precomposed(palette.grayIcon) },
                                               chatPaidMessageOverlayBubble: { AnsibleThemeHooks.shared.image(.iconPaidMessageStatus).precomposed(.white) },
                                               chatNavigationBack: { AnsibleThemeHooks.shared.image(.iconChatNavigationBack).precomposed(palette.accentIcon) },
                                               peerInfoAddMember: { AnsibleThemeHooks.shared.image(.iconNewContact).precomposed(palette.accentIcon, flipVertical: true) },
                                               chatSearchUp: { AnsibleThemeHooks.shared.image(.iconSearchArrow).precomposed(palette.accentIcon) },
                                               chatSearchUpDisabled: { AnsibleThemeHooks.shared.image(.iconSearchArrow).precomposed(palette.grayIcon) },
                                               chatSearchDown: { AnsibleThemeHooks.shared.image(.iconSearchArrow).precomposed(palette.accentIcon, flipVertical:true) },
                                               chatSearchDownDisabled: { AnsibleThemeHooks.shared.image(.iconSearchArrow).precomposed(palette.grayIcon, flipVertical:true) },
                                               chatSearchCalendar: { AnsibleThemeHooks.shared.image(.iconCalendar).precomposed(palette.accentIcon) },
                                               dismissAccessory: { AnsibleThemeHooks.shared.image(.iconChatSearchCancel).precomposed(palette.grayIcon) },
                                               chatScrollUp: { generateChatScrolldownImage(backgroundColor: palette.background, borderColor: palette.chatBackground == palette.background && palette.isDark ? palette.grayIcon : .clear, arrowColor: palette.text) },
                                               chatScrollUpActive: { generateChatScrolldownImage(backgroundColor: palette.background, borderColor: palette.chatBackground == palette.background && palette.isDark ? palette.accentIcon : .clear, arrowColor: palette.text) },
                                               chatScrollDown: { generateChatScrolldownImage(backgroundColor: palette.background, borderColor: palette.chatBackground == palette.background && palette.isDark ? palette.grayIcon : .clear, arrowColor: palette.text, reversed: true) },
                                               chatScrollDownActive: { generateChatScrolldownImage(backgroundColor: palette.background, borderColor: palette.chatBackground == palette.background && palette.isDark ? palette.accentIcon : .clear, arrowColor: palette.text, reversed: true) },
                                               chatSendMessage: { AnsibleThemeHooks.shared.image(.iconSendMessage).precomposed(palette.accentIcon) },
                                               chatSaveEditedMessage: { generateSendIcon(AnsibleThemeHooks.shared.image(.iconSaveEditedMessage), palette.accentIcon) },
                                               chatRecordVoice: { AnsibleThemeHooks.shared.image(.iconRecordVoice).precomposed(palette.grayIcon) },
                                               chatEntertainment: { AnsibleThemeHooks.shared.image(.iconEntertainments).precomposed(palette.darkGrayText) },
                                               chatInlineDismiss: { AnsibleThemeHooks.shared.image(.iconInlineResultCancel).precomposed(palette.darkGrayText) },
                                               chatActiveReplyMarkup: { AnsibleThemeHooks.shared.image(.iconReplyMarkupButton).precomposed(palette.accentIcon) },
                                               chatDisabledReplyMarkup: { AnsibleThemeHooks.shared.image(.iconReplyMarkupButton).precomposed(palette.darkGrayText) },
                                               chatSecretTimer: { AnsibleThemeHooks.shared.image(.iconSecretTimer).precomposed(palette.darkGrayText) },
                                               chatForwardMessagesActive: { AnsibleThemeHooks.shared.image(.iconMessageActionPanelForward).precomposed(palette.accentIcon) },
                                               chatForwardMessagesInactive: { AnsibleThemeHooks.shared.image(.iconMessageActionPanelForward).precomposed(palette.grayIcon) },
                                               chatDeleteMessagesActive: { AnsibleThemeHooks.shared.image(.iconMessageActionPanelDelete).precomposed(palette.redUI) },
                                               chatDeleteMessagesInactive: { AnsibleThemeHooks.shared.image(.iconMessageActionPanelDelete).precomposed(palette.grayIcon) },
                                               generalNext: { AnsibleThemeHooks.shared.image(.iconGeneralNext).precomposed(palette.grayIcon.withAlphaComponent(0.5)) },
                                               generalNextActive: { AnsibleThemeHooks.shared.image(.iconGeneralNext).precomposed(.white) },
                                               generalSelect: { AnsibleThemeHooks.shared.image(.iconUsernameAvailability).precomposed(palette.accentIcon) },
                                               chatVoiceRecording: { AnsibleThemeHooks.shared.image(.iconRecordingVoice).precomposed(palette.accentIcon) },
                                               chatVideoRecording: { AnsibleThemeHooks.shared.image(.iconRecordVideoMessage).precomposed(palette.accentIcon) },
                                               chatRecord: { AnsibleThemeHooks.shared.image(.iconRecordVoice).precomposed(palette.grayIcon) },
                                               deleteItem: { deleteItemIcon(palette.redUI) },
                                               deleteItemDisabled: { deleteItemIcon(palette.grayText) },
                                               chatAttach: { AnsibleThemeHooks.shared.image(.iconChatAttach).precomposed(palette.grayIcon) },
                                               chatAttachFile: { AnsibleThemeHooks.shared.image(.iconAttachFile).precomposed(palette.accentIcon) },
                                               chatAttachPhoto: { AnsibleThemeHooks.shared.image(.iconAttachPhoto).precomposed(palette.accentIcon) },
                                               chatAttachCamera: { AnsibleThemeHooks.shared.image(.iconAttachCamera).precomposed(palette.accentIcon) },
                                               chatAttachLocation: { AnsibleThemeHooks.shared.image(.iconAttachLocation).precomposed(palette.accentIcon) },
                                               chatAttachPoll: { AnsibleThemeHooks.shared.image(.iconAttachPoll).precomposed(palette.accentIcon) },
                                               mediaEmptyShared: { AnsibleThemeHooks.shared.image(.iconEmptySharedMedia).precomposed(palette.grayIcon) },
                                               mediaEmptyFiles: { AnsibleThemeHooks.shared.image(.iconEmptySharedFiles).precomposed() },
                                               mediaEmptyMusic: { AnsibleThemeHooks.shared.image(.iconEmptySharedMusic).precomposed(palette.grayIcon) },
                                               mediaEmptyLinks: { AnsibleThemeHooks.shared.image(.iconEmptySharedLinks).precomposed(palette.grayIcon) },
                                               stickersAddFeatured: { AnsibleThemeHooks.shared.image(.iconGroupInfoAddMember).precomposed(palette.accentIcon) },
                                               stickersAddedFeatured: { AnsibleThemeHooks.shared.image(.iconUsernameAvailability).precomposed(palette.grayIcon) },
                                               stickersRemove: { AnsibleThemeHooks.shared.image(.iconInlineResultCancel).precomposed(palette.grayIcon) },
                                               peerMediaDownloadFileStart: { AnsibleThemeHooks.shared.image(.iconMediaDownload).precomposed(palette.accentIcon) },
                                               peerMediaDownloadFilePause: { downloadFilePauseIcon(palette.accentIcon) },
                                               stickersShare: { AnsibleThemeHooks.shared.image(.iconShareStickerPack).precomposed(palette.accentIcon) },
                                               emojiRecentTab: { AnsibleThemeHooks.shared.image(.iconEmojiTabRecent).precomposed(palette.grayIcon.withAlphaComponent(0.8)) },
                                               emojiSmileTab: { AnsibleThemeHooks.shared.image(.iconEmojiTabSmiles).precomposed(palette.grayIcon.withAlphaComponent(0.8)) },
                                               emojiNatureTab: { AnsibleThemeHooks.shared.image(.iconEmojiTabNature).precomposed(palette.grayIcon.withAlphaComponent(0.8)) },
                                               emojiFoodTab: { AnsibleThemeHooks.shared.image(.iconEmojiTabFood).precomposed(palette.grayIcon.withAlphaComponent(0.8)) },
                                               emojiSportTab: { AnsibleThemeHooks.shared.image(.iconEmojiTabSports).precomposed(palette.grayIcon.withAlphaComponent(0.8)) },
                                               emojiCarTab: { AnsibleThemeHooks.shared.image(.iconEmojiTabCar).precomposed(palette.grayIcon.withAlphaComponent(0.8)) },
                                               emojiObjectsTab: { AnsibleThemeHooks.shared.image(.iconEmojiTabObjects).precomposed(palette.grayIcon.withAlphaComponent(0.8)) },
                                               emojiSymbolsTab: { AnsibleThemeHooks.shared.image(.iconEmojiTabSymbols).precomposed(palette.grayIcon.withAlphaComponent(0.8)) },
                                               emojiFlagsTab: { AnsibleThemeHooks.shared.image(.iconEmojiTabFlag).precomposed(palette.grayIcon.withAlphaComponent(0.8)) },
                                               emojiRecentTabActive: { AnsibleThemeHooks.shared.image(.iconEmojiTabRecent).precomposed(palette.grayIcon.darker()) },
                                               emojiSmileTabActive: { AnsibleThemeHooks.shared.image(.iconEmojiTabSmiles).precomposed(palette.grayIcon.darker()) },
                                               emojiNatureTabActive: { AnsibleThemeHooks.shared.image(.iconEmojiTabNature).precomposed(palette.grayIcon.darker()) },
                                               emojiFoodTabActive: { AnsibleThemeHooks.shared.image(.iconEmojiTabFood).precomposed(palette.grayIcon.darker()) },
                                               emojiSportTabActive: { AnsibleThemeHooks.shared.image(.iconEmojiTabSports).precomposed(palette.grayIcon.darker()) },
                                               emojiCarTabActive: { AnsibleThemeHooks.shared.image(.iconEmojiTabCar).precomposed(palette.grayIcon.darker()) },
                                               emojiObjectsTabActive: { AnsibleThemeHooks.shared.image(.iconEmojiTabObjects).precomposed(palette.grayIcon.darker()) },
                                               emojiSymbolsTabActive: { AnsibleThemeHooks.shared.image(.iconEmojiTabSymbols).precomposed(palette.grayIcon.darker()) },
                                               emojiFlagsTabActive: { AnsibleThemeHooks.shared.image(.iconEmojiTabFlag).precomposed(palette.grayIcon.darker()) },
                                               stickerBackground: { generateStickerBackground(NSMakeSize(83, 83), palette.background) },
                                               stickerBackgroundActive: { generateStickerBackground(NSMakeSize(83, 83), palette.grayBackground) },
                                               stickersTabRecent: { AnsibleThemeHooks.shared.image(.iconEmojiTabRecent).precomposed(palette.grayIcon) },
                                               stickersTabGIF: { AnsibleThemeHooks.shared.image(.iconGifToggle).precomposed(palette.grayIcon) },
                                               chatSendingInFrame_incoming: { generateSendingFrame(palette.grayIconBubble_incoming) },
                                               chatSendingInHour_incoming: { generateClockMinImage(palette.grayIconBubble_incoming) },
                                               chatSendingInMin_incoming: { generateClockMinImage(palette.grayIconBubble_incoming) },
                                               chatSendingInFrame_outgoing: { generateSendingFrame(palette.grayIconBubble_outgoing) },
                                               chatSendingInHour_outgoing: { generateClockMinImage(palette.grayIconBubble_outgoing) },
                                               chatSendingInMin_outgoing: { generateClockMinImage(palette.grayIconBubble_outgoing) },
                                               chatSendingOutFrame: { generateSendingFrame(palette.grayIcon) },
                                               chatSendingOutHour: { generateClockMinImage(palette.grayIcon) },
                                               chatSendingOutMin: { generateClockMinImage(palette.grayIcon) },
                                               chatSendingOverlayFrame: { generateSendingFrame(.white) },
                                               chatSendingOverlayHour: { generateClockMinImage(.white) },
                                               chatSendingOverlayMin: { generateClockMinImage(.white) },
                                               chatActionUrl: { AnsibleThemeHooks.shared.image(.iconInlineBotUrl).precomposed(palette.text) },
                                               callInlineDecline: { AnsibleThemeHooks.shared.image(.iconCallDeclineInline).precomposed(.white) },
                                               callInlineMuted: { AnsibleThemeHooks.shared.image(.iconCallMuteInline).precomposed(.white) },
                                               callInlineUnmuted: { AnsibleThemeHooks.shared.image(.iconCallUnmutedInline).precomposed(.white) },
                                               eventLogTriangle: { generateRecentActionsTriangle(palette.text) },
                                               channelIntro: { AnsibleThemeHooks.shared.image(.iconChannelIntro).precomposed() },
                                               chatFileThumb: { AnsibleThemeHooks.shared.image(.iconMessageFile).precomposed(flipVertical:true) },
                                               chatFileThumbBubble_incoming: { AnsibleThemeHooks.shared.image(.iconMessageFile).precomposed(palette.fileActivityForegroundBubble_incoming,  flipVertical:true) },
                                               chatFileThumbBubble_outgoing: { AnsibleThemeHooks.shared.image(.iconMessageFile).precomposed(palette.fileActivityForegroundBubble_outgoing, flipVertical:true) },
                                               chatSecretThumb: { generateSecretThumb(AnsibleThemeHooks.shared.image(.iconSecretAutoremoveMedia).precomposed(.black, flipVertical:true)) },
                                               chatSecretThumbSmall: { generateSecretThumbSmall(AnsibleThemeHooks.shared.image(.iconSecretAutoremoveMedia).precomposed(.black, flipVertical:true)) },
                                               chatMapPin: { AnsibleThemeHooks.shared.image(.iconMapPinned).precomposed() },
                                               chatSecretTitle: { AnsibleThemeHooks.shared.image(.iconSecretChatLock).precomposed(palette.text, flipVertical:true) },
                                               emptySearch: { AnsibleThemeHooks.shared.image(.iconEmptySearchResults).precomposed(palette.grayIcon) },
                                               calendarBack: { AnsibleThemeHooks.shared.image(.iconNavigationBack).precomposed(palette.accentIcon) },
                                               calendarNext: { AnsibleThemeHooks.shared.image(.iconNavigationBack).precomposed(palette.accentIcon, flipHorizontal: true) },
                                               calendarBackDisabled: { AnsibleThemeHooks.shared.image(.iconNavigationBack).precomposed(palette.grayIcon) },
                                               calendarNextDisabled: { AnsibleThemeHooks.shared.image(.iconNavigationBack).precomposed(palette.grayIcon, flipHorizontal: true) },
                                               newChatCamera: { AnsibleThemeHooks.shared.image(.iconAttachCamera).precomposed(palette.grayIcon) },
                                               peerInfoVerify: { generateDialogVerify(background: palette.underSelectedColor, foreground: palette.basicAccent, reversed: true) },
                                               peerInfoVerifyProfile: { generateDialogVerify(background: palette.underSelectedColor, foreground: palette.basicAccent, reversed: true) },
                                               peerInfoCall: { AnsibleThemeHooks.shared.image(.iconProfileCall).precomposed(palette.accent) },
                                               callOutgoing: { AnsibleThemeHooks.shared.image(.iconCallOutgoing).precomposed(palette.grayIcon, flipVertical: true) },
                                               recentDismiss: { AnsibleThemeHooks.shared.image(.iconSearchRemoveRecent).precomposed(palette.grayIcon) },
                                               recentDismissActive: { AnsibleThemeHooks.shared.image(.iconSearchRemoveRecent).precomposed(palette.underSelectedColor) },
                                               webgameShare: { AnsibleThemeHooks.shared.image(.iconShareStickerPack).precomposed(palette.accentIcon) },
                                               chatSearchCancel: { AnsibleThemeHooks.shared.image(.iconChatSearchCancel).precomposed(palette.accentIcon) },
                                               chatSearchFrom: { AnsibleThemeHooks.shared.image(.iconChatSearchFrom).precomposed(palette.accentIcon) },
                                               callWindowDecline: { AnsibleThemeHooks.shared.image(.iconCallDeclineWindow).precomposed(.white) },
                                               callWindowDeclineSmall: { AnsibleThemeHooks.shared.image(.iconCallDeclineSmallWindow).precomposed(.white) },
                                               callWindowAccept: { AnsibleThemeHooks.shared.image(.iconCallAcceptWindow).precomposed(.white) },
                                               callWindowVideo: { AnsibleThemeHooks.shared.image(.iconCallVideoWindow).precomposed(.white) },
                                               callWindowVideoActive: { AnsibleThemeHooks.shared.image(.iconCallVideoWindow).precomposed(.grayIcon) },
                                               callWindowMute: { AnsibleThemeHooks.shared.image(.iconCallMutedWindow).precomposed(.white) },
                                               callWindowMuteActive: { AnsibleThemeHooks.shared.image(.iconCallMutedWindow).precomposed(.grayIcon) },
                                               callWindowClose: { AnsibleThemeHooks.shared.image(.iconCallWindowClose).precomposed(.white) },
                                               callWindowDeviceSettings: { AnsibleThemeHooks.shared.image(.iconCallDeviceSettings).precomposed(.white) },
                                               callSettings: { AnsibleThemeHooks.shared.image(.iconCallDeviceSettings).precomposed(palette.accentIcon) },
                                               callWindowCancel: { AnsibleThemeHooks.shared.image(.iconCallCancelIcon).precomposed(.white) },
                                               chatActionEdit: { AnsibleThemeHooks.shared.image(.iconChatActionEdit).precomposed(palette.accentIcon) },
                                               chatActionInfo: { AnsibleThemeHooks.shared.image(.iconChatActionInfo).precomposed(palette.accentIcon) },
                                               chatActionMute: { AnsibleThemeHooks.shared.image(.iconChatActionMute).precomposed(palette.accentIcon) },
                                               chatActionUnmute: { AnsibleThemeHooks.shared.image(.iconChatActionUnmute).precomposed(palette.accentIcon) },
                                               chatActionClearHistory: { AnsibleThemeHooks.shared.image(.iconClearChat).precomposed(palette.accentIcon) },
                                               chatActionDeleteChat: { AnsibleThemeHooks.shared.image(.iconMessageActionPanelDelete).precomposed(palette.accentIcon) },
                                               dismissPinned: { AnsibleThemeHooks.shared.image(.iconChatSearchCancel).precomposed(palette.accentIcon) },
                                               chatActionsActive: { generateChatAction(AnsibleThemeHooks.shared.image(.iconChatActionsActive).precomposed(palette.accentIcon), background: palette.grayIcon.withAlphaComponent(0.1)) },
                                               chatEntertainmentSticker: { AnsibleThemeHooks.shared.image(.iconChatEntertainmentSticker).precomposed(palette.darkGrayText) },
                                               chatEmpty: { AnsibleThemeHooks.shared.image(.iconEmptyChat).precomposed(palette.grayForeground) },
                                               stickerPackClose: { AnsibleThemeHooks.shared.image(.iconChatSearchCancel).precomposed(palette.accentIcon) },
                                               stickerPackDelete: { AnsibleThemeHooks.shared.image(.iconMessageActionPanelDelete).precomposed(palette.accentIcon) },
                                               modalShare: { AnsibleThemeHooks.shared.image(.iconShareStickerPack).precomposed(palette.accentIcon) },
                                               modalClose: { AnsibleThemeHooks.shared.image(.iconChatSearchCancel).precomposed(palette.accentIcon) },
                                               glass_close: { AnsibleThemeHooks.shared.image(.iconPipClose).precomposed(palette.text) },
                                               ivChannelJoined: { AnsibleThemeHooks.shared.image(.iconMessageCheckMark1).precomposed(.white) },
                                               chatListMention: { generateBadgeMention(image: AnsibleThemeHooks.shared.image(.iconChatListMention), backgroundColor: palette.badge, foregroundColor: palette.background) },
                                              chatListMentionActive: { generateBadgeMention(image: AnsibleThemeHooks.shared.image(.iconChatListMention), backgroundColor: palette.underSelectedColor, foregroundColor: palette.accentSelect) },
                                               chatListMentionArchived: { generateBadgeMention(image: AnsibleThemeHooks.shared.image(.iconChatListMention), backgroundColor: palette.badgeMuted, foregroundColor: palette.background) },
                                               chatListMentionArchivedActive: { generateBadgeMention(image: AnsibleThemeHooks.shared.image(.iconChatListMention), backgroundColor: palette.underSelectedColor, foregroundColor: palette.accentSelect) },
                                               chatListPollBadge: { generateBadgeMention(image: AnsibleThemeHooks.shared.image(.iconChatListPollBadge), backgroundColor: palette.badge, foregroundColor: palette.background) },
                                               chatListPollBadgeActive: { generateBadgeMention(image: AnsibleThemeHooks.shared.image(.iconChatListPollBadge), backgroundColor: palette.underSelectedColor, foregroundColor: palette.accentSelect) },
                                               chatListPollBadgeArchived: { generateBadgeMention(image: AnsibleThemeHooks.shared.image(.iconChatListPollBadge), backgroundColor: palette.badgeMuted, foregroundColor: palette.background) },
                                               chatListPollBadgeArchivedActive: { generateBadgeMention(image: AnsibleThemeHooks.shared.image(.iconChatListPollBadge), backgroundColor: palette.underSelectedColor, foregroundColor: palette.accentSelect) },
                                               chatMention: { generateChatMention(image: AnsibleThemeHooks.shared.image(.iconChatMention), backgroundColor: palette.background, border: palette.grayIcon, foregroundColor: palette.text) },
                                               chatMentionActive: { generateChatMention(image: AnsibleThemeHooks.shared.image(.iconChatMention), backgroundColor: palette.background, border: palette.accentIcon, foregroundColor: palette.text) },
                                               sliderControl: { AnsibleThemeHooks.shared.image(.iconSliderNormal).precomposed() },
                                               sliderControlActive: { AnsibleThemeHooks.shared.image(.iconSliderNormal).precomposed() },
                                               chatInstantView: { AnsibleThemeHooks.shared.image(.iconChatIV).precomposed(palette.webPreviewActivity) },
                                               chatInstantViewBubble_incoming: { AnsibleThemeHooks.shared.image(.iconChatIV).precomposed(palette.webPreviewActivityBubble_incoming) },
                                               chatInstantViewBubble_outgoing: { AnsibleThemeHooks.shared.image(.iconChatIV).precomposed(palette.webPreviewActivityBubble_outgoing) },
                                               instantViewShare: { AnsibleThemeHooks.shared.image(.iconShareStickerPack).precomposed(palette.accentIcon) },
                                               instantViewActions: { AnsibleThemeHooks.shared.image(.iconChatActions).precomposed(palette.accentIcon) },
                                               instantViewActionsActive: { AnsibleThemeHooks.shared.image(.iconChatActionsActive).precomposed(palette.accentIcon) },
                                               instantViewSafari: { AnsibleThemeHooks.shared.image(.iconInstantViewSafari).precomposed(palette.accentIcon) },
                                               instantViewBack: { AnsibleThemeHooks.shared.image(.iconInstantViewBack).precomposed(palette.accentIcon) },
                                               instantViewCheck: { AnsibleThemeHooks.shared.image(.iconInstantViewCheck).precomposed(palette.accentIcon) },
                                               groupStickerNotFound: { AnsibleThemeHooks.shared.image(.iconGroupStickerNotFound).precomposed(palette.grayIcon) },
                                               settingsAskQuestion: { generateSettingsIcon(AnsibleThemeHooks.shared.image(.iconSettingsAskQuestion).precomposed(flipVertical: true)) },
                                               settingsFaq: { generateSettingsIcon(AnsibleThemeHooks.shared.image(.iconSettingsFaq).precomposed(flipVertical: true)) },
                                               settingsStories: { generateSettingsIcon(AnsibleThemeHooks.shared.image(.iconSettingsStories).precomposed(flipVertical: true)) },
                                                settingsGeneral: { generateSettingsIcon(AnsibleThemeHooks.shared.image(.iconSettingsGeneral).precomposed(flipVertical: true)) },
                                               settingsLanguage: { generateSettingsIcon(AnsibleThemeHooks.shared.image(.iconSettingsLanguage).precomposed(flipVertical: true)) },
                                               settingsNotifications: { generateSettingsIcon(AnsibleThemeHooks.shared.image(.iconSettingsNotifications).precomposed(flipVertical: true)) },
                                               settingsSecurity: { generateSettingsIcon(AnsibleThemeHooks.shared.image(.iconSettingsSecurity).precomposed(flipVertical: true)) },
                                               settingsStickers: { generateSettingsIcon(AnsibleThemeHooks.shared.image(.iconSettingsStickers).precomposed(flipVertical: true)) },
                                               settingsStorage: { generateSettingsIcon(AnsibleThemeHooks.shared.image(.iconSettingsStorage).precomposed(flipVertical: true)) },
                                               settingsSessions: { generateSettingsIcon(AnsibleThemeHooks.shared.image(.iconPrivacySettingsActiveSessions).precomposed(flipVertical: true)) },
                                               settingsProxy: { generateSettingsIcon(AnsibleThemeHooks.shared.image(.iconSettingsProxy).precomposed(flipVertical: true)) },
                                               settingsAppearance: { generateSettingsIcon(AnsibleThemeHooks.shared.image(.iconAppearanceSettings).precomposed(flipVertical: true)) },
                                               settingsPassport: { generateSettingsIcon(AnsibleThemeHooks.shared.image(.iconSettingsSecurity).precomposed(flipVertical: true)) },
                                               settingsUpdate: { generateSettingsIcon(AnsibleThemeHooks.shared.image(.iconSettingsUpdate).precomposed(flipVertical: true)) },
                                               settingsFilters: { generateSettingsIcon(AnsibleThemeHooks.shared.image(.iconSettingsFilters).precomposed(flipVertical: true)) },
                                               settingsPremium: { generatePremiumIcon(AnsibleThemeHooks.shared.image(.iconPremiumSettings).precomposed(flipVertical: true)) },
                                               settingsGiftPremium: { generateSettingsIcon(AnsibleThemeHooks.shared.image(.iconSettingsGiftPremium).precomposed(flipVertical: true)) },
                                               settingsAskQuestionActive: { generateSettingsActiveIcon(AnsibleThemeHooks.shared.image(.iconSettingsAskQuestion).precomposed(palette.underSelectedColor, flipVertical: true), background: palette.accentSelect) },
                                               settingsFaqActive: { generateSettingsActiveIcon(AnsibleThemeHooks.shared.image(.iconSettingsFaq).precomposed(palette.underSelectedColor, flipVertical: true), background: palette.accentSelect) },
                                               settingsStoriesActive: { generateSettingsActiveIcon(AnsibleThemeHooks.shared.image(.iconSettingsStories).precomposed(palette.underSelectedColor, flipVertical: true), background: palette.accentSelect) },
                                               settingsGeneralActive: { generateSettingsActiveIcon(AnsibleThemeHooks.shared.image(.iconSettingsGeneral).precomposed(palette.underSelectedColor, flipVertical: true), background: palette.accentSelect) },
                                               settingsLanguageActive: { generateSettingsActiveIcon(AnsibleThemeHooks.shared.image(.iconSettingsLanguage).precomposed(palette.underSelectedColor, flipVertical: true), background: palette.accentSelect) },
                                               settingsNotificationsActive: { generateSettingsActiveIcon(AnsibleThemeHooks.shared.image(.iconSettingsNotifications).precomposed(palette.underSelectedColor, flipVertical: true), background: palette.accentSelect) },
                                               settingsSecurityActive: { generateSettingsActiveIcon(AnsibleThemeHooks.shared.image(.iconSettingsSecurity).precomposed(palette.underSelectedColor, flipVertical: true), background: palette.accentSelect) },
                                               settingsStickersActive: { generateSettingsActiveIcon(AnsibleThemeHooks.shared.image(.iconSettingsStickers).precomposed(palette.underSelectedColor, flipVertical: true), background: palette.accentSelect) },
                                               settingsStorageActive: { generateSettingsActiveIcon(AnsibleThemeHooks.shared.image(.iconSettingsStorage).precomposed(palette.underSelectedColor, flipVertical: true), background: palette.accentSelect) },
                                               settingsSessionsActive: { generateSettingsActiveIcon(AnsibleThemeHooks.shared.image(.iconPrivacySettingsActiveSessions).precomposed(palette.underSelectedColor, flipVertical: true), background: palette.accentSelect) },
                                               settingsProxyActive: { generateSettingsActiveIcon(AnsibleThemeHooks.shared.image(.iconSettingsProxy).precomposed(palette.underSelectedColor, flipVertical: true), background: palette.accentSelect) },
                                               settingsAppearanceActive: { generateSettingsActiveIcon(AnsibleThemeHooks.shared.image(.iconAppearanceSettings).precomposed(palette.underSelectedColor, flipVertical: true), background: palette.accentSelect) },
                                               settingsPassportActive: { generateSettingsActiveIcon(AnsibleThemeHooks.shared.image(.iconSettingsSecurity).precomposed(palette.underSelectedColor, flipVertical: true), background: palette.accentSelect) },
                                               settingsUpdateActive: { generateSettingsActiveIcon(AnsibleThemeHooks.shared.image(.iconSettingsUpdate).precomposed(palette.underSelectedColor, flipVertical: true), background: palette.accentSelect) },
                                               settingsFiltersActive: { generateSettingsActiveIcon(AnsibleThemeHooks.shared.image(.iconSettingsFilters).precomposed(palette.underSelectedColor, flipVertical: true), background: palette.accentSelect) },
                                               settingsProfile: { generateSettingsIcon(AnsibleThemeHooks.shared.image(.iconSettingsProfile).precomposed(flipVertical: true)) },
                                               settingsBusiness: { generateSettingsIcon(AnsibleThemeHooks.shared.image(.iconSettingsBusiness).precomposed(flipVertical: true)) },
                                               settingsBusinessActive: { generateSettingsActiveIcon(AnsibleThemeHooks.shared.image(.iconSettingsBusiness).precomposed(palette.underSelectedColor, flipVertical: true), background: palette.accentSelect) },
                                               settingsStars: { generateSettingsIcon(AnsibleThemeHooks.shared.image(.iconSettingsStars).precomposed(flipVertical: true)) },
                                               generalCheck: { AnsibleThemeHooks.shared.image(.iconCheck).precomposed(palette.accentIcon) },
                                               settingsAbout: { AnsibleThemeHooks.shared.image(.iconSettingsAbout).precomposed(palette.accentIcon) },
                                               settingsLogout: { AnsibleThemeHooks.shared.image(.iconSettingsLogout).precomposed(palette.redUI) },
                                               fastSettingsLock: { AnsibleThemeHooks.shared.image(.iconFastSettingsLock).precomposed(palette.accentIcon) },
                                               fastSettingsDark: { AnsibleThemeHooks.shared.image(.iconFastSettingsDark).precomposed(palette.accentIcon) },
                                               fastSettingsSunny: { AnsibleThemeHooks.shared.image(.iconFastSettingsSunny).precomposed(palette.accentIcon) },
                                               fastSettingsMute: { AnsibleThemeHooks.shared.image(.iconChatActionMute).precomposed(palette.accentIcon) },
                                               fastSettingsUnmute: { AnsibleThemeHooks.shared.image(.iconChatActionUnmute).precomposed(palette.accentIcon) },
                                               chatRecordVideo: { AnsibleThemeHooks.shared.image(.iconRecordVideoMessage).precomposed(palette.grayIcon) },
                                               inputChannelMute: { AnsibleThemeHooks.shared.image(.iconInputChannelMute).precomposed(palette.darkGrayText) },
                                               inputChannelUnmute: { AnsibleThemeHooks.shared.image(.iconInputChannelUnmute).precomposed(palette.darkGrayText) },
                                               changePhoneNumberIntro: { AnsibleThemeHooks.shared.image(.iconChangeNumberIntro).precomposed() },
                                               peerSavedMessages: { AnsibleThemeHooks.shared.image(.iconSavedMessages).precomposed() },
                                               previewSenderCollage: { AnsibleThemeHooks.shared.image(.iconPreviewCollage).precomposed(palette.grayIcon) },
                                               previewSenderPhoto: { AnsibleThemeHooks.shared.image(.iconPreviewSenderPhoto).precomposed(palette.grayIcon) },
                                               previewSenderFile: { AnsibleThemeHooks.shared.image(.iconPreviewSenderFile).precomposed(palette.grayIcon) },
                                               previewSenderCrop: { AnsibleThemeHooks.shared.image(.iconPreviewSenderCrop).precomposed(.white) },
                                               previewSenderDelete: { AnsibleThemeHooks.shared.image(.iconPreviewSenderDelete).precomposed(.white) },
                                               previewSenderDeleteFile: { AnsibleThemeHooks.shared.image(.iconPreviewSenderDelete).precomposed(palette.accentIcon) },
                                               previewSenderArchive: { AnsibleThemeHooks.shared.image(.iconPreviewSenderArchive).precomposed(palette.grayIcon) },
                                               chatGroupToggleSelected: { generateChatGroupToggleSelected(foregroundColor: palette.accentIcon, backgroundColor: palette.underSelectedColor) },
                                               chatGroupToggleUnselected: { generateChatGroupToggleUnselected(foregroundColor: palette.grayIcon.withAlphaComponent(0.6), backgroundColor: NSColor.black.withAlphaComponent(0.01)) },
                                               successModalProgress: { AnsibleThemeHooks.shared.image(.iconProgressWindowCheck).precomposed(palette.grayIcon) },
                                               accentColorSelect: { AnsibleThemeHooks.shared.image(.iconUsernameAvailability).precomposed(.white) },
                                               transparentBackground: { generateTransparentBackground() },
                                               lottieTransparentBackground: { generateLottieTransparentBackground() },
                                               passcodeTouchId: { AnsibleThemeHooks.shared.image(.iconTouchId).precomposed(palette.underSelectedColor) },
                                               passcodeLogin: { AnsibleThemeHooks.shared.image(.iconPasscodeLogin).precomposed(palette.underSelectedColor) },
                                               confirmDeleteMessagesAccessory: { generateConfirmDeleteMessagesAccessory(backgroundColor: palette.redUI) },
                                               alertCheckBoxSelected: { generateAlertCheckBoxSelected(backgroundColor: palette.accentIcon) },
                                               alertCheckBoxUnselected: { generateAlertCheckBoxUnselected(border: palette.grayIcon) },
                                               confirmPinAccessory: { generateConfirmPinAccessory(backgroundColor: palette.accentIcon) },
                                               confirmDeleteChatAccessory: { generateConfirmDeleteChatAccessory(backgroundColor: palette.background, foregroundColor: palette.redUI) },
                                               stickersEmptySearch: { generateStickersEmptySearch(color: palette.grayIcon) },
                                               twoStepVerificationCreateIntro: { AnsibleThemeHooks.shared.image(.iconTwoStepVerificationCreate).precomposed() },
                                               secureIdAuth: { AnsibleThemeHooks.shared.image(.iconSecureIdAuth).precomposed() },
                                               ivAudioPlay: { generateIVAudioPlay(color: palette.text) },
                                               ivAudioPause: { generateIVAudioPause(color: palette.text) },
                                               proxyEnable: { AnsibleThemeHooks.shared.image(.iconProxyEnable).precomposed(palette.accent) },
                                               proxyEnabled: { AnsibleThemeHooks.shared.image(.iconProxyEnabled).precomposed(palette.accent) },
                                               proxyState: { AnsibleThemeHooks.shared.image(.iconProxyState).precomposed(palette.accent) },
                                               proxyDeleteListItem: { AnsibleThemeHooks.shared.image(.iconMessageActionPanelDelete).precomposed(palette.accentIcon) },
                                               proxyInfoListItem: { AnsibleThemeHooks.shared.image(.iconDetailedInfo).precomposed(palette.accentIcon) },
                                               proxyConnectedListItem: { AnsibleThemeHooks.shared.image(.iconUsernameAvailability).precomposed(palette.accentIcon) },
                                               proxyAddProxy: { AnsibleThemeHooks.shared.image(.iconGroupInfoAddMember).precomposed(palette.accentIcon, flipVertical: true) },
                                               proxyNextWaitingListItem: { AnsibleThemeHooks.shared.image(.iconUsernameAvailability).precomposed(palette.grayIcon) },
                                               passportForgotPassword: { AnsibleThemeHooks.shared.image(.iconSecureIdForgotPassword).precomposed(palette.grayIcon) },
                                               confirmAppAccessoryIcon: { AnsibleThemeHooks.shared.image(.iconConfirmAppAccessory).precomposed() },
                                               passportPassport: { AnsibleThemeHooks.shared.image(.iconPassportPassport).precomposed(palette.accentIcon, flipVertical: true) },
                                               passportIdCardReverse: { AnsibleThemeHooks.shared.image(.iconPassportIdCardReverse).precomposed(palette.accentIcon, flipVertical: true) },
                                               passportIdCard: { AnsibleThemeHooks.shared.image(.iconPassportIdCard).precomposed(palette.accentIcon, flipVertical: true) },
                                               passportSelfie: { AnsibleThemeHooks.shared.image(.iconPassportSelfie).precomposed(palette.accentIcon, flipVertical: true) },
                                               passportDriverLicense: { AnsibleThemeHooks.shared.image(.iconPassportDriverLicense).precomposed(palette.accentIcon, flipVertical: true) },
                                               chatOverlayVoiceRecording: { AnsibleThemeHooks.shared.image(.iconRecordingVoice).precomposed(.white) },
                                               chatOverlayVideoRecording: { AnsibleThemeHooks.shared.image(.iconRecordVideoMessage).precomposed(.white) },
                                               chatOverlaySendRecording: { AnsibleThemeHooks.shared.image(.iconChatOverlayRecordingSend).precomposed(.white) },
                                               chatOverlayLockArrowRecording: { AnsibleThemeHooks.shared.image(.iconDropdownArrow).precomposed(palette.accentIcon, flipVertical: true) },
                                               chatOverlayLockerBodyRecording: { generateLockerBody(palette.accentIcon, backgroundColor: palette.background) },
                                               chatOverlayLockerHeadRecording: { generateLockerHead(palette.accentIcon, backgroundColor: palette.background) },
                                               locationPin: { generateLocationPinIcon(palette.accentIcon) },
                                               locationMapPin: { generateLocationMapPinIcon(palette.accentIcon) },
                                               locationMapLocate: { AnsibleThemeHooks.shared.image(.iconMapLocate).precomposed(palette.grayIcon) },
                                               locationMapLocated: { AnsibleThemeHooks.shared.image(.iconMapLocate).precomposed(palette.accentIcon) },
                                               passportSettings: { AnsibleThemeHooks.shared.image(.iconPassportSettings).precomposed(palette.grayIcon) },
                                               passportInfo: { AnsibleThemeHooks.shared.image(.iconSettingsBio).precomposed(palette.accentIcon) },
                                               editMessageMedia: { generateEditMessageMediaIcon(AnsibleThemeHooks.shared.image(.iconReplaceMessageMedia).precomposed(palette.accentIcon), background: palette.background) },
                                               playerMusicPlaceholder: { generatePlayerListAlbumPlaceholder(AnsibleThemeHooks.shared.image(.iconMusicPlayerSmallAlbumArtPlaceholder).precomposed(palette.listGrayText), background: palette.listBackground, radius: .cornerRadius) },
                                               chatMusicPlaceholder: { generatePlayerListAlbumPlaceholder(AnsibleThemeHooks.shared.image(.iconMusicPlayerSmallAlbumArtPlaceholder).precomposed(palette.fileActivityForeground), background: palette.fileActivityBackground, radius: 20) },
                                               chatMusicPlaceholderCap: { generatePlayerListAlbumPlaceholder(nil, background: palette.fileActivityBackground, radius: 20) },
                                               searchArticle: { AnsibleThemeHooks.shared.image(.iconSearchArticles).precomposed(.white) },
                                               searchSaved: { AnsibleThemeHooks.shared.image(.iconSearchSaved).precomposed(.white) },
                                               archivedChats: { AnsibleThemeHooks.shared.image(.iconArchiveAvatar).precomposed(.white) },
                                               hintPeerActive: { generateHitActiveIcon(activeColor: palette.accent, backgroundColor: palette.background) },
                                               hintPeerActiveSelected: { generateHitActiveIcon(activeColor: palette.underSelectedColor, backgroundColor: palette.accentSelect) },
                                               chatSwiping_delete: { AnsibleThemeHooks.shared.image(.iconChatSwipingDelete).precomposed(.white) },
                                               chatSwiping_mute: { AnsibleThemeHooks.shared.image(.iconChatSwipingMute).precomposed(.white) },
                                               chatSwiping_unmute: { AnsibleThemeHooks.shared.image(.iconChatSwipingUnmute).precomposed(.white) },
                                               chatSwiping_read: { AnsibleThemeHooks.shared.image(.iconChatSwipingRead).precomposed(.white) },
                                               chatSwiping_unread: { AnsibleThemeHooks.shared.image(.iconChatSwipingUnread).precomposed(.white) },
                                               chatSwiping_pin: { AnsibleThemeHooks.shared.image(.iconChatSwipingPin).precomposed(.white) },
                                               chatSwiping_unpin: { AnsibleThemeHooks.shared.image(.iconChatSwipingUnpin).precomposed(.white) },
                                               chatSwiping_archive: { AnsibleThemeHooks.shared.image(.iconChatListSwipingArchive).precomposed(.white) },
                                               chatSwiping_unarchive: { AnsibleThemeHooks.shared.image(.iconChatListSwipingUnarchive).precomposed(.white) },
                                               galleryPrev: { AnsibleThemeHooks.shared.image(.iconGalleryPrev).precomposed(.white) },
                                               galleryNext: { AnsibleThemeHooks.shared.image(.iconGalleryNext).precomposed(.white) },
                                               galleryMore: { AnsibleThemeHooks.shared.image(.iconGalleryMore).precomposed(.white) },
                                               galleryShare: { AnsibleThemeHooks.shared.image(.iconGalleryShare).precomposed(.white) },
                                               galleryFastSave: { AnsibleThemeHooks.shared.image(.iconGalleryFastSave).precomposed(.white) },
                                               galleryRotate: {AnsibleThemeHooks.shared.image(.iconGalleryRotate).precomposed(.white) },
                                               galleryZoomIn: {AnsibleThemeHooks.shared.image(.iconGalleryZoomIn).precomposed(.white) },
                                               galleryZoomOut: { AnsibleThemeHooks.shared.image(.iconGalleryZoomOut).precomposed(.white) },
                                               editMessageCurrentPhoto: { AnsibleThemeHooks.shared.image(.iconEditMessageCurrentPhoto).precomposed(palette.accentIcon) },
                                               videoPlayerPlay: { AnsibleThemeHooks.shared.image(.iconVideoPlayerPlay).precomposed(.white) },
                                               videoPlayerPause: { AnsibleThemeHooks.shared.image(.iconVideoPlayerPause).precomposed(.white) },
                                               videoPlayerEnterFullScreen: { AnsibleThemeHooks.shared.image(.iconVideoPlayerEnterFullScreen).precomposed(.white) },
                                               videoPlayerExitFullScreen: { AnsibleThemeHooks.shared.image(.iconVideoPlayerExitFullScreen).precomposed(.white) },
                                               videoPlayerPIPIn: { AnsibleThemeHooks.shared.image(.iconVideoPlayerPIPIN).precomposed(.white) },
                                               videoPlayerPIPOut: { AnsibleThemeHooks.shared.image(.iconVideoPlayerPIPOUT).precomposed(.white) },
                                               videoPlayerRewind15Forward: { AnsibleThemeHooks.shared.image(.iconVideoPlayerRewind15Forward).precomposed(.white) },
                                               videoPlayerRewind15Backward: { AnsibleThemeHooks.shared.image(.iconVideoPlayerRewind15Backward).precomposed(.white) },
                                               videoPlayerVolume: { AnsibleThemeHooks.shared.image(.iconVideoPlayerVolume).precomposed(.white) },
                                               videoPlayerVolumeOff: { AnsibleThemeHooks.shared.image(.iconVideoPlayerVolumeOff).precomposed(.white) },
                                               videoPlayerClose: { AnsibleThemeHooks.shared.image(.iconVideoPlayerClose).precomposed(.white) },
                                               videoPlayerSliderInteractor: { AnsibleThemeHooks.shared.image(.iconSlider).precomposed() },
                                               streamingVideoDownload: { AnsibleThemeHooks.shared.image(.iconStreamingDownload).precomposed(.white) },
                                               videoCompactFetching: { AnsibleThemeHooks.shared.image(.iconVideoCompactFetching).precomposed(.white) },
                                               compactStreamingFetchingCancel: { AnsibleThemeHooks.shared.image(.iconCompactStreamingFetchingCancel).precomposed(.white) },
                                               customLocalizationDelete: { AnsibleThemeHooks.shared.image(.iconMessageActionPanelDelete).precomposed(palette.accentIcon) },
                                               pollAddOption: { generatePollAddOption(palette.accentIcon) },
                                               pollDeleteOption: { generatePollDeleteOption(palette.redUI) },
                                               resort: { AnsibleThemeHooks.shared.image(.iconResort).precomposed(palette.grayIcon.withAlphaComponent(0.6)) },
                                               chatPollVoteUnselected: { AnsibleThemeHooks.shared.image(.iconSelectionUncheck).precomposed(palette.grayText.withAlphaComponent(0.3)) },
                                               chatPollVoteUnselectedBubble_incoming: { AnsibleThemeHooks.shared.image(.iconSelectionUncheck).precomposed(palette.grayTextBubble_incoming.withAlphaComponent(0.3)) },
                                               chatPollVoteUnselectedBubble_outgoing: { AnsibleThemeHooks.shared.image(.iconSelectionUncheck).precomposed(palette.grayTextBubble_outgoing.withAlphaComponent(0.3)) },
                                               peerInfoAdmins: { AnsibleThemeHooks.shared.image(.iconChatAdmins).precomposed(flipVertical: true) },
                                               peerInfoRecentActions: { AnsibleThemeHooks.shared.image(.iconProfileRecentLog).precomposed(flipVertical: true) },
                                               peerInfoPermissions: { AnsibleThemeHooks.shared.image(.iconChatPermissions).precomposed(flipVertical: true) },
                                               peerInfoBanned: { AnsibleThemeHooks.shared.image(.iconChatBanned).precomposed(flipVertical: true) },
                                               peerInfoMembers: { AnsibleThemeHooks.shared.image(.iconChatMembers).precomposed(flipVertical: true) },
                                               peerInfoStarsBalance: { AnsibleThemeHooks.shared.image(.iconPeerInfoStarsBalance).precomposed(flipVertical: true) },
                                               peerInfoBalance: { AnsibleThemeHooks.shared.image(.iconPeerInfoBalance).precomposed(flipVertical: true) },
                                               peerInfoBotUsername: { AnsibleThemeHooks.shared.image(.iconPeerInfoBotUsername).precomposed(flipVertical: true) },
                                               chatUndoAction: { AnsibleThemeHooks.shared.image(.iconChatUndoAction).precomposed(NSColor(0x29ACFF)) },
                                               appUpdate: { AnsibleThemeHooks.shared.image(.iconAppUpdate).precomposed() },
                                               inlineVideoSoundOff: { AnsibleThemeHooks.shared.image(.iconInlineVideoSoundOff).precomposed() },
                                               inlineVideoSoundOn: { AnsibleThemeHooks.shared.image(.iconInlineVideoSoundOn).precomposed() },
                                               logoutOptionAddAccount: { generateSettingsIcon(AnsibleThemeHooks.shared.image(.iconLogoutOptionAddAccount).precomposed(flipVertical: true)) },
                                               logoutOptionSetPasscode: { generateSettingsIcon(AnsibleThemeHooks.shared.image(.iconLogoutOptionSetPasscode).precomposed(flipVertical: true)) },
                                               logoutOptionClearCache: { generateSettingsIcon(AnsibleThemeHooks.shared.image(.iconLogoutOptionClearCache).precomposed(flipVertical: true)) },
                                               logoutOptionChangePhoneNumber: { generateSettingsIcon(AnsibleThemeHooks.shared.image(.iconLogoutOptionChangePhoneNumber).precomposed(flipVertical: true)) },
                                               logoutOptionContactSupport: { generateSettingsIcon(AnsibleThemeHooks.shared.image(.iconLogoutOptionContactSupport).precomposed(flipVertical: true)) },
                                               disableEmojiPrediction: { AnsibleThemeHooks.shared.image(.iconCallWindowClose).precomposed(palette.grayIcon) },
                                               scam: { generateScamIconReversed(foregroundColor: palette.redUI, backgroundColor: .clear) },
                                               scamActive: { generateScamIconReversed(foregroundColor: palette.underSelectedColor, backgroundColor: .clear) },
                                               chatScam: { generateScamIconReversed(foregroundColor: palette.redUI, backgroundColor: .clear) },
                                               fake: { generateFakeIconReversed(foregroundColor: palette.redUI, backgroundColor: .clear) },
                                               fakeActive: { generateFakeIconReversed(foregroundColor: palette.underSelectedColor, backgroundColor: .clear) },
                                               chatFake: { generateFakeIconReversed(foregroundColor: palette.redUI, backgroundColor: .clear) },
                                               chatUnarchive: { AnsibleThemeHooks.shared.image(.iconChatUnarchive).precomposed(palette.accentIcon) },
                                               chatArchive: { AnsibleThemeHooks.shared.image(.iconChatArchive).precomposed(palette.accentIcon) },
                                               privacySettings_blocked: { generateSettingsIcon(AnsibleThemeHooks.shared.image(.iconPrivacySettingsBlocked).precomposed(flipVertical: true)) },
                                               privacySettings_activeSessions: { generateSettingsIcon(AnsibleThemeHooks.shared.image(.iconPrivacySettingsActiveSessions).precomposed(flipVertical: true)) },
                                               privacySettings_passcode: { generateSettingsIcon(AnsibleThemeHooks.shared.image(.iconSettingsSecurity).precomposed(palette.greenUI, flipVertical: true)) },
                                               privacySettings_twoStep: { generateSettingsIcon(AnsibleThemeHooks.shared.image(.iconPrivacySettingsTwoStep).precomposed(flipVertical: true)) },
                                               privacy_settings_autodelete: { generateSettingsIcon(AnsibleThemeHooks.shared.image(.iconPrivacySettingsAutoDelete).precomposed(flipVertical: true)) },
                                               deletedAccount: { AnsibleThemeHooks.shared.image(.iconDeletedAccount).precomposed() },
                                               stickerPackSelection: { generateStickerPackSelection(.clear) },
                                               stickerPackSelectionActive: { generateStickerPackSelection(palette.grayForeground.withAlphaComponent(0.8)) },
                                               entertainment_Emoji: { AnsibleThemeHooks.shared.image(.iconEntertainmentEmoji).precomposed(palette.grayIcon) },
                                               entertainment_Stickers: { AnsibleThemeHooks.shared.image(.iconEntertainmentStickers).precomposed(palette.grayIcon) },
                                               entertainment_Gifs: { AnsibleThemeHooks.shared.image(.iconEntertainmentGifs).precomposed(palette.grayIcon) },
                                               entertainment_Search: { AnsibleThemeHooks.shared.image(.iconEntertainmentSearch).precomposed(palette.grayIcon) },
                                               entertainment_Settings: { AnsibleThemeHooks.shared.image(.iconEntertainmentSettings).precomposed(palette.grayIcon) },
                                               entertainment_SearchCancel: { AnsibleThemeHooks.shared.image(.iconEntertainmentSearchCancel).precomposed(palette.grayIcon) },
                                               entertainment_AnimatedEmoji:  { AnsibleThemeHooks.shared.image(.iconEntertainmentEmoji).precomposed(palette.grayIcon) },
                                               scheduledAvatar: { AnsibleThemeHooks.shared.image(.iconAvatarScheduled).precomposed(.white) },
                                               scheduledInputAction: { AnsibleThemeHooks.shared.image(.iconChatActionScheduled).precomposed(palette.accentIcon) },
                                               verifyDialog: { generateDialogVerify(background: palette.underSelectedColor, foreground: palette.basicAccent, reversed: true) },
                                               verifyDialogActive: { generateDialogVerify(background: palette.accentIcon, foreground: palette.underSelectedColor, reversed: true) },
                                              verify_dialog_left: { generateDialogVerifyLeft(background: palette.underSelectedColor, foreground: palette.basicAccent, reversed: true) },
                                              verify_dialog_active_left: { generateDialogVerifyLeft(background: palette.accentIcon, foreground: palette.underSelectedColor, reversed: true) },
                                               chatInputScheduled: { AnsibleThemeHooks.shared.image(.iconChatInputScheduled).precomposed(palette.darkGrayText) },
                                               appearanceAddPlatformTheme: {
                                                let image = AnsibleThemeHooks.shared.image(.iconAppearanceAddTheme).precomposed(palette.accentIcon)
                                                return generateImage(image.backingSize, contextGenerator: { size, ctx in
                                                    ctx.clear(NSMakeRect(0, 0, size.width, size.height))
                                                    ctx.draw(image, in: NSMakeRect(0, 0, size.width, size.height))
                                                })! },
                                               qrCode: { AnsibleThemeHooks.shared.image(.iconQrCode).precomposed(palette.accentIcon) },
                                               wallpaper_color_close: { AnsibleThemeHooks.shared.image(.iconGradientClose).precomposed(palette.grayIcon) },
                                               wallpaper_color_add: { AnsibleThemeHooks.shared.image(.iconGradientAdd).precomposed(palette.grayIcon) },
                                               wallpaper_color_swap: { AnsibleThemeHooks.shared.image(.iconGradientSwap).precomposed(palette.grayIcon) },
                                               wallpaper_color_rotate: { AnsibleThemeHooks.shared.image(.iconGradientRotate).precomposed(.white) },
                                               wallpaper_color_play: { AnsibleThemeHooks.shared.image(.iconChatMusicPlay).precomposed(.white) },
                                               login_cap: { AnsibleThemeHooks.shared.image(.iconLoginCap).precomposed(palette.accentIcon) },
                                               login_qr_cap: { AnsibleThemeHooks.shared.image(.iconLoginQRCap).precomposed(palette.accentIcon) },
                                               login_qr_empty_cap: { generateLoginQrEmptyCap() },
                                               chat_failed_scroller: { generateChatFailed(backgroundColor: palette.background, border: palette.redUI, foregroundColor: palette.redUI) },
                                               chat_failed_scroller_active: { generateChatFailed(backgroundColor: palette.background, border: palette.accentIcon, foregroundColor: palette.text) },
                                               poll_quiz_unselected: { generateUnslectedCap(palette.grayText) },
                                               poll_selected: { generatePollIcon(AnsibleThemeHooks.shared.image(.iconPollSelected), backgound: palette.webPreviewActivity) },
                                               poll_selection: { generatePollIcon(AnsibleThemeHooks.shared.image(.iconPollSelected), backgound: palette.webPreviewActivity) },
                                               poll_selected_correct: { generatePollIcon(AnsibleThemeHooks.shared.image(.iconPollSelected), backgound: palette.greenUI) },
                                               poll_selected_incorrect: { generatePollIcon(AnsibleThemeHooks.shared.image(.iconPollSelectedIncorrect), backgound: palette.redUI) },
                                               poll_selected_incoming: { generatePollIcon(AnsibleThemeHooks.shared.image(.iconPollSelected), backgound: palette.webPreviewActivityBubble_incoming) },
                                               poll_selection_incoming: { generatePollIcon(AnsibleThemeHooks.shared.image(.iconPollSelected), backgound: palette.webPreviewActivityBubble_incoming) },
                                               poll_selected_correct_incoming: { generatePollIcon(AnsibleThemeHooks.shared.image(.iconPollSelected), backgound: palette.greenBubble_incoming) },
                                               poll_selected_incorrect_incoming: { generatePollIcon(AnsibleThemeHooks.shared.image(.iconPollSelectedIncorrect), backgound: palette.redBubble_incoming) },
                                               poll_selected_outgoing: { generatePollIcon(AnsibleThemeHooks.shared.image(.iconPollSelected), backgound: palette.webPreviewActivityBubble_outgoing) },
                                               poll_selection_outgoing: { generatePollIcon(AnsibleThemeHooks.shared.image(.iconPollSelected), backgound: palette.webPreviewActivityBubble_outgoing) },
                                               poll_selected_correct_outgoing: { generatePollIcon(AnsibleThemeHooks.shared.image(.iconPollSelected), backgound: palette.greenBubble_outgoing) },
                                               poll_selected_incorrect_outgoing: { generatePollIcon(AnsibleThemeHooks.shared.image(.iconPollSelectedIncorrect), backgound: palette.redBubble_outgoing) },
                                               poll_square_unselected: { generatePollSquareUnselected(palette.grayText) },
                                               poll_square_unselected_incoming: { generatePollSquareUnselected(palette.grayTextBubble_incoming) },
                                               poll_square_unselected_outgoing: { generatePollSquareUnselected(palette.grayTextBubble_outgoing) },
                                               poll_square_selected: { generatePollSquareIcon(AnsibleThemeHooks.shared.image(.iconPollSelected), backgound: palette.webPreviewActivity) },
                                               poll_square_selected_incoming: { generatePollSquareIcon(AnsibleThemeHooks.shared.image(.iconPollSelected), backgound: palette.webPreviewActivityBubble_incoming) },
                                               poll_square_selected_outgoing: { generatePollSquareIcon(AnsibleThemeHooks.shared.image(.iconPollSelected), backgound: palette.webPreviewActivityBubble_outgoing) },
                                               poll_square_selection: { generatePollSquareIcon(AnsibleThemeHooks.shared.image(.iconPollSelected), backgound: palette.webPreviewActivity) },
                                               poll_square_selection_incoming: { generatePollSquareIcon(AnsibleThemeHooks.shared.image(.iconPollSelected), backgound: palette.webPreviewActivityBubble_incoming) },
                                               poll_square_selection_outgoing: { generatePollSquareIcon(AnsibleThemeHooks.shared.image(.iconPollSelected), backgound: palette.webPreviewActivityBubble_outgoing) },
                                               chat_filter_edit: { AnsibleThemeHooks.shared.image(.iconFilterEdit).precomposed(palette.accentIcon) },
                                               chat_filter_add: { AnsibleThemeHooks.shared.image(.iconFilterAdd).precomposed(palette.accentIcon) },
                                               chat_filter_bots:  { AnsibleThemeHooks.shared.image(.iconFilterBots).precomposed(palette.accentIcon) },
                                               chat_filter_channels:  { AnsibleThemeHooks.shared.image(.iconFilterChannels).precomposed(palette.accentIcon) },
                                               chat_filter_custom:  { AnsibleThemeHooks.shared.image(.iconFilterCustom).precomposed(palette.accentIcon) },
                                               chat_filter_groups:  { AnsibleThemeHooks.shared.image(.iconFilterGroups).precomposed(palette.accentIcon) },
                                               chat_filter_muted: { AnsibleThemeHooks.shared.image(.iconFilterMuted).precomposed(palette.accentIcon) },
                                               chat_filter_private_chats: { AnsibleThemeHooks.shared.image(.iconFilterPrivateChats).precomposed(palette.accentIcon) },
                                               chat_filter_read: { AnsibleThemeHooks.shared.image(.iconFilterRead).precomposed(palette.accentIcon) },
                                               chat_filter_secret_chats: { AnsibleThemeHooks.shared.image(.iconFilterSecretChats).precomposed(palette.accentIcon) },
                                               chat_filter_unmuted: { AnsibleThemeHooks.shared.image(.iconFilterUnmuted).precomposed(palette.accentIcon) },
                                               chat_filter_unread: { AnsibleThemeHooks.shared.image(.iconFilterUnread).precomposed(palette.accentIcon) },
                                               chat_filter_large_groups: { AnsibleThemeHooks.shared.image(.iconFilterLargeGroups).precomposed(palette.accentIcon) },
                                               chat_filter_non_contacts: { AnsibleThemeHooks.shared.image(.iconFilterNonContacts).precomposed(palette.accentIcon) },
                                               chat_filter_archive: { AnsibleThemeHooks.shared.image(.iconFilterArchive).precomposed(palette.accentIcon) },
                                               chat_filter_bots_avatar:  { AnsibleThemeHooks.shared.image(.iconFilterBots).precomposed(.white) },
                                               chat_filter_channels_avatar:  { AnsibleThemeHooks.shared.image(.iconFilterChannels).precomposed(.white) },
                                               chat_filter_custom_avatar:  { AnsibleThemeHooks.shared.image(.iconFilterCustom).precomposed(.white) },
                                               chat_filter_groups_avatar:  { AnsibleThemeHooks.shared.image(.iconFilterGroups).precomposed(.white) },
                                               chat_filter_muted_avatar: { AnsibleThemeHooks.shared.image(.iconFilterMuted).precomposed(.white) },
                                               chat_filter_private_chats_avatar: { AnsibleThemeHooks.shared.image(.iconFilterPrivateChats).precomposed(.white) },
                                               chat_filter_read_avatar: { AnsibleThemeHooks.shared.image(.iconFilterRead).precomposed(.white) },
                                               chat_filter_secret_chats_avatar: { AnsibleThemeHooks.shared.image(.iconFilterSecretChats).precomposed(.white) },
                                               chat_filter_unmuted_avatar: { AnsibleThemeHooks.shared.image(.iconFilterUnmuted).precomposed(.white) },
                                               chat_filter_unread_avatar: { AnsibleThemeHooks.shared.image(.iconFilterUnread).precomposed(.white) },
                                               chat_filter_large_groups_avatar: { AnsibleThemeHooks.shared.image(.iconFilterLargeGroups).precomposed(.white) },
                                               chat_filter_non_contacts_avatar: { AnsibleThemeHooks.shared.image(.iconFilterNonContacts).precomposed(.white) },
                                               chat_filter_archive_avatar: { AnsibleThemeHooks.shared.image(.iconFilterArchive).precomposed(.white) },
                                               chat_filter_new_chats: { AnsibleThemeHooks.shared.image(.iconFilterNewChats).precomposed(.white) },
                                               chat_filter_existing_chats: { AnsibleThemeHooks.shared.image(.iconFilterExistingChats).precomposed(.white) },
                                               group_invite_via_link: { AnsibleThemeHooks.shared.image(.iconInviteViaLink).precomposed(palette.accentIcon) },
                                               tab_contacts: { AnsibleThemeHooks.shared.image(.iconTabContacts).precomposed(palette.grayIcon) },
                                               tab_contacts_active: { AnsibleThemeHooks.shared.image(.iconTabContacts).precomposed(palette.accentIcon) },
                                               tab_calls: { AnsibleThemeHooks.shared.image(.iconTabRecentCalls).precomposed(palette.grayIcon) },
                                               tab_calls_active: { AnsibleThemeHooks.shared.image(.iconTabRecentCalls).precomposed(palette.accentIcon) },
                                               tab_chats: { AnsibleThemeHooks.shared.image(.iconTabChatList).precomposed(palette.grayIcon) },
                                               tab_chats_active: { AnsibleThemeHooks.shared.image(.iconTabChatList).precomposed(palette.accentIcon) },
                                               tab_chats_active_filters: { generateChatTabFiltersIcon(AnsibleThemeHooks.shared.image(.iconTabChatList).precomposed(palette.accentIcon)) },
                                               tab_settings: { AnsibleThemeHooks.shared.image(.iconTabSettings).precomposed(palette.grayIcon) },
                                               tab_settings_active: { AnsibleThemeHooks.shared.image(.iconTabSettings).precomposed(palette.accentIcon) },
                                               profile_add_member: { generateProfileIcon(AnsibleThemeHooks.shared.image(.iconProfileAddMember).precomposed(palette.accentIcon), backgroundColor: palette.accent) },
                                               profile_call: { generateProfileIcon(AnsibleThemeHooks.shared.image(.iconProfileCallNew).precomposed(palette.accentIcon), backgroundColor: palette.accent) },
                                               profile_video_call: { generateProfileIcon(AnsibleThemeHooks.shared.image(.iconProfileVideoCall).precomposed(palette.accentIcon), backgroundColor: palette.accent) },
                                               profile_leave: { generateProfileIcon(AnsibleThemeHooks.shared.image(.iconProfileLeave).precomposed(palette.accentIcon), backgroundColor: palette.accent) },
                                               profile_message: { generateProfileIcon(AnsibleThemeHooks.shared.image(.iconProfileMessage).precomposed(palette.accentIcon), backgroundColor: palette.accent) },
                                               profile_more: { generateProfileIcon(AnsibleThemeHooks.shared.image(.iconProfileMore).precomposed(palette.accentIcon), backgroundColor: palette.accent) },
                                               profile_mute: { generateProfileIcon(AnsibleThemeHooks.shared.image(.iconProfileMute).precomposed(palette.accentIcon), backgroundColor: palette.accent) },
                                               profile_unmute: { generateProfileIcon(AnsibleThemeHooks.shared.image(.iconProfileUnmute).precomposed(palette.accentIcon), backgroundColor: palette.accent) },
                                               profile_search: { generateProfileIcon(AnsibleThemeHooks.shared.image(.iconProfileSearch).precomposed(palette.accentIcon), backgroundColor: palette.accent) },
                                               profile_secret_chat: { generateProfileIcon(AnsibleThemeHooks.shared.image(.iconProfileSecretChat).precomposed(palette.accentIcon), backgroundColor: palette.accent) },
                                               profile_edit_photo: { AnsibleThemeHooks.shared.image(.iconProfileEditPhoto).precomposed(.white)},
                                               profile_block: { generateProfileIcon(AnsibleThemeHooks.shared.image(.iconProfileBlock).precomposed(palette.accentIcon), backgroundColor: palette.accent) },
                                               profile_report: { generateProfileIcon(AnsibleThemeHooks.shared.image(.iconProfileReport).precomposed(palette.accentIcon), backgroundColor: palette.accent) },
                                               profile_share: { generateProfileIcon(AnsibleThemeHooks.shared.image(.iconProfileShare).precomposed(palette.accentIcon), backgroundColor: palette.accent) },
                                               profile_stats: { generateProfileIcon(AnsibleThemeHooks.shared.image(.iconProfileStats).precomposed(palette.accentIcon), backgroundColor: palette.accent) },
                                               profile_unblock: { generateProfileIcon(AnsibleThemeHooks.shared.image(.iconProfileUnblock).precomposed(palette.accentIcon), backgroundColor: palette.accent) },
                                               profile_translate: { generateProfileIcon(AnsibleThemeHooks.shared.image(.iconProfileTranslate).precomposed(palette.accentIcon), backgroundColor: palette.accent) },
                                               profile_join_channel: { generateProfileIcon(AnsibleThemeHooks.shared.image(.iconProfileJoinChannel).precomposed(palette.accentIcon), backgroundColor: palette.accent) },
                                               profile_boost: { generateProfileIcon(AnsibleThemeHooks.shared.image(.iconProfileBoost).precomposed(palette.accentIcon), backgroundColor: palette.accent) },
                                               profile_archive: { generateProfileIcon(AnsibleThemeHooks.shared.image(.iconProfileArchive).precomposed(palette.accentIcon), backgroundColor: palette.accent) },
                                               stats_boost_boost: { generateProfileIcon(AnsibleThemeHooks.shared.image(.iconBoostBoost).precomposed(palette.accentIcon), backgroundColor: palette.accent) },
                                               stats_boost_giveaway: { generateProfileIcon(AnsibleThemeHooks.shared.image(.iconBoostGift).precomposed(palette.accentIcon), backgroundColor: palette.accent) },
                                               stats_boost_info: { generateProfileIcon(AnsibleThemeHooks.shared.image(.iconBoostInfo).precomposed(palette.accentIcon), backgroundColor: palette.accent) },

                                               chat_quiz_explanation: { AnsibleThemeHooks.shared.image(.iconQuizExplanation).precomposed(palette.accentIcon) },
                                               chat_quiz_explanation_bubble_incoming: { AnsibleThemeHooks.shared.image(.iconQuizExplanation).precomposed(palette.accentIconBubble_incoming) },
                                               chat_quiz_explanation_bubble_outgoing: { AnsibleThemeHooks.shared.image(.iconQuizExplanation).precomposed(palette.accentIconBubble_outgoing) },
                                               stickers_add_featured: { AnsibleThemeHooks.shared.image(.iconAddFeaturedStickers).precomposed(palette.grayIcon.withAlphaComponent(0.8)) },
                                               stickers_add_featured_unread: { generateUnreadFeaturedStickers(AnsibleThemeHooks.shared.image(.iconAddFeaturedStickers).precomposed(palette.grayIcon.withAlphaComponent(0.8)), palette.redUI) },
                                               stickers_add_featured_active: { AnsibleThemeHooks.shared.image(.iconAddFeaturedStickers).precomposed(palette.grayIcon.darker()) },
                                               stickers_add_featured_unread_active: { generateUnreadFeaturedStickers(AnsibleThemeHooks.shared.image(.iconAddFeaturedStickers).precomposed(palette.grayIcon.darker()), palette.redUI) },
                                               stickers_favorite: { AnsibleThemeHooks.shared.image(.iconFaveStickers).precomposed(palette.grayIcon.withAlphaComponent(0.8)) },
                                               stickers_favorite_active: { AnsibleThemeHooks.shared.image(.iconFaveStickers).precomposed(palette.grayIcon.darker()) },
                                               channel_info_promo: { AnsibleThemeHooks.shared.image(.iconChannelPromoInfo).precomposed(palette.grayIcon) },
                                               channel_info_promo_bubble_incoming: { AnsibleThemeHooks.shared.image(.iconChannelPromoInfo).precomposed(palette.grayTextBubble_incoming) },
                                               channel_info_promo_bubble_outgoing: { AnsibleThemeHooks.shared.image(.iconChannelPromoInfo).precomposed(palette.grayTextBubble_outgoing) },
                                               chat_share_message: {  AnsibleThemeHooks.shared.image(.iconChannelShare).precomposed(palette.accent) },
                                               chat_goto_message: { AnsibleThemeHooks.shared.image(.iconChatGoMessage).precomposed(palette.accentIcon) },
                                               chat_swipe_reply: { AnsibleThemeHooks.shared.image(.iconChannelShare).precomposed(palette.accentIcon, flipHorizontal: true) },
                                               chat_like_message: { AnsibleThemeHooks.shared.image(.iconLikeMessageButton).precomposed(palette.accentIcon) },
                                               chat_like_message_unlike: { AnsibleThemeHooks.shared.image(.iconLikeMessageButtonUnlike).precomposed(palette.accentIcon) },
                                               chat_like_inside: { AnsibleThemeHooks.shared.image(.iconLikeMessageInside).precomposed(palette.redUI, flipVertical: true) },
                                               chat_like_inside_bubble_incoming: { AnsibleThemeHooks.shared.image(.iconLikeMessageInside).precomposed(palette.redBubble_incoming, flipVertical: true) },
                                               chat_like_inside_bubble_outgoing: { AnsibleThemeHooks.shared.image(.iconLikeMessageInside).precomposed(palette.redBubble_outgoing, flipVertical: true) },
                                               chat_like_inside_bubble_overlay: { AnsibleThemeHooks.shared.image(.iconLikeMessageInside).precomposed(.white, flipVertical: true) },
                                               chat_like_inside_empty: { AnsibleThemeHooks.shared.image(.iconLikeMessageInsideEmpty).precomposed(palette.grayIcon, flipVertical: true) },
                                               chat_like_inside_empty_bubble_incoming: { AnsibleThemeHooks.shared.image(.iconLikeMessageInsideEmpty).precomposed(palette.grayIconBubble_incoming, flipVertical: true) },
                                               chat_like_inside_empty_bubble_outgoing: { AnsibleThemeHooks.shared.image(.iconLikeMessageInsideEmpty).precomposed(palette.grayIconBubble_outgoing, flipVertical: true) },
                                               chat_like_inside_empty_bubble_overlay: { AnsibleThemeHooks.shared.image(.iconLikeMessageInsideEmpty).precomposed(.white, flipVertical: true) },
                                               gif_trending: { AnsibleThemeHooks.shared.image(.iconGifTrending).precomposed(palette.grayIcon.withAlphaComponent(0.8)) },
                                               gif_trending_active: { AnsibleThemeHooks.shared.image(.iconGifTrending).precomposed(palette.grayIcon.darker()) },
                                               gif_recent: { AnsibleThemeHooks.shared.image(.iconEmojiTabRecent).precomposed(palette.grayIcon.withAlphaComponent(0.8)) },
                                               gif_recent_active: { AnsibleThemeHooks.shared.image(.iconEmojiTabRecent).precomposed(palette.grayIcon.darker()) },
                                               chat_list_thumb_play: { AnsibleThemeHooks.shared.image(.iconChatListThumbPlay).precomposed() },
                                               call_tooltip_battery_low: { AnsibleThemeHooks.shared.image(.iconCallBatteryLow).precomposed(.white) },
                                               call_tooltip_camera_off: { AnsibleThemeHooks.shared.image(.iconCallCameraOff).precomposed(.white) },
                                               call_tooltip_micro_off: { AnsibleThemeHooks.shared.image(.iconCallMicroOff).precomposed(.white) },
                                               call_screen_sharing: { AnsibleThemeHooks.shared.image(.iconCallScreenSharing).precomposed(.white) },
                                               call_screen_sharing_active: { AnsibleThemeHooks.shared.image(.iconCallScreenSharing).precomposed(.grayIcon) },
                                               call_screen_settings: { AnsibleThemeHooks.shared.image(.iconCallScreenSettings).precomposed(.white) },
                                               search_filter: { AnsibleThemeHooks.shared.image(.iconSearchFilter).precomposed(palette.grayIcon) },
                                               search_filter_media: { AnsibleThemeHooks.shared.image(.iconSearchFilterMedia).precomposed(palette.grayIcon) },
                                               search_filter_files: { AnsibleThemeHooks.shared.image(.iconSearchFilterFiles).precomposed(palette.grayIcon) },
                                               search_filter_links: { AnsibleThemeHooks.shared.image(.iconSearchFilterLinks).precomposed(palette.grayIcon) },
                                               search_filter_music: { AnsibleThemeHooks.shared.image(.iconSearchFilterMusic).precomposed(palette.grayIcon) },
                                               search_filter_downloads: { AnsibleThemeHooks.shared.image(.iconSearchFilterDownloads).precomposed(palette.grayIcon) },
                                               search_filter_add_peer: { AnsibleThemeHooks.shared.image(.iconSearchFilterAddPeer).precomposed(palette.grayIcon) },
                                               search_filter_add_peer_active: { AnsibleThemeHooks.shared.image(.iconSearchFilterAddPeer).precomposed(palette.underSelectedColor) },
                                               search_filter_hashtag: { AnsibleThemeHooks.shared.image(.iconSearchFilterHashtag).precomposed(palette.grayIcon) },
                                               search_hashtag_chevron: { AnsibleThemeHooks.shared.image(.iconHorizontalChevron).precomposed(palette.underSelectedColor) },
                                               chat_reply_count_bubble_incoming: { AnsibleThemeHooks.shared.image(.iconChatRepliesCount).precomposed(palette.grayIconBubble_incoming) },
                                               chat_reply_count_bubble_outgoing: { AnsibleThemeHooks.shared.image(.iconChatRepliesCount).precomposed(palette.grayIconBubble_outgoing) },
                                               chat_reply_count: { AnsibleThemeHooks.shared.image(.iconChatRepliesCount).precomposed(palette.grayIcon) },
                                               chat_reply_count_overlay: { AnsibleThemeHooks.shared.image(.iconChatRepliesCount).precomposed(.white) },
                                               channel_comments_bubble: { AnsibleThemeHooks.shared.image(.iconChannelCommentsBubble).precomposed(palette.accentIcon
                                                , flipVertical: true) },
                                               channel_comments_bubble_next: { AnsibleThemeHooks.shared.image(.iconChannelCommentsNext).precomposed(palette.accentIcon, flipVertical: true) },
                                               channel_comments_list: { AnsibleThemeHooks.shared.image(.iconChannelComments).precomposed(palette.accent, flipVertical: true) },
                                               channel_comments_overlay: { AnsibleThemeHooks.shared.image(.iconChannelCommentsBubble).precomposed(palette.accent) },
                                               chat_replies_avatar: { AnsibleThemeHooks.shared.image(.iconRepliesChat).precomposed() },
                                               group_selection_foreground: { generateChatGroupToggleSelectionForeground(foregroundColor: palette.grayText.withAlphaComponent(0.4), backgroundColor: NSColor.black.withAlphaComponent(0.1)) },
                                               group_selection_foreground_bubble_incoming: { generateChatGroupToggleSelectionForeground(foregroundColor: palette.grayTextBubble_incoming.withAlphaComponent(0.4), backgroundColor: NSColor.black.withAlphaComponent(0.1)) },
                                               group_selection_foreground_bubble_outgoing: { generateChatGroupToggleSelectionForeground(foregroundColor: palette.grayTextBubble_outgoing.withAlphaComponent(0.4), backgroundColor: NSColor.black.withAlphaComponent(0.1)) },
                                               chat_pinned_list: { AnsibleThemeHooks.shared.image(.iconChatPinnedList).precomposed(palette.accentIcon) },
                                               chat_pinned_message: { AnsibleThemeHooks.shared.image(.iconChatPinnedMessage).precomposed(palette.accentIcon) },
                                               chat_pinned_message_bubble_incoming: { AnsibleThemeHooks.shared.image(.iconChatPinnedMessage).precomposed(palette.grayIconBubble_incoming) },
                                               chat_pinned_message_bubble_outgoing: { AnsibleThemeHooks.shared.image(.iconChatPinnedMessage).precomposed(palette.grayIconBubble_outgoing) },
                                               chat_pinned_message_overlay_bubble: { AnsibleThemeHooks.shared.image(.iconChatPinnedMessage).precomposed(.white) },
                                               chat_voicechat_can_unmute: { AnsibleThemeHooks.shared.image(.iconGroupCallSmallMuted).precomposed(.white) },
                                               chat_voicechat_cant_unmute: { AnsibleThemeHooks.shared.image(.iconGroupCallSmallMuted).precomposed(palette.redUI) },
                                               chat_voicechat_unmuted: { AnsibleThemeHooks.shared.image(.iconGroupCallSmallUnmuted).precomposed(.white) },
                                               profile_voice_chat: { generateProfileIcon(AnsibleThemeHooks.shared.image(.iconProfileVoiceChat).precomposed(palette.accentIcon), backgroundColor: palette.accent) },
                                               chat_voice_chat: { generateChatAction(AnsibleThemeHooks.shared.image(.iconVoiceChatTitle).precomposed(palette.accentIcon), background: palette.background) },
                                               chat_voice_chat_active: { generateChatAction(AnsibleThemeHooks.shared.image(.iconVoiceChatTitle).precomposed(palette.accentIcon), background: palette.grayIcon.withAlphaComponent(0.1)) },
                                               editor_draw: { AnsibleThemeHooks.shared.image(.iconEditorPaint).precomposed(palette.text) },
                                               editor_delete: { AnsibleThemeHooks.shared.image(.iconEditorDelete).precomposed(palette.text) },
                                              editor_crop: { AnsibleThemeHooks.shared.image(.iconEditorCrop).precomposed(palette.text) },
                                               fast_copy_link: { AnsibleThemeHooks.shared.image(.iconFastCopyLink).precomposed(palette.accent) },
                                               profile_channel_sign: {AnsibleThemeHooks.shared.image(.iconProfileChannelSign).precomposed(flipVertical: true)},
                                               profile_channel_type: {AnsibleThemeHooks.shared.image(.iconProfileChannelType).precomposed(flipVertical: true)},
                                               profile_group_type: {AnsibleThemeHooks.shared.image(.iconProfileGroupType).precomposed(flipVertical: true)},
                                                profile_group_topics: {AnsibleThemeHooks.shared.image(.iconProfileTopics).precomposed(flipVertical: true)},
                                                profile_group_welcome: {NSImage(named: "Icon_GroupInfo_Welcome")!.precomposed(flipVertical: true)},
                                               profile_group_destruct: {AnsibleThemeHooks.shared.image(.iconProfileDestruct).precomposed(flipVertical: true)},
                                               profile_group_discussion: {AnsibleThemeHooks.shared.image(.iconProfileDiscussion).precomposed(flipVertical: true)},
                                               profile_requests: {AnsibleThemeHooks.shared.image(.iconProfileRequests).precomposed(palette.accent, flipVertical: true)},
                                               profile_reactions: { AnsibleThemeHooks.shared.image(.iconPeerInfoReactions).precomposed(flipVertical: true) },
                                                profile_channel_color: { AnsibleThemeHooks.shared.image(.iconPeerInfoChannel).precomposed(flipVertical: true) },
                                               profile_channel_stats: { AnsibleThemeHooks.shared.image(.iconProfileChannelStats).precomposed(flipVertical: true) },
                                               profile_removed: {AnsibleThemeHooks.shared.image(.iconProfileRemoved).precomposed(flipVertical: true)},
                                               profile_links: {AnsibleThemeHooks.shared.image(.iconProfileLinks).precomposed(flipVertical: true)},
                                               destruct_clear_history: { AnsibleThemeHooks.shared.image(.iconClearChat).precomposed(palette.redUI, flipVertical: true) },
                                               chat_gigagroup_info: { AnsibleThemeHooks.shared.image(.iconGigagroupInfo).precomposed(palette.accent) },
                                               playlist_next: { AnsibleThemeHooks.shared.image(.iconPlayListNext).precomposed(palette.text) },
                                               playlist_prev: { AnsibleThemeHooks.shared.image(.iconPlayListNext).precomposed(palette.text, flipHorizontal: true) },
                                               playlist_next_locked: { AnsibleThemeHooks.shared.image(.iconPlayListNext).precomposed(palette.text.withAlphaComponent(0.6)) },
                                               playlist_prev_locked: { AnsibleThemeHooks.shared.image(.iconPlayListNext).precomposed(palette.text.withAlphaComponent(0.6), flipHorizontal: true) },
                                               playlist_random: { AnsibleThemeHooks.shared.image(.iconPlayListRandom).precomposed(palette.text) },
                                               playlist_order_normal: { AnsibleThemeHooks.shared.image(.iconPlayListOrder).precomposed(palette.text) },
                                               playlist_order_reversed: { AnsibleThemeHooks.shared.image(.iconPlayListOrder).precomposed(palette.accent) },
                                               playlist_order_random: { AnsibleThemeHooks.shared.image(.iconPlayListRandom).precomposed(palette.accent) },
                                               playlist_repeat_none: { AnsibleThemeHooks.shared.image(.iconPlayListRepeat).precomposed(palette.text) },
                                               playlist_repeat_circle: { AnsibleThemeHooks.shared.image(.iconPlayListRepeat).precomposed(palette.accent) },
                                               playlist_repeat_one: { AnsibleThemeHooks.shared.image(.iconPlayListRepeatOne).precomposed(palette.accent) },
                                               audioplayer_next: { AnsibleThemeHooks.shared.image(.iconInlinePlayerNext).precomposed(palette.accent) },
                                               audioplayer_prev: { AnsibleThemeHooks.shared.image(.iconInlinePlayerNext).precomposed(palette.accent, flipHorizontal: true) },
                                               audioplayer_dismiss: { AnsibleThemeHooks.shared.image(.iconChatSearchCancel).precomposed(palette.accentIcon) },
                                               audioplayer_repeat_none: { AnsibleThemeHooks.shared.image(.iconInlinePlayerRepeat).precomposed(palette.grayIcon) },
                                               audioplayer_repeat_circle: { AnsibleThemeHooks.shared.image(.iconInlinePlayerRepeat).precomposed(palette.accent) },
                                               audioplayer_repeat_one: { AnsibleThemeHooks.shared.image(.iconInlinePlayerRepeatOne).precomposed(palette.accentIcon) },
                                               audioplayer_locked_next: { AnsibleThemeHooks.shared.image(.iconInlinePlayerNext).precomposed(palette.grayIcon) },
                                               audioplayer_locked_prev: { AnsibleThemeHooks.shared.image(.iconInlinePlayerNext).precomposed(palette.grayIcon, flipHorizontal: true) },
                                               audioplayer_volume: { AnsibleThemeHooks.shared.image(.iconInlinePlayerVolumeOn).precomposed(palette.accent) },
                                               audioplayer_volume_off: { AnsibleThemeHooks.shared.image(.iconInlinePlayerVolumeOff).precomposed(palette.grayIcon) },
                                               audioplayer_speed_x1: { AnsibleThemeHooks.shared.image(.iconInlinePlayerX2).precomposed(palette.grayIcon) },
                                               audioplayer_speed_x2: { AnsibleThemeHooks.shared.image(.iconInlinePlayerX2).precomposed(palette.accentIcon) },
                                               audioplayer_list: { AnsibleThemeHooks.shared.image(.iconAudioPlayerList).precomposed(palette.grayIcon) },
                                               chat_info_voice_chat: { AnsibleThemeHooks.shared.image(.iconVoiceChatTitle).precomposed(palette.accentIcon) },
                                               chat_info_create_group: { AnsibleThemeHooks.shared.image(.iconNewGroup).precomposed(palette.accentIcon) },
                                               chat_info_change_colors: { AnsibleThemeHooks.shared.image(.iconChangeColors).precomposed(palette.accentIcon) },
                                               empty_chat_system: { AnsibleThemeHooks.shared.image(.iconEmptyChatSystem).precomposed(palette.text) },
                                               empty_chat_dark: { AnsibleThemeHooks.shared.image(.iconEmptyChatDark).precomposed(palette.text) },
                                               empty_chat_light: { AnsibleThemeHooks.shared.image(.iconEmptyChatLight).precomposed(palette.text) },
                                               empty_chat_system_active: { AnsibleThemeHooks.shared.image(.iconEmptyChatSystem).precomposed(palette.accent) },
                                               empty_chat_dark_active: { AnsibleThemeHooks.shared.image(.iconEmptyChatDark).precomposed(palette.accent) },
                                               empty_chat_light_active: { AnsibleThemeHooks.shared.image(.iconEmptyChatLight).precomposed(palette.accent) },
                                               empty_chat_storage_clear: { AnsibleThemeHooks.shared.image(.iconEmptyChatStorageClear).precomposed(palette.text) },
                                               empty_chat_storage_low: { AnsibleThemeHooks.shared.image(.iconEmptyChatStorageMedium).precomposed(palette.text) },
                                               empty_chat_storage_medium: { AnsibleThemeHooks.shared.image(.iconEmptyChatStorageHigh).precomposed(palette.text) },
                                               empty_chat_storage_high: { AnsibleThemeHooks.shared.image(.iconEmptyChatStorageNoLimit).precomposed(palette.text) },
                                               empty_chat_storage_low_active: { AnsibleThemeHooks.shared.image(.iconEmptyChatStorageMedium).precomposed(palette.accent) },
                                               empty_chat_storage_medium_active: { AnsibleThemeHooks.shared.image(.iconEmptyChatStorageHigh).precomposed(palette.accent) },
                                               empty_chat_storage_high_active: { AnsibleThemeHooks.shared.image(.iconEmptyChatStorageNoLimit).precomposed(palette.accent) },
                                               empty_chat_stickers_none: { AnsibleThemeHooks.shared.image(.iconEmptyChatStickersNone).precomposed(palette.text) },
                                               empty_chat_stickers_mysets: { AnsibleThemeHooks.shared.image(.iconEmptyChatStickersMySets).precomposed(palette.text) },
                                               empty_chat_stickers_allsets: { AnsibleThemeHooks.shared.image(.iconEmptyChatStickersAllSets).precomposed(palette.text) },
                                               empty_chat_stickers_none_active: { AnsibleThemeHooks.shared.image(.iconEmptyChatStickersNone).precomposed(palette.accent) },
                                               empty_chat_stickers_mysets_active: { AnsibleThemeHooks.shared.image(.iconEmptyChatStickersMySets).precomposed(palette.accent) },
                                               empty_chat_stickers_allsets_active: { AnsibleThemeHooks.shared.image(.iconEmptyChatStickersAllSets).precomposed(palette.accent) },
                                               chat_action_dismiss: { AnsibleThemeHooks.shared.image(.iconChatActionClose).precomposed(palette.accent) },
                                               chat_action_edit_message: { AnsibleThemeHooks.shared.image(.iconChatActionEditMessage).precomposed(palette.accent) },
                                               chat_action_forward_message: { AnsibleThemeHooks.shared.image(.iconChatActionForwardMessage).precomposed(palette.accent) },
                                               chat_action_reply_message: { AnsibleThemeHooks.shared.image(.iconChatActionReplyMessage).precomposed(palette.accent) },
                                               chat_action_url_preview: { AnsibleThemeHooks.shared.image(.iconChatActionUrlPreview).precomposed(palette.accent) },
                                               chat_action_menu_update_chat: { AnsibleThemeHooks.shared.image(.iconChatActionMenuUpdateChat).precomposed(palette.accent) },
                                               chat_action_menu_selected: { AnsibleThemeHooks.shared.image(.iconUsernameAvailability).precomposed(palette.accent) },
                                               widget_peers_favorite: { AnsibleThemeHooks.shared.image(.iconWidgetPeersFavorite).precomposed(palette.text) },
                                               widget_peers_recent: { AnsibleThemeHooks.shared.image(.iconWidgetPeersRecent).precomposed(palette.text) },
                                               widget_peers_both: { AnsibleThemeHooks.shared.image(.iconWidgetPeersBoth).precomposed(palette.text) },
                                               widget_peers_favorite_active: { AnsibleThemeHooks.shared.image(.iconWidgetPeersFavorite).precomposed(palette.accent) },
                                               widget_peers_recent_active: { AnsibleThemeHooks.shared.image(.iconWidgetPeersRecent).precomposed(palette.accent) },
                                               widget_peers_both_active: { AnsibleThemeHooks.shared.image(.iconWidgetPeersBoth).precomposed(palette.accent) },
                                               chat_reactions_add: {  AnsibleThemeHooks.shared.image(.iconReactionsAdd).precomposed(palette.grayIcon) },
                                               chat_reactions_add_bubble: {  AnsibleThemeHooks.shared.image(.iconReactionsAdd).precomposed(palette.text) },
                                               chat_reactions_add_active: {  AnsibleThemeHooks.shared.image(.iconReactionsAdd).precomposed(palette.accent) },
                                               reactions_badge: { generateBadgeMention(image: AnsibleThemeHooks.shared.image(.iconReactionBadge), backgroundColor: palette.redUI, foregroundColor: palette.background) },
                                               reactions_badge_active: { generateBadgeMention(image: AnsibleThemeHooks.shared.image(.iconReactionBadge), backgroundColor: palette.underSelectedColor, foregroundColor: palette.accentSelect) },
                                               reactions_badge_archive: { generateBadgeMention(image: AnsibleThemeHooks.shared.image(.iconReactionBadge), backgroundColor: palette.badgeMuted, foregroundColor: palette.background) },
                                               reactions_badge_archive_active: { generateBadgeMention(image: AnsibleThemeHooks.shared.image(.iconReactionBadge), backgroundColor: palette.underSelectedColor, foregroundColor: palette.accentSelect) },
                                               reactions_show_more: { NSImage.init(named: "Icon_Reactions_ShowMore")!.precomposed(NSColor.white) },
                                               chat_reactions_badge: { generateChatMention(image: AnsibleThemeHooks.shared.image(.iconReactionButton), backgroundColor: palette.background, border: palette.chatBackground == palette.background && palette.isDark ? palette.grayIcon : .clear, foregroundColor: palette.text) },
                                               chat_reactions_badge_active: { generateChatMention(image: AnsibleThemeHooks.shared.image(.iconReactionButton), backgroundColor: palette.background, border: palette.chatBackground == palette.background && palette.isDark ? palette.accentIcon : .clear, foregroundColor: .text) },
                                                gallery_pip_close: { AnsibleThemeHooks.shared.image(.iconPipClose).precomposed(NSColor(0xffffff)) },
                                                gallery_pip_muted: { AnsibleThemeHooks.shared.image(.iconPipMuted).precomposed(NSColor(0xffffff)) },
                                                gallery_pip_unmuted: { AnsibleThemeHooks.shared.image(.iconPipUnmuted).precomposed(NSColor(0xffffff)) },
                                                gallery_pip_out: { AnsibleThemeHooks.shared.image(.iconPipOut).precomposed(NSColor(0xffffff)) },
                                                gallery_pip_pause: { AnsibleThemeHooks.shared.image(.iconPipPause).precomposed(NSColor(0xffffff)) },
                                                gallery_pip_play: { AnsibleThemeHooks.shared.image(.iconPipPlay).precomposed(NSColor(0xffffff)) },
                                                notification_sound_add: { AnsibleThemeHooks.shared.image(.iconNotificationAdd).precomposed(palette.accent, flipVertical: true) },
                                                premium_lock: { generateLockPremium(palette) },
                                                premium_lock_gray: { AnsibleThemeHooks.shared.image(.iconPremiumLock).precomposed(palette.grayIcon) },
                                                premium_plus: { AnsibleThemeHooks.shared.image(.iconPremiumPlus).precomposed(NSColor(0xffffff)) },
                                                premium_account: { generatePremium(false, color: palette.accent) },
                                                premium_account_active: { generatePremium(false, color: palette.underSelectedColor) },
                                                premium_account_rev: { generatePremium(true, color: palette.accent) },
                                                premium_account_rev_active: { generatePremium(true, color: palette.underSelectedColor, small: false) },
                                                premium_account_small: { generatePremium(false, color: palette.accent, small: true) },
                                                premium_account_small_active: { generatePremium(false, color: palette.underSelectedColor, small: true) },
                                                premium_account_small_rev: { generatePremium(true, color: palette.accent, small: true) },
                                                premium_account_small_rev_active: { generatePremium(true, color: palette.underSelectedColor, small: true) },
                                                premium_reaction_lock: { AnsibleThemeHooks.shared.image(.iconPremiumReactionLock).precomposed(palette.accent) },
                                                premium_boarding_feature_next: { AnsibleThemeHooks.shared.image(.premiumBoardingFeatureNext).precomposed(palette.grayIcon) },
                                                premium_stickers: { generateStickerPackPremium() },
                                                premium_emoji_lock: { AnsibleThemeHooks.shared.image(.iconEmojiLock).precomposed(palette.grayIcon)},
                                                account_add_account: { AnsibleThemeHooks.shared.image(.iconAccountAddAccount).precomposed(palette.accent, flipVertical: true)},
                                                account_set_status: { AnsibleThemeHooks.shared.image(.iconAccountSetStatus).precomposed(palette.accent, flipVertical: true)},
                                                account_change_status: { AnsibleThemeHooks.shared.image(.iconAccountChangeStatus).precomposed(palette.accent, flipVertical: true)},
                                                chat_premium_status_red: { generatePremium(false, color: palette.groupPeerNameRed, small: true) },
                                                chat_premium_status_orange: { generatePremium(false, color: palette.groupPeerNameOrange, small: true) },
                                                chat_premium_status_violet: { generatePremium(false, color: palette.groupPeerNameViolet, small: true) },
                                                chat_premium_status_green: { generatePremium(false, color: palette.groupPeerNameGreen, small: true) },
                                                chat_premium_status_cyan: { generatePremium(false, color: palette.groupPeerNameCyan, small: true) },
                                                chat_premium_status_light_blue: { generatePremium(false, color: palette.groupPeerNameLightBlue, small: true) },
                                                chat_premium_status_blue: { generatePremium(false, color: palette.groupPeerNameBlue, small: true) },
                                                extend_content_lock: { AnsibleThemeHooks.shared.image(.iconPremiumLock).precomposed(.white) },
                                                chatlist_forum_closed_topic: { AnsibleThemeHooks.shared.image(.iconForumClosedTopic).precomposed(palette.grayIcon, flipVertical: true) },
                                                chatlist_forum_closed_topic_active: { AnsibleThemeHooks.shared.image(.iconForumClosedTopic).precomposed(palette.underSelectedColor, flipVertical: true) },
                                                chatlist_arrow: { AnsibleThemeHooks.shared.image(.iconChatListArrow).precomposed(palette.text) },
                                                chatlist_arrow_active: { AnsibleThemeHooks.shared.image(.iconChatListArrow).precomposed(palette.underSelectedColor) },
                                                dialog_auto_delete: {AnsibleThemeHooks.shared.image(.iconAutoDeleteCircle).precomposed(.white)},
                                                contact_set_photo: { AnsibleThemeHooks.shared.image(.iconPhotoCameraPlus).precomposed(palette.accent, flipVertical: true) },
                                                contact_suggest_photo: { AnsibleThemeHooks.shared.image(.iconPhotoCameraSuggest).precomposed(palette.accent, flipVertical: true) },
                                                send_media_spoiler: { NSImage.init(named: "Icon_PreviewSpoiler")!.precomposed(palette.grayIcon) },
                                                general_delete: { AnsibleThemeHooks.shared.image(.iconMessageActionPanelDelete).precomposed(palette.redUI, flipVertical: true) },
                                                storage_music_play: { AnsibleThemeHooks.shared.image(.iconPipPlay).precomposed(palette.underSelectedColor, zoom: 0.8) },
                                                storage_music_pause: { AnsibleThemeHooks.shared.image(.iconPipPause).precomposed(palette.underSelectedColor, zoom: 0.8) },
                                                storage_media_play: { AnsibleThemeHooks.shared.image(.iconPipPlay).precomposed(palette.underSelectedColor, zoom: 0.6) },
                                                general_chevron_up: { AnsibleThemeHooks.shared.image(.iconHorizontalChevron).precomposed(palette.grayIcon, flipVertical: true) },
                                                general_chevron_down: { AnsibleThemeHooks.shared.image(.iconHorizontalChevron).precomposed(palette.grayIcon) },
                                                account_settings_set_password: { AnsibleThemeHooks.shared.image(.iconSettingsAddPassword).precomposed(palette.accent, flipVertical: true) },
                                                select_peer_create_channel: { AnsibleThemeHooks.shared.image(.iconCreateChannel).precomposed(palette.accent, flipVertical: true) },
                                                select_peer_create_group: { AnsibleThemeHooks.shared.image(.iconCreateGroup).precomposed(palette.accent, flipVertical: true) },
                                                chat_translate: { AnsibleThemeHooks.shared.image(.iconChatTranslate).precomposed(palette.accent) },
                                                msg_emoji_activities: { AnsibleThemeHooks.shared.image(.msgEmojiActivities).precomposed(palette.grayIcon) },
                                                msg_emoji_angry: { AnsibleThemeHooks.shared.image(.msgEmojiAngry).precomposed(palette.grayIcon) },
                                                msg_emoji_away: { AnsibleThemeHooks.shared.image(.msgEmojiAway).precomposed(palette.grayIcon) },
                                                msg_emoji_bath: { AnsibleThemeHooks.shared.image(.msgEmojiBath).precomposed(palette.grayIcon) },
                                                msg_emoji_busy: { AnsibleThemeHooks.shared.image(.msgEmojiBusy).precomposed(palette.grayIcon) },
                                                msg_emoji_dislike: { AnsibleThemeHooks.shared.image(.msgEmojiDislike).precomposed(palette.grayIcon) },
                                                msg_emoji_food: { AnsibleThemeHooks.shared.image(.msgEmojiFood).precomposed(palette.grayIcon) },
                                                msg_emoji_haha: { AnsibleThemeHooks.shared.image(.msgEmojiHaha).precomposed(palette.grayIcon) },
                                                msg_emoji_happy: { AnsibleThemeHooks.shared.image(.msgEmojiHappy).precomposed(palette.grayIcon) },
                                                msg_emoji_heart: { AnsibleThemeHooks.shared.image(.msgEmojiHeart).precomposed(palette.grayIcon) },
                                                msg_emoji_hi2: { AnsibleThemeHooks.shared.image(.msgEmojiHi2).precomposed(palette.grayIcon) },
                                                msg_emoji_home: { AnsibleThemeHooks.shared.image(.msgEmojiHome).precomposed(palette.grayIcon) },
                                                msg_emoji_like: { AnsibleThemeHooks.shared.image(.msgEmojiLike).precomposed(palette.grayIcon) },
                                                msg_emoji_neutral: { AnsibleThemeHooks.shared.image(.msgEmojiNeutral).precomposed(palette.grayIcon) },
                                                msg_emoji_omg: { AnsibleThemeHooks.shared.image(.msgEmojiOmg).precomposed(palette.grayIcon) },
                                                msg_emoji_party: { AnsibleThemeHooks.shared.image(.msgEmojiParty).precomposed(palette.grayIcon) },
                                                msg_emoji_recent: { AnsibleThemeHooks.shared.image(.msgEmojiRecent).precomposed(palette.grayIcon) },
                                                msg_emoji_sad: { AnsibleThemeHooks.shared.image(.msgEmojiSad).precomposed(palette.grayIcon) },
                                                msg_emoji_sleep: { AnsibleThemeHooks.shared.image(.msgEmojiSleep).precomposed(palette.grayIcon) },
                                                msg_emoji_study: { AnsibleThemeHooks.shared.image(.msgEmojiStudy).precomposed(palette.grayIcon) },
                                                msg_emoji_tongue: { AnsibleThemeHooks.shared.image(.msgEmojiTongue).precomposed(palette.grayIcon) },
                                                msg_emoji_vacation: { AnsibleThemeHooks.shared.image(.msgEmojiVacation).precomposed(palette.grayIcon) },
                                                msg_emoji_what: { AnsibleThemeHooks.shared.image(.msgEmojiWhat).precomposed(palette.grayIcon) },
                                                msg_emoji_work: { AnsibleThemeHooks.shared.image(.msgEmojiWork).precomposed(palette.grayIcon) },
                                                msg_emoji_premium: { AnsibleThemeHooks.shared.image(.msgEmojiPremium).precomposed(palette.grayIcon) },
                                                installed_stickers_archive: { AnsibleThemeHooks.shared.image(.iconInstalledStickersArchive).precomposed(flipVertical: true) },
                                                installed_stickers_custom_emoji: { AnsibleThemeHooks.shared.image(.iconInstalledStickersCustomEmoji).precomposed(flipVertical: true) },
                                                installed_stickers_dynamic_order: { AnsibleThemeHooks.shared.image(.iconInstalledStickersDynamicOrder).precomposed(flipVertical: true) },
                                                installed_stickers_loop: { AnsibleThemeHooks.shared.image(.iconInstalledStickersLoop).precomposed(flipVertical: true) },
                                                installed_stickers_reactions: { AnsibleThemeHooks.shared.image(.iconInstalledStickersReaction).precomposed() },
                                                installed_stickers_suggest: { AnsibleThemeHooks.shared.image(.iconInstalledStickersSuggest).precomposed(flipVertical: true) },
                                                installed_stickers_trending: { AnsibleThemeHooks.shared.image(.iconInstalledStickersTrending).precomposed(flipVertical: true) },
                                                folder_invite_link: { generateFolderLinkIcon(palette: palette, revoked: false) },
                                                folder_invite_link_revoked: { generateFolderLinkIcon(palette: palette, revoked: true) },
                              folders_sidebar_edit: { AnsibleThemeHooks.shared.image(.iconLeftSidebarEditFolders).precomposed(palette.text.withAlphaComponent(0.75), flipVertical: true) },
                              folders_sidebar_edit_active: { AnsibleThemeHooks.shared.image(.iconLeftSidebarEditFolders).precomposed(palette.grayIcon.withAlphaComponent(0.8), flipVertical: true) },
                              story_unseen: { generateStoryState(palette.accent, bgColor: palette.background, size: NSMakeSize(50, 50), wide: 1.5) },
                              story_seen: { generateStoryState(palette.grayIcon.withAlphaComponent(0.5), bgColor: palette.background, size: NSMakeSize(50, 50), wide: 1.0) },
                              story_selected: { generateStoryState(palette.underSelectedColor, bgColor: palette.background, size: NSMakeSize(50, 50), wide: 1.0) },
                              story_unseen_chat: { generateStoryState(palette.accent, bgColor: palette.background, size: NSMakeSize(36, 36), wide: 1.5) },
                              story_seen_chat: { generateStoryState(palette.grayIcon, bgColor: palette.background, size: NSMakeSize(36, 36), wide: 1.0) },
                              story_unseen_profile: { generateStoryState(palette.accent, bgColor: palette.background, size: NSMakeSize(120, 120), wide: 1.5) },
                              story_seen_profile: { generateStoryState(palette.grayIcon, bgColor: palette.background, size: NSMakeSize(120, 120), wide: 1.0) },
                              story_view_read: { AnsibleThemeHooks.shared.image(.iconStoryViewRead).precomposed(palette.grayIcon) },
                              story_view_reaction: { AnsibleThemeHooks.shared.image(.iconStoryViewReaction).precomposed(palette.grayIcon) },
                              story_chatlist_reply: { AnsibleThemeHooks.shared.image(.iconStoryReply).precomposed(palette.grayIcon) },
                              story_chatlist_reply_active: { AnsibleThemeHooks.shared.image(.iconStoryReply).precomposed(palette.underSelectedColor) },
                              message_story_expired: { AnsibleThemeHooks.shared.image(.iconStoryExpired).precomposed(palette.chatReplyTitle) },
                              message_story_expired_bubble_incoming: { AnsibleThemeHooks.shared.image(.iconStoryExpired).precomposed(palette.chatReplyTitleBubble_incoming) },
                              message_story_expired_bubble_outgoing: { AnsibleThemeHooks.shared.image(.iconStoryExpired).precomposed(palette.chatReplyTitleBubble_outgoing) },
                              message_quote_accent: { AnsibleThemeHooks.shared.image(.iconQuote).precomposed(palette.accent) },
                              message_quote_red: { AnsibleThemeHooks.shared.image(.iconQuote).precomposed(NSColor(0xCC5049)) },
                              message_quote_orange: { AnsibleThemeHooks.shared.image(.iconQuote).precomposed(NSColor(0xD67722)) },
                              message_quote_violet: { AnsibleThemeHooks.shared.image(.iconQuote).precomposed(NSColor(0x955CDB)) },
                              message_quote_green: { AnsibleThemeHooks.shared.image(.iconQuote).precomposed(NSColor(0x40A920)) },
                              message_quote_cyan: { AnsibleThemeHooks.shared.image(.iconQuote).precomposed(NSColor(0x309EBA)) },
                              message_quote_blue: { AnsibleThemeHooks.shared.image(.iconQuote).precomposed(NSColor(0x368AD1)) },
                              message_quote_pink: { AnsibleThemeHooks.shared.image(.iconQuote).precomposed(NSColor(0xC7508B)) },
                              message_quote_bubble_incoming: { AnsibleThemeHooks.shared.image(.iconQuote).precomposed(palette.chatReplyTitleBubble_incoming) },
                              message_quote_bubble_outgoing: { AnsibleThemeHooks.shared.image(.iconQuote).precomposed(palette.chatReplyTitleBubble_outgoing) },
                              channel_stats_likes: { AnsibleThemeHooks.shared.image(.iconChannelStatsLikes).precomposed(palette.grayIcon) },
                              channel_stats_shares: { AnsibleThemeHooks.shared.image(.iconChannelStatsShares).precomposed(palette.grayIcon) },
                              story_repost_from_white: { AnsibleThemeHooks.shared.image(.iconStoryRepostFrom).precomposed(palette.listGrayText) },
                              story_repost_from_green: { AnsibleThemeHooks.shared.image(.iconStoryRepostFrom).precomposed(palette.greenUI) },
                              channel_feature_background: { AnsibleThemeHooks.shared.image(.iconChannelFeatureBackground).precomposed(palette.accent) },
                              channel_feature_background_photo: { AnsibleThemeHooks.shared.image(.iconChannelFeatureBackgroundPhoto).precomposed(palette.accent) },
                              channel_feature_cover_color: { AnsibleThemeHooks.shared.image(.iconChannelFeatureCover).precomposed(palette.accent) },
                              channel_feature_cover_icon: { AnsibleThemeHooks.shared.image(.iconChannelFeatureCoverIcon).precomposed(palette.accent) },
                              channel_feature_link_color: { AnsibleThemeHooks.shared.image(.iconChannelFeatureLink).precomposed(palette.accent) },
                              channel_feature_link_icon: { AnsibleThemeHooks.shared.image(.iconChannelFeatureLinkIcon).precomposed(palette.accent) },
                              channel_feature_name_color: { AnsibleThemeHooks.shared.image(.iconChannelFeatureName).precomposed(palette.accent) },
                              channel_feature_reaction: { AnsibleThemeHooks.shared.image(.iconChannelFeatureReaction).precomposed(palette.accent) },
                              channel_feature_status: { AnsibleThemeHooks.shared.image(.iconChannelFeatureStatus).precomposed(palette.accent) },
                              channel_feature_stories: { AnsibleThemeHooks.shared.image(.iconChannelFeatureStories).precomposed(palette.accent) },
                              channel_feature_emoji_pack: { AnsibleThemeHooks.shared.image(.iconChannelFeatureEmojiPack).precomposed(palette.accent) },
                              channel_feature_voice_to_text: { AnsibleThemeHooks.shared.image(.iconChannelFeatureVoiceToText).precomposed(palette.accent) },
                              channel_feature_no_ads: { AnsibleThemeHooks.shared.image(.iconFragmentNoAds).precomposed(palette.accent) },
                              channel_feature_autotranslate: { AnsibleThemeHooks.shared.image(.iconBoostTranslation).precomposed(palette.accent) },
                              chat_hidden_author: { AnsibleThemeHooks.shared.image(.iconAuthorHidden).precomposed(.white) },
                              chat_my_notes: { AnsibleThemeHooks.shared.image(.iconMyNotes).precomposed(.white) },
                              premium_required_forward: { AnsibleThemeHooks.shared.image(.iconPremiumRequiredForward).precomposed() },
                              create_new_message_general: { AnsibleThemeHooks.shared.image(.iconNewMessage).precomposed(palette.accent, flipVertical: true) },
                              bot_manager_settings: { AnsibleThemeHooks.shared.image(.iconBotManagerSettings).precomposed(palette.grayIcon) },
                              preview_text_down: { AnsibleThemeHooks.shared.image(.iconMoveCaptionDown).precomposed(palette.grayIcon) },
                              preview_text_up: { AnsibleThemeHooks.shared.image(.iconMoveCaptionUp).precomposed(palette.grayIcon) },
                              avatar_star_badge: { generateAvatarStarBadge(color: palette.background) },
                              avatar_star_badge_active: { generateAvatarStarBadge(color: palette.accentSelect) },
                              avatar_star_badge_gray: { generateAvatarStarBadge(color: palette.listBackground) },
                              avatar_star_badge_large_gray: { generateAvatarStarBadgeLarge(color: palette.listBackground) },
                              chatlist_apps: { AnsibleThemeHooks.shared.image(.iconChatListApps).precomposed(palette.accent) },
                              chat_input_channel_gift:  { AnsibleThemeHooks.shared.image(.iconChannelGift).precomposed(palette.accent) },
                              chat_input_suggest_message: { AnsibleThemeHooks.shared.image(.iconChatInputMessageSuggestion).precomposed(palette.accent) },
                              chat_input_send_gift: { AnsibleThemeHooks.shared.image(.iconChannelGift).precomposed(palette.darkGrayText) },
                              chat_input_suggest_post: { AnsibleThemeHooks.shared.image(.iconInputSuggestPost).precomposed(palette.darkGrayText) },
                              todo_selection: { generateTodoSelection(color: palette.webPreviewActivity) },
                              todo_selected: { generateTodoSelected(color: palette.webPreviewActivity) },
                              todo_selection_other_incoming: { generateTodoSelection(color: palette.webPreviewActivityBubble_incoming) },
                              todo_selection_other_outgoing: { generateTodoSelection(color: palette.webPreviewActivityBubble_outgoing) },
                              todo_selected_other_incoming: { generateTodoSelected(color: palette.webPreviewActivityBubble_incoming) },
                              todo_selected_other_outgoing: { generateTodoSelected(color: palette.webPreviewActivityBubble_outgoing) },
                              send_message_small: { AnsibleThemeHooks.shared.image(.iconSendMessageSmall).precomposed(palette.underSelectedColor) },
                              send_message_large: { AnsibleThemeHooks.shared.image(.iconSendMessageLarge).precomposed(palette.underSelectedColor) },
                              chat_poll_votes_badge: { generateChatMention(image: AnsibleThemeHooks.shared.image(.iconChatListPollBadge), backgroundColor: palette.background, border: palette.chatBackground == palette.background && palette.isDark ? palette.grayIcon : .clear, foregroundColor: palette.text) },
                              chat_poll_votes_badge_active: { generateChatMention(image: AnsibleThemeHooks.shared.image(.iconChatListPollBadge), backgroundColor: palette.background, border: palette.chatBackground == palette.background && palette.isDark ? palette.accentIcon : .clear, foregroundColor: palette.text) },
                              chat_header_close: { AnsibleThemeHooks.shared.image(.iconPipClose).precomposed(palette.text) },
                              chat_header_back: { AnsibleThemeHooks.shared.image(.iconChatNavigationBack).precomposed(palette.text) },
                              chat_header_search: { AnsibleThemeHooks.shared.image(.iconSearchChatMessages).precomposed(palette.text) },
                              chat_header_voice_call: { AnsibleThemeHooks.shared.image(.iconVoiceChatTitle).precomposed(palette.text) },
                              chat_header_call: { AnsibleThemeHooks.shared.image(.iconCallNavigationHeader).precomposed(palette.text) },
                              chat_header_actions: { AnsibleThemeHooks.shared.image(.iconChatActions).precomposed(palette.text) },
                              chat_header_done: { AnsibleThemeHooks.shared.image(.iconChatDoneCheckbox).precomposed(palette.underSelectedColor) },
                              chat_header_secret_lock: { AnsibleThemeHooks.shared.image(.iconSecretChatLock).precomposed(palette.text) },
                              chat_input_ai: { AnsibleThemeHooks.shared.image(.iconAiInput).precomposed(palette.text) },
                              chat_header_dismiss: { AnsibleThemeHooks.shared.image(.iconBrowserClose).precomposed(palette.text) },
                              chat_header_pinned_list: { AnsibleThemeHooks.shared.image(.iconChatPinnedList).precomposed(palette.text) },
                              chat_header_translate: { AnsibleThemeHooks.shared.image(.iconChatTranslate).precomposed(palette.text) },
                              chat_header_translate_actions: { AnsibleThemeHooks.shared.image(.iconChatActionsActive).precomposed(palette.text) },
                              chat_header_bot_settings: { AnsibleThemeHooks.shared.image(.iconBotManagerSettings).precomposed(palette.text) },
                              chat_header_story_close: { AnsibleThemeHooks.shared.image(.iconStoryClose).precomposed(palette.text) },
                              chat_input_attach: { AnsibleThemeHooks.shared.image(.iconChatAttach).precomposed(palette.text) },
                              chat_input_star: { AnsibleThemeHooks.shared.image(.starSmall).precomposed(palette.underSelectedColor) },
                              chat_search_next: { AnsibleThemeHooks.shared.image(.iconSearchArrow).precomposed(palette.text, flipVertical: true) },
                              chat_search_prev: { AnsibleThemeHooks.shared.image(.iconSearchArrow).precomposed(palette.text) },
                              chat_search_calendar: { AnsibleThemeHooks.shared.image(.iconCalendar).precomposed(palette.text) },
                              chat_search_cancel: { AnsibleThemeHooks.shared.image(.iconPipClose).precomposed(palette.text) },
                              chat_search_from: { AnsibleThemeHooks.shared.image(.iconChatSearchFrom).precomposed(palette.text) },
                              chat_search_premium_lock: { AnsibleThemeHooks.shared.image(.iconPremiumLock).precomposed(palette.accent) },
                              chat_search_chevron: { AnsibleThemeHooks.shared.image(.iconGeneralNext).precomposed(palette.text.withAlphaComponent(0.5)) },
                              chat_search_next_disabled: { AnsibleThemeHooks.shared.image(.iconSearchArrow).precomposed(palette.text.withAlphaComponent(0.3), flipVertical: true) },
                              chat_search_prev_disabled: { AnsibleThemeHooks.shared.image(.iconSearchArrow).precomposed(palette.text.withAlphaComponent(0.3)) },
                              chat_action_gigagroup_info: { AnsibleThemeHooks.shared.image(.iconGigagroupInfo).precomposed(palette.text) },
                              chat_action_monoforum: { AnsibleThemeHooks.shared.image(.iconChatInputMessageSuggestion).precomposed(palette.text) },
                              chat_action_gift: { AnsibleThemeHooks.shared.image(.iconChannelGift).precomposed(palette.text) },
                              chat_input_record_voice: { AnsibleThemeHooks.shared.image(.iconRecordVoice).precomposed(palette.text) },
                              chat_input_record_video: { AnsibleThemeHooks.shared.image(.iconRecordVideoMessage).precomposed(palette.text) },
                              livePhotoBadge: { AnsibleThemeHooks.shared.image(.iconLivePhotoBadge).precomposed(.white) },
                              galleryLivePhotoPlay: { AnsibleThemeHooks.shared.image(.iconGalleryLivePhotoPlay).precomposed(.white) },
                              galleryLivePhotoPlaying: { AnsibleThemeHooks.shared.image(.iconGalleryLivePhotoPlaying).precomposed(.white) }
    )
}


public func generateTheme(palette: ColorPalette, cloudTheme: TelegramTheme?, bubbled: Bool, fontSize: CGFloat, wallpaper: ThemeWallpaper, backgroundSize: NSSize = NSMakeSize(1040, 1580), liquidGlass: Bool = System.liquidGlass, scaleFactor: CGFloat = System.backingScale) -> AnsiblePresentationTheme {
    
    let chatList = AnsibleChatListTheme(selectedBackgroundColor: palette.accentSelect,
                                         singleLayoutSelectedBackgroundColor: palette.grayBackground,
                                         activeDraggingBackgroundColor: palette.border,
                                         pinnedBackgroundColor: palette.background,
                                         contextMenuBackgroundColor: palette.background,
                                         textColor: palette.text,
                                         grayTextColor: palette.grayText,
                                         secretChatTextColor: palette.accent,
                                         peerTextColor: palette.text,
                                         activityColor: palette.accent,
                                         activitySelectedColor: palette.underSelectedColor,
                                         activityContextMenuColor: palette.accent,
                                         activityPinnedColor: palette.accent,
                                         badgeTextColor: palette.background,
                                         badgeBackgroundColor: palette.badge,
                                         badgeSelectedTextColor: palette.accentSelect,
                                         badgeSelectedBackgroundColor: palette.underSelectedColor,
                                         badgeMutedTextColor: .white,
                                         badgeMutedBackgroundColor: palette.badgeMuted)
    
    let tabBar = AnsibleTabBarTheme(color: palette.grayIcon, selectedColor: palette.accentIcon, badgeTextColor: .white, badgeColor: palette.redUI)
    return AnsiblePresentationTheme(colors: palette, cloudTheme: cloudTheme, search: SearchTheme(palette.grayBackground, AnsibleThemeHooks.shared.image(.iconSearchField).precomposed(palette.grayIcon), AnsibleThemeHooks.shared.image(.iconSearchClear).precomposed(palette.grayIcon), { strings().searchFieldSearch }, palette.text, palette.grayText), chatList: chatList, tabBar: tabBar, icons: generateIcons(from: palette, bubbled: bubbled), bubbled: bubbled, fontSize: fontSize, wallpaper: wallpaper, generated: true, backgroundSize: backgroundSize, liquidGlass: liquidGlass, scaleFactor: scaleFactor)
}


public func updateTheme(with settings: ThemePaletteSettings, for window: Window? = nil, animated: Bool = false, resolvedSystemPalette: ColorPalette? = nil, scaleFactor: CGFloat = System.backingScale) -> AnsiblePresentationTheme {
    let palette: ColorPalette
    switch settings.palette.name {
    case whitePalette.name:
        if settings.palette == whitePalette {
            palette = whitePalette
        } else {
            palette = settings.palette
        }
    case darkPalette.name:
        if settings.palette == darkPalette {
            palette = darkPalette
        } else {
            palette = settings.palette
        }
    case dayClassicPalette.name:
        if settings.palette == dayClassicPalette {
            palette = dayClassicPalette
        } else {
            palette = settings.palette
        }
    case nightAccentPalette.name:
        if settings.palette == nightAccentPalette {
            palette = nightAccentPalette
        } else {
            palette = settings.palette
        }
    case systemPalette.name:
        palette = resolvedSystemPalette ?? systemPalette.withUpdatedName(systemPalette.name)
    default:
        palette = settings.palette
    }
    let theme = generateTheme(palette: palette, cloudTheme: settings.cloudTheme, bubbled: settings.bubbled, fontSize: settings.fontSize, wallpaper: settings.wallpaper, scaleFactor: scaleFactor)
    return theme
}

private let appearanceDisposable = MetaDisposable()

public func ansibleUpdateTheme(_ theme: AnsiblePresentationTheme, window: Window? = nil, animated: Bool) {
    assertOnMainThread()
    updateTheme(theme)
    if let window = window {
        
        if animated, let contentView = window.contentView, window.isVisible, window.occlusionState.contains(.visible), window.windowNumber > 0 {

            let image = window.windowImageShot()
            let imageView = ImageView()
            imageView.isAccessibilityDecorative = true
            imageView.image = image
            imageView.frame = window.bounds
            contentView.addSubview(imageView)

            
            let signal = Signal<Void, NoError>.single(Void()) |> delay(0.05, queue: Queue.mainQueue()) |> afterDisposed { [weak imageView] in
                if let imageView = imageView {
                    imageView.change(opacity: 0, animated: true, removeOnCompletion: false, duration: 0.2, completion: { [weak imageView] completed in
                        imageView?.removeFromSuperview()
                    })
                }
            }
            
            appearanceDisposable.set(signal.start())
            
        }
        window.contentView?.background = theme.colors.background
        window.contentView?.subviews.first?.background = theme.colors.background
        window.appearance = theme.appearance
        
        
        window.backgroundColor = theme.colors.grayBackground
        window.titlebarAppearsTransparent = true
        
    }
    _themeSignal.set(theme)
}

public func setDefaultTheme(for window: Window? = nil) {
    ansibleUpdateTheme(generateTheme(palette: dayClassicPalette, cloudTheme: nil, bubbled: false, fontSize: 13.0, wallpaper: ThemeWallpaper()), window: window, animated: false)
}



#if !SHARE
public func generateSyntaxThemeParams(_ presentationTheme: AnsiblePresentationTheme, bubbled: Bool, isIncoming: Bool) -> [String: NSColor] {
    var textColor = presentationTheme.chat.textColor(isIncoming, bubbled)
    var grayColor = presentationTheme.chat.grayText(isIncoming, bubbled)
    var redColor = presentationTheme.chat.redUI(isIncoming, bubbled)
    var greenColor = presentationTheme.chat.greenUI(isIncoming, bubbled)
    var blueColor = presentationTheme.chat.linkColor(isIncoming, bubbled)
    var purpleColor = presentationTheme.colors.peerAvatarVioletTop

    if presentationTheme.colors.isDark {
        textColor = textColor.lighter(amount: 0.05)
        grayColor = grayColor.lighter(amount: 0.05)
        redColor = redColor.lighter(amount: 0.05)
        greenColor = greenColor.lighter(amount: 0.05)
        blueColor = blueColor.lighter(amount: 0.05)
        purpleColor = purpleColor.lighter(amount: 0.05)
    } else {
        textColor = textColor.darker(amount: 0.15)
        grayColor = grayColor.darker(amount: 0.15)
        redColor = redColor.darker(amount: 0.15)
        greenColor = greenColor.darker(amount: 0.15)
        blueColor = blueColor.darker(amount: 0.15)
        purpleColor = blueColor.darker(amount: 0.15)
    }
    return [
        "comment": grayColor,
        "block-comment": grayColor,
        "prolog": grayColor,
        "doctype": grayColor,
        "cdata": grayColor,
        "punctuation": grayColor,
        "property": purpleColor,
        "tag": greenColor,
        "boolean": greenColor,
        "number": greenColor,
        "constant": redColor,
        "symbol": redColor,
        "deleted": redColor,
        "selector": redColor,
        "attr-name": redColor,
        "string": textColor,
        "char": purpleColor,
        "builtin": textColor,
        "inserted": greenColor,
        "operator": blueColor,
        "entity": blueColor,
        "url": blueColor,
        "atrule": textColor,
        "attr-value": blueColor,
        "keyword": blueColor,
        "function-definition": greenColor,
        "class-name": redColor
    ]
}
#endif
