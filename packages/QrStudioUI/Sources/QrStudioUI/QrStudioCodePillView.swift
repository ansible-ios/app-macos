import Foundation
import Cocoa
import QuartzCore
import TGUIKit
import AnsibleTheme

private final class QrStudioPillLabelView: View {
    struct Content: Equatable {
        var slashed: Bool
        var title: String
        var detail: String
    }

    static let padding: CGFloat = 12.0
    private static let diamondSide: CGFloat = 12.0
    private static let diamondSpacing: CGFloat = 3.0
    private static let dotSide: CGFloat = 3.0
    private static let dotSpacing: CGFloat = 5.0
    private static let titleFont: NSFont = .medium(12.0)
    private static let detailFont: NSFont = NSFont.monospacedDigitSystemFont(ofSize: 12.0, weight: .regular)

    private let diamondLayer = SimpleLayer()
    private let titleView = TextView()
    private let dotLayer = SimpleLayer()
    private let detailView = TextView()
    private var content: Content?
    private var color: NSColor?
    private var titleLayout: TextViewLayout?
    private var detailLayout: TextViewLayout?

    override init() {
        super.init(frame: .zero)
        self.setup()
    }

    required init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        self.isEventLess = true
        self.userInteractionEnabled = false
        self.layer?.masksToBounds = false
        self.diamondLayer.anchorPoint = CGPoint()
        self.layer?.addSublayer(self.diamondLayer)
        for textView in [self.titleView, self.detailView] {
            textView.isSelectable = false
            textView.userInteractionEnabled = false
            textView.isEventLess = true
            self.addSubview(textView)
        }
        self.dotLayer.anchorPoint = CGPoint()
        self.layer?.addSublayer(self.dotLayer)
    }

    private static func textLayout(_ text: String, font: NSFont, color: NSColor) -> TextViewLayout {
        let attributed = NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color, .kern: -0.24])
        let layout = TextViewLayout(attributed, maximumNumberOfLines: 1)
        layout.measure(width: .greatestFiniteMagnitude)
        return layout
    }

    private static func title(_ content: Content, color: NSColor) -> TextViewLayout {
        return self.textLayout(content.title, font: content.slashed ? self.titleFont : .normal(12.0), color: color)
    }

    private static func detail(_ content: Content, color: NSColor) -> TextViewLayout {
        return self.textLayout(content.detail, font: content.slashed ? self.detailFont : .normal(12.0), color: color)
    }

    private static func width(title: TextViewLayout, detail: TextViewLayout, slashed: Bool) -> CGFloat {
        let spacing = slashed ? self.diamondSpacing + self.dotSpacing * 2.0 + self.dotSide : self.diamondSpacing * 2.0
        return self.diamondSide + ceil(title.layoutSize.width) + spacing + ceil(detail.layoutSize.width)
    }

    static func width(_ content: Content) -> CGFloat {
        return self.width(title: self.title(content, color: .white), detail: self.detail(content, color: .white), slashed: content.slashed)
    }

    func update(content: Content, color: NSColor, size: CGSize, transition: ContainedViewLayoutTransition) {
        let colorChanged = self.color.map { !$0.isEqual(color) } ?? true
        if self.content?.slashed != content.slashed || colorChanged {
            let diamond = TelegramThemeHooks.shared.image(.iconMenuStar).precomposed(color)
            let side = Self.diamondSide
            self.diamondLayer.contents = generateImage(CGSize(width: side, height: side), contextGenerator: { size, context in
                context.clear(size.bounds)
                context.draw(diamond, in: size.bounds)
                if content.slashed {
                    let slash = [CGPoint(x: 1, y: side - 1), CGPoint(x: side - 1, y: 1)]
                    context.setLineCap(.round)
                    context.setBlendMode(.clear)
                    context.setLineWidth(3)
                    context.strokeLineSegments(between: slash)
                    context.setBlendMode(.normal)
                    context.setStrokeColor(color.cgColor)
                    context.setLineWidth(1)
                    context.strokeLineSegments(between: slash)
                }
            })
        }
        if self.content?.title != content.title || self.content?.slashed != content.slashed || colorChanged || self.titleLayout == nil {
            let layout = QrStudioPillLabelView.title(content, color: color)
            self.titleLayout = layout
            self.titleView.update(layout)
        }
        if self.content?.detail != content.detail || self.content?.slashed != content.slashed || colorChanged || self.detailLayout == nil {
            let layout = QrStudioPillLabelView.detail(content, color: color)
            self.detailLayout = layout
            self.detailView.update(layout)
        }
        self.dotLayer.backgroundColor = color.withAlphaComponent(color.alphaComponent * 0.5).cgColor
        self.dotLayer.isHidden = !content.slashed
        self.content = content
        self.color = color

        guard let titleLayout = self.titleLayout, let detailLayout = self.detailLayout else {
            return
        }

        let midY = size.height * 0.5
        var x = floor((size.width - QrStudioPillLabelView.width(title: titleLayout, detail: detailLayout, slashed: content.slashed)) * 0.5)
        let diamondSide = QrStudioPillLabelView.diamondSide

        func place(_ textView: TextView, layout: TextViewLayout) {
            let textSize = CGSize(width: ceil(layout.layoutSize.width), height: ceil(layout.layoutSize.height))
            transition.updateFrame(view: textView, frame: CGRect(x: x, y: floorToScreenPixels((size.height - textSize.height) * 0.5), width: textSize.width, height: textSize.height))
            x += textSize.width
        }
        if !content.slashed {
            place(self.titleView, layout: titleLayout)
            x += QrStudioPillLabelView.diamondSpacing
        }
        transition.updateFrame(layer: self.diamondLayer, frame: CGRect(x: x, y: midY - diamondSide * 0.5, width: diamondSide, height: diamondSide))
        x += diamondSide + QrStudioPillLabelView.diamondSpacing
        if content.slashed {
            place(self.titleView, layout: titleLayout)
            x += QrStudioPillLabelView.dotSpacing
            let dotSide = QrStudioPillLabelView.dotSide
            transition.updateFrame(layer: self.dotLayer, frame: CGRect(x: x, y: midY - dotSide * 0.5, width: dotSide, height: dotSide))
            self.dotLayer.cornerRadius = dotSide * 0.5
            x += dotSide + QrStudioPillLabelView.dotSpacing
        }
        place(self.detailView, layout: detailLayout)
    }
}

