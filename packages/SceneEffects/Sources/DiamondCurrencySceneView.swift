import Cocoa
import TGUIKit

public final class DiamondCurrencySceneView: View, PremiumSceneView {
    private let diamond = InteractiveDiamondView(frame: .zero)
    private var diamondHidden = false

    public var sceneBackground: NSColor = .clear {
        didSet {
            backgroundColor = sceneBackground
            updateDiamond()
        }
    }

    public required init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(diamond)
        updateDiamond()
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
        diamond.frame = bounds
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
        diamond.spin(3, decay: 2)
    }

    public func updateLayout(size: CGSize, transition: ContainedViewLayoutTransition) {
        diamond.frame = CGRect(origin: .zero, size: size)
        updateDiamond()
    }

    private func updateDiamond() {
        diamond.isHidden = diamondHidden
        let visible = window != nil && !isHidden && !diamondHidden
        diamond.update(size: diamond.bounds.size, diamondWidth: min(96, diamond.bounds.height * 0.7), isVisible: visible, lightBackground: (sceneBackground.usingColorSpace(.deviceRGB)?.brightnessComponent ?? 0) > 0.5)
    }
}
