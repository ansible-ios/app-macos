import Cocoa
import AnsibleUIKit
import AnsibleMedia
import LocalAnimations

public final class DiamondCurrencySceneView: View, PremiumSceneView {
    private let diamond = LottiePlayerView(frame: .zero)
    private var diamondHidden = false

    public var sceneBackground: NSColor = .clear {
        didSet {
            backgroundColor = sceneBackground
        }
    }

    public required init(frame: CGRect) {
        super.init(frame: frame)
        diamond.isEventLess = true
        addSubview(diamond)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        updateDiamond()
    }

    public override func layout() {
        super.layout()
        updateDiamond()
    }

    public func showDiamond() {
        diamondHidden = false
        updateDiamond()
    }

    public func hideDiamond() {
        diamondHidden = true
        updateDiamond()
    }

    public func playAgain() {
        diamond.playAgain()
    }

    public func updateLayout(size: CGSize, transition: ContainedViewLayoutTransition) {
        updateDiamond()
    }

    private func updateDiamond() {
        diamond.isHidden = diamondHidden
        let side = min(120, bounds.height * 0.85)
        let size = NSMakeSize(side, side)
        diamond.frame = focus(size)
        guard window != nil, !isHidden, !diamondHidden else {
            diamond.set(nil)
            return
        }
        if let data = LocalAnimatedSticker.star_currency_new.data {
            let animation = LottieAnimation(compressed: data, key: .init(key: .bundle("ansible_currency_web_v1"), size: size, backingScale: Int(System.backingScale), fitzModifier: nil), cachePurpose: .temporaryLZ4(.thumb), playPolicy: .onceEnd, maximumFps: 30)
            diamond.set(animation)
        }
    }
}