final class QrStudioCodePillView: View {
    struct Texts: Equatable {
        let free: String
        static let currencyMarker: Character = "\u{fffc}"
        let removeFee: String
        let permanent: String
        let expiresIn: (String) -> String

        static func ==(lhs: Texts, rhs: Texts) -> Bool {
            return lhs.free == rhs.free && lhs.removeFee == rhs.removeFee && lhs.permanent == rhs.permanent
        }
    }

    static let height: CGFloat = 24.0
    static let resizeDuration: Double = 0.5
    static let resizeDamping: CGFloat = 0.82

    var tapPaid: (() -> Void)?
    var openMenu: ((NSView) -> Void)?
    var needsNextCode: (() -> Void)?

    private let containerView = View()
    private let glass = LiquidGlassView(frame: .zero, cornerRadius: QrStudioCodePillView.height * 0.5, hasShadow: false, hasBorder: true, tintAlpha: 0.0, forceAppearance: .forceDark)
    private let contentView = View()
    private let glyphLabel = QrStudioPillLabelView()
    private let foregroundView = View()
    private let whiteClipView = View()
    private let whiteMask = SimpleShapeLayer()
    private let flashView = View()
    private let flashMask = SimpleShapeLayer()
    private let inkLabel = QrStudioPillLabelView()
    private let inkMask = SimpleShapeLayer()
    private let particlesLayer = SimpleLayer()
    private let haloLayer = SimpleShapeLayer()
    private var coreLayers: [SimpleShapeLayer] = []

    private var state = QrStudioCodeState()
    private var ink = QrStudioColor(0.5, 0.5, 0.5)
    private var isLight = false
    private var texts: Texts?
    private var shatter: QrStudioShatter?
    private var displayLink: SharedDisplayLinkDriver.Link?
    private var lastShapeTick: Double = -1.0
    private var isPressed = false
    private var isMouseDown = false
    private var pillWidth: CGFloat = 0.0
    private var appliedSize = CGSize()
    private var appliedSizeOnce = false

    private static let heatLevels = 3
    private static let alphaLevels = 5
    private static let particleMargin = CGSize(width: 90.0, height: 76.0)

    override init() {
        super.init(frame: .zero)
        self.setup()
    }

    required init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        self.layer?.masksToBounds = false

        self.containerView.layer?.masksToBounds = false
        self.addSubview(self.containerView)

        self.containerView.addSubview(self.glass)

        self.contentView.isEventLess = true
        self.contentView.layer?.masksToBounds = false
        self.containerView.addSubview(self.contentView)

        self.contentView.addSubview(self.glyphLabel)

        self.whiteClipView.isEventLess = true
        self.whiteClipView.layer?.masksToBounds = true
        self.whiteClipView.layer?.cornerRadius = QrStudioCodePillView.height * 0.5
        self.whiteClipView.layer?.mask = self.whiteMask
        self.contentView.addSubview(self.whiteClipView)

        self.flashView.isEventLess = true
        self.flashView.backgroundColor = .white
        self.flashView.layer?.masksToBounds = true
        self.flashView.layer?.cornerRadius = QrStudioCodePillView.height * 0.5
        self.flashView.layer?.mask = self.flashMask
        self.flashView.layer?.opacity = 0.0
        self.contentView.addSubview(self.flashView)

        self.inkLabel.layer?.mask = self.inkMask
        self.contentView.addSubview(self.inkLabel)

        self.foregroundView.isEventLess = true
        self.foregroundView.layer?.masksToBounds = false
        self.containerView.addSubview(self.foregroundView)

        self.particlesLayer.isHidden = true
        self.foregroundView.layer?.addSublayer(self.particlesLayer)
        self.haloLayer.compositingFilter = "plusL"
        self.particlesLayer.addSublayer(self.haloLayer)
        for _ in 0 ..< QrStudioCodePillView.heatLevels * QrStudioCodePillView.alphaLevels {
            let layer = SimpleShapeLayer()
            self.particlesLayer.addSublayer(layer)
            self.coreLayers.append(layer)
        }
    }

    override func hitTest(_ point: NSPoint) -> NSView? {
        guard !self.isHidden, self.userInteractionEnabled, self.alphaValue > 0.01, (self.layer?.opacity ?? 1.0) > 0.01 else {
            return nil
        }
        let local = self.convert(point, from: self.superview)
        return self.bounds.insetBy(dx: -10.0, dy: -10.0).contains(local) ? self : nil
    }

    override func mouseDown(with event: NSEvent) {
        guard self.userInteractionEnabled else {
            super.mouseDown(with: event)
            return
        }
        self.isMouseDown = true
        if !self.state.removeFee {
            self.setPressed(true)
        }
    }

    override func mouseUp(with event: NSEvent) {
        guard self.isMouseDown else {
            super.mouseUp(with: event)
            return
        }
        self.isMouseDown = false
        self.setPressed(false)
        let point = self.convert(event.locationInWindow, from: nil)
        guard self.userInteractionEnabled, self.bounds.insetBy(dx: -10.0, dy: -10.0).contains(point) else {
            return
        }
        if self.state.removeFee {
            self.openMenu?(self)
        } else {
            self.tapPaid?()
        }
    }

    override func rightMouseDown(with event: NSEvent) {
        guard self.userInteractionEnabled, self.state.removeFee else {
            super.rightMouseDown(with: event)
            return
        }
        self.openMenu?(self)
    }

    private static func scaleTransform(_ scale: CGFloat, layer: CALayer) -> CATransform3D {
        let dx = layer.bounds.width * (0.5 - layer.anchorPoint.x)
        let dy = layer.bounds.height * (0.5 - layer.anchorPoint.y)
        var transform = CATransform3DMakeTranslation(dx, dy, 0.0)
        transform = CATransform3DScale(transform, scale, scale, 1.0)
        transform = CATransform3DTranslate(transform, -dx, -dy, 0.0)
        return transform
    }

    private func setPressed(_ isPressed: Bool) {
        guard self.isPressed != isPressed, let layer = self.layer else {
            return
        }
        self.isPressed = isPressed
        let scale: CGFloat = isPressed ? 0.93 : 1.0
        let from = layer.presentation()?.transform ?? QrStudioCodePillView.scaleTransform(isPressed ? 1.0 : 0.93, layer: layer)
        let animation = CASpringAnimation(keyPath: "transform")
        animation.fromValue = NSValue(caTransform3D: from)
        animation.toValue = NSValue(caTransform3D: QrStudioCodePillView.scaleTransform(scale, layer: layer))
        animation.stiffness = 438.0
        animation.damping = 23.0
        animation.duration = 0.5
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = !isPressed
        layer.add(animation, forKey: "press")
    }

    func animatePourBump() {
        guard let layer = self.containerView.layer else {
            return
        }
        let animation = CAKeyframeAnimation(keyPath: "transform")
        let scales: [CGFloat] = [1.0, 1.0, 1.08, 1.0]
        animation.values = scales.map { NSValue(caTransform3D: QrStudioCodePillView.scaleTransform($0, layer: layer)) }
        animation.keyTimes = [0.0, NSNumber(value: QrStudioBurn.refill / 0.74), NSNumber(value: (QrStudioBurn.refill + 0.06) / 0.74), 1.0]
        animation.timingFunctions = [CAMediaTimingFunction(name: .linear), CAMediaTimingFunction(name: .easeOut), CAMediaTimingFunction(name: .easeInEaseOut)]
        animation.duration = 0.74
        layer.add(animation, forKey: "pourBump")
    }

    func startShatter(at time: Double) {
        self.startShatter(at: time, level: QrStudioBurn.level(self.state, at: time))
    }

    func startShatter(at time: Double, level: Double) {
        guard level > 0.005, self.pillWidth > 0.0 else {
            return
        }
        self.shatter = QrStudioShatter(at: time, width: self.pillWidth, level: level)
        self.updateDisplayLink()
    }

    private func labelContent(at time: Double) -> QrStudioPillLabelView.Content? {
        guard let texts = self.texts else {
            return nil
        }
        if !self.state.removeFee {
            let parts = texts.removeFee.split(separator: Texts.currencyMarker, maxSplits: 1, omittingEmptySubsequences: false)
            var title = String(parts[0]).trimmingCharacters(in: .whitespaces)
            if let last = title.last, ["⭐", "⭐️", "💎"].contains(String(last)) {
                title.removeLast()
            }
            let detail = parts.count == 2 ? String(parts[1]) : ""
            return QrStudioPillLabelView.Content(slashed: false, title: title.trimmingCharacters(in: .whitespaces), detail: detail)
        }
        let detail: String
        if self.state.expires {
            detail = texts.expiresIn(QrStudioBurn.clock(self.state.remaining(at: time)))
        } else {
            detail = texts.permanent
        }
        return QrStudioPillLabelView.Content(slashed: true, title: texts.free, detail: detail)
    }

    private var glyphColor: NSColor {
        return self.isLight ? QrStudioColor(0.1, 0.1, 0.1).nsColor : QrStudioColor(0.96, 0.96, 0.96).nsColor
    }

    private var inkLabelColor: NSColor {
        return self.isLight ? QrStudioColor(1.0, 1.0, 1.0).nsColor : self.ink.nsColor
    }

    private func updateLabels(at time: Double, size: CGSize, transition: ContainedViewLayoutTransition) {
        guard let content = self.labelContent(at: time) else {
            return
        }
        self.glyphLabel.update(content: content, color: self.glyphColor, size: size, transition: transition)
        self.inkLabel.update(content: content, color: self.inkLabelColor, size: size, transition: transition)
    }

    private(set) var isTaken = false

    func setTaken(_ isTaken: Bool, animated: Bool = true) {
        guard self.isTaken != isTaken, let layer = self.foregroundView.layer else {
            return
        }
        self.isTaken = isTaken
        let alpha: Float = isTaken ? 0.0 : 1.0
        guard animated else {
            layer.removeAllAnimations()
            layer.opacity = alpha
            return
        }
        let from = layer.presentation()?.opacity ?? layer.opacity
        layer.opacity = alpha
        layer.animate(from: NSNumber(value: from), to: NSNumber(value: alpha), keyPath: "opacity", timingFunction: .easeInEaseOut, duration: isTaken ? 0.16 / 3.0 : 0.25, delay: isTaken ? 0.0 : 0.2)
    }

    func update(state: QrStudioCodeState, ink: QrStudioColor, isLight: Bool, texts: Texts, transition: ContainedViewLayoutTransition) -> CGSize {
        let previousState = self.state
        let colorsChanged = self.appliedSizeOnce && (self.isLight != isLight || self.ink != ink)
        if self.appliedSizeOnce && self.isLight != isLight && transition.isAnimated {
            let fade = CATransition()
            fade.type = .fade
            fade.duration = 0.45
            fade.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            self.glass.layer?.add(fade, forKey: "appearance")
        }
        self.state = state
        self.ink = ink
        self.isLight = isLight
        self.texts = texts

        let time = QrStudioClock.now
        let contentWidth = self.labelContent(at: time).map { QrStudioPillLabelView.width($0) } ?? 0.0
        let size = CGSize(width: ceil(contentWidth) + QrStudioPillLabelView.padding * 2.0, height: QrStudioCodePillView.height)
        self.pillWidth = size.width

        if previousState.removeFee != state.removeFee || previousState.expires != state.expires {
            let fade = CATransition()
            fade.type = .fade
            fade.duration = 0.2
            self.glyphLabel.layer?.add(fade, forKey: "text")
            self.inkLabel.layer?.add(fade, forKey: "text")
        }
        if colorsChanged && transition.isAnimated {
            let fade = CATransition()
            fade.type = .fade
            fade.duration = 0.35
            self.glyphLabel.layer?.add(fade, forKey: "colors")
            self.inkLabel.layer?.add(fade, forKey: "colors")
        }

        let sizeChanged = self.appliedSize != size
        self.appliedSize = size
        if sizeChanged && transition.isAnimated && self.appliedSizeOnce {
            self.applyLayout(size: size, time: time, transition: .animated(duration: QrStudioCodePillView.resizeDuration, curve: .spring))
        } else {
            self.applyLayout(size: size, time: time, transition: transition)
        }
        self.appliedSizeOnce = true

        self.lastShapeTick = -1.0
        self.applyFrame(time: time)
        self.updateDisplayLink()
        return size
    }

    override func layout() {
        super.layout()
        let size = self.bounds.size
        guard self.appliedSizeOnce, size.width > 0.0, size != self.appliedSize else {
            return
        }
        self.appliedSize = size
        self.pillWidth = size.width
        let time = QrStudioClock.now
        self.applyLayout(size: size, time: time, transition: .immediate)
        self.lastShapeTick = -1.0
        self.applyFrame(time: time)
    }

    private func applyLayout(size: CGSize, time: Double, transition: ContainedViewLayoutTransition) {
        let isLight = self.isLight
        let ink = self.ink
        let bounds = CGRect(origin: CGPoint(), size: size)

        transition.updateFrame(view: self.containerView, frame: bounds)
        let appearance: LiquidGlassAppearance = isLight ? .forceLight : .forceDark
        if self.glass.forceAppearance != appearance {
            self.glass.forceAppearance = appearance
            self.glass.updateLocalizationAndTheme(theme: presentation)
        }
        self.glass.cornerRadius = size.height * 0.5
        transition.updateFrame(view: self.glass, frame: bounds)
        self.glass.updateLayout(size: size, transition: transition)
        transition.updateFrame(view: self.contentView, frame: bounds)
        transition.updateFrame(view: self.glyphLabel, frame: bounds)

        let tint = isLight ? ink.nsColor.withAlphaComponent(0.85) : QrStudioColor(1.0, 1.0, 1.0).nsColor.withAlphaComponent(0.82)
        transition.updateFrame(view: self.foregroundView, frame: bounds)
        transition.updateFrame(view: self.whiteClipView, frame: bounds)
        self.whiteClipView.layer?.cornerRadius = size.height * 0.5
        self.whiteClipView.backgroundColor = tint
        transition.updateFrame(view: self.inkLabel, frame: bounds)
        self.updateLabels(at: time, size: size, transition: transition)
        transition.updateFrame(view: self.flashView, frame: bounds)
        self.flashView.layer?.cornerRadius = size.height * 0.5

        let margin = QrStudioCodePillView.particleMargin
        self.particlesLayer.frame = bounds.insetBy(dx: -margin.width, dy: -margin.height)
    }

    var isActive: Bool = true {
        didSet {
            if self.isActive != oldValue {
                self.updateDisplayLink()
            }
        }
    }

    private var needsDisplayLink: Bool {
        if let shatter = self.shatter, QrStudioClock.now - shatter.at < QrStudioShatter.duration {
            return true
        }
        return self.isActive && self.state.removeFee && self.state.expires && self.window != nil
    }

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        self.updateDisplayLink()
    }

    private func updateDisplayLink() {
        if self.needsDisplayLink {
            if self.displayLink == nil {
                self.displayLink = SharedDisplayLinkDriver.shared.add(framesPerSecond: .fps(60), { [weak self] _ in
                    self?.tick()
                })
            }
        } else if let displayLink = self.displayLink {
            displayLink.invalidate()
            self.displayLink = nil
        }
    }

    private func tick() {
        let time = QrStudioClock.now
        if self.state.needsNextCode(at: time) {
            self.needsNextCode?()
        }
        if let shatter = self.shatter, time - shatter.at >= QrStudioShatter.duration {
            self.shatter = nil
        }
        self.applyFrame(time: time)
        self.updateDisplayLink()
    }

    private func applyFrame(time: Double) {
        let size = CGSize(width: self.pillWidth, height: QrStudioCodePillView.height)
        guard size.width > 0.0 else {
            return
        }
        CATransaction.begin()
        CATransaction.setDisableActions(true)

        let rect = CGRect(origin: CGPoint(), size: size)
        let pouring = QrStudioBurn.isPouring(self.state, at: time)
        let shapeTick = pouring ? time : floor(time * 20.0) / 20.0
        if shapeTick != self.lastShapeTick {
            self.lastShapeTick = shapeTick
            let front = QrStudioBurn.front(self.state, width: size.width, at: shapeTick)
            let path = QrStudioBurn.cutPath(front: front, rect: rect, time: shapeTick, liquid: QrStudioBurn.liquid(self.state, at: shapeTick))
            self.whiteMask.path = path
            self.inkMask.path = path
            self.flashMask.path = path
            let hasWhite = path != nil
            self.whiteClipView.isHidden = !hasWhite
            self.inkLabel.isHidden = !hasWhite

            if self.state.removeFee && self.state.expires {
                self.updateLabels(at: time, size: size, transition: .immediate)
            }
        }

        if let shatter = self.shatter {
            let since = time - shatter.at
            let snap = Float(max(0.0, 1.0 - since / 0.06))
            self.whiteClipView.layer?.opacity = snap
            self.inkLabel.layer?.opacity = snap
        } else {
            self.whiteClipView.layer?.opacity = 1.0
            self.inkLabel.layer?.opacity = 1.0
        }
        self.flashView.layer?.opacity = Float(0.7 * QrStudioBurn.flash(self.state, at: time))

        var particles = QrStudioBurn.timerParticles(self.state, pill: size, at: time)
        if let shatter = self.shatter {
            particles.append(contentsOf: QrStudioBurn.shatterParticles(shatter, at: time))
        }
        self.drawParticles(particles)

        CATransaction.commit()
    }

    private func drawParticles(_ particles: [QrStudioParticle]) {
        self.particlesLayer.isHidden = particles.isEmpty
        guard !particles.isEmpty else {
            return
        }
        let margin = QrStudioCodePillView.particleMargin
        let heatLevels = QrStudioCodePillView.heatLevels
        let alphaLevels = QrStudioCodePillView.alphaLevels
        let halo = CGMutablePath()
        var cores: [CGMutablePath] = []
        for _ in 0 ..< heatLevels * alphaLevels {
            cores.append(CGMutablePath())
        }
        var haloAlpha = 0.0
        for particle in particles {
            let rect = CGRect(x: particle.x + margin.width - particle.radius, y: particle.y + margin.height - particle.radius, width: particle.radius * 2.0, height: particle.radius * 2.0)
            if particle.halo {
                halo.addEllipse(in: rect)
                haloAlpha = max(haloAlpha, particle.alpha)
            } else {
                let heatIndex = max(0, min(heatLevels - 1, Int(particle.heat * Double(heatLevels))))
                let alphaIndex = max(0, min(alphaLevels - 1, Int(particle.alpha * Double(alphaLevels))))
                cores[heatIndex * alphaLevels + alphaIndex].addEllipse(in: rect)
            }
        }
        let hot = self.isLight ? self.ink.pastel : QrStudioColor(1.0, 1.0, 1.0)
        let ash = self.isLight ? self.ink : QrStudioColor(1.0, 1.0, 1.0)
        self.haloLayer.frame = self.particlesLayer.bounds
        self.haloLayer.path = halo
        self.haloLayer.fillColor = hot.cgColor
        self.haloLayer.opacity = Float(min(1.0, haloAlpha * 2.0))
        self.haloLayer.compositingFilter = self.isLight ? nil : "plusL"
        for heatIndex in 0 ..< heatLevels {
            let heat = (Double(heatIndex) + 0.5) / Double(heatLevels)
            let tone = QrStudioColor.mix(ash, hot, CGFloat(heat))
            for alphaIndex in 0 ..< alphaLevels {
                let layer = self.coreLayers[heatIndex * alphaLevels + alphaIndex]
                layer.frame = self.particlesLayer.bounds
                layer.path = cores[heatIndex * alphaLevels + alphaIndex]
                layer.fillColor = tone.cgColor
                layer.opacity = Float((Double(alphaIndex) + 0.5) / Double(alphaLevels))
            }
        }
    }
}
