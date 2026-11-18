import Cocoa
import Foundation
import TGUIKit
import TelegramCore
import Postbox
import SwiftSignalKit
import Localization
import ColorPalette
import InAppSettings
import TelegramTheme
import TelegramContext
import TelegramUtils
import GeneralRows
import InputDataUI
import AvatarUI
import AlertsUI
import TelegramMediaUtils
import TelegramMedia
import LocalAnimations
import CurrencyFormat
import PremiumStatusUI
import SceneEffects
import DustLayer
import InAppPurchaseManager
import ObjcUtils
import PremiumUI
import CalendarUtils
import DateUtils
import LokiRng
import FoundationUtils
import InputView
import InputTextView
import InlineStickerLayer
import AppAnalytics



private final class Arguments {
    public let context: (any AccountContextProtocol)
    public let interactions: TextView_Interactions
    public let updateState: (Updated_ChatTextInputState)->Void
    public let setDuration:(Int)->Void
    public init(context: (any AccountContextProtocol), interactions: TextView_Interactions, updateState: @escaping(Updated_ChatTextInputState)->Void, setDuration:@escaping(Int)->Void) {
        self.context = context
        self.interactions = interactions
        self.updateState = updateState
        self.setDuration = setDuration
    }
}


private final class StarNftOfferInputItem : GeneralRowItem {
    public let inputState: Updated_ChatTextInputState
    public let arguments: Arguments
    public let interactions: TextView_Interactions
    public let currency: CurrencyAmount.Currency
    public let minStarAmount: Int64?
    
    public let usdLayout: TextViewLayout
    
    public init(_ initialSize: NSSize, stableId: AnyHashable, minStarAmount: Int64?, value: Double, inputState: Updated_ChatTextInputState, currency: CurrencyAmount.Currency, arguments: Arguments) {
        self.currency = currency
        self.inputState = inputState
        self.arguments = arguments
        self.minStarAmount = minStarAmount
        self.interactions = arguments.interactions
        
        let usd_rate = arguments.context.appConfiguration.getGeneralValueDouble("star_usd_rate", orElse: 0.013)
        
        let string: String
        if value > 0 {
            string = "~$\("\((Double(value) * usd_rate))".prettyCurrencyNumberUsd)"
        } else {
            string = ""
        }
        
        self.usdLayout = .init(.initialize(string: string, color: theme.colors.grayText, font: .normal(.short)))
        self.usdLayout.measure(width: .greatestFiniteMagnitude)
        
        super.init(initialSize, stableId: stableId)
        
    }
    
    public override var height: CGFloat {
        return 40
    }
    
    override var accessibilityLabel: String? {
        return strings().fragmentStarAmountPlaceholder
    }
    
    override var accessibilityValue: String? {
        let value = usdLayout.attributedString.string
        return value.isEmpty ? nil : value
    }
    
    public override func viewClass() -> AnyClass {
        return StarNftOfferInputView.self
    }
}


private final class StarNftOfferInputView : GeneralRowView {
    
    private final class Input : View {
        
        private weak var item: StarNftOfferInputItem?
        public let inputView: UITextView = UITextView(frame: NSMakeRect(0, 0, 100, 40))
        private let usdView = TextView()
        private let starView = InteractiveTextView()
        public required init(frame frameRect: NSRect) {
            super.init(frame: frameRect)
            addSubview(starView)
            addSubview(inputView)
            addSubview(usdView)

            layer?.cornerRadius = 10
        }
        
        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        public func update(item: StarNftOfferInputItem, animated: Bool) {
            self.item = item
            self.backgroundColor = theme.colors.background
            
            let attr = NSMutableAttributedString()
            attr.append(string: clown)
            attr.insertEmbedded(.embeddedAnimated(LocalAnimatedSticker.star_currency_new.file), for: clown)
            
            let layout = TextViewLayout(attr)
            layout.measure(width: .greatestFiniteMagnitude)
            
            self.starView.set(text: layout, context: item.arguments.context)
            self.usdView.update(item.usdLayout)
            

            
            inputView.placeholder = strings().fragmentStarAmountPlaceholder
            
            inputView.context = item.arguments.context
            inputView.interactions.max_height = 500
            inputView.interactions.min_height = 13
            inputView.interactions.emojiPlayPolicy = .onceEnd
            inputView.interactions.canTransform = false
            
            item.interactions.min_height = 13
            item.interactions.max_height = 500
            item.interactions.emojiPlayPolicy = .onceEnd
            item.interactions.canTransform = false
            
            let value = Double(item.inputState.string) ?? 0
            
            let min_resale: Double
            let max_resale: Double
            
            min_resale = item.minStarAmount.flatMap(Double.init) ?? item.arguments.context.appConfiguration.getGeneralValueDouble("stars_stargift_resale_amount_min", orElse: 125)
            max_resale = item.arguments.context.appConfiguration.getGeneralValueDouble("stars_stargift_resale_amount_max", orElse: 100000)

            inputView.inputTheme = inputView.inputTheme.withUpdatedTextColor(Double(value) < min_resale || Double(value) > max_resale ? theme.colors.redUI : theme.colors.text)
            
            
            item.interactions.filterEvent = { event in
                if let chars = event.characters {
                    return chars.trimmingCharacters(in: CharacterSet(charactersIn: "1234567890\u{7f}")).isEmpty
                } else {
                    return false
                }
            }

            self.inputView.set(item.interactions.presentation.textInputState())

            self.inputView.interactions = item.interactions
            
            item.interactions.inputDidUpdate = { [weak self] state in
                guard let `self` = self else {
                    return
                }
                self.set(state)
                self.inputDidUpdateLayout(animated: true)
            }
            
        }
        
        
        public var textWidth: CGFloat {
            return frame.width - 20
        }
        
        public func textViewSize() -> (NSSize, CGFloat) {
            return StarsHooks.shared.inputTextViewSize(inputView, textWidth)
        }
        
        private func inputDidUpdateLayout(animated: Bool) {
            self.updateLayout(size: frame.size, transition: animated ? .animated(duration: 0.2, curve: .easeOut) : .immediate)
        }
        
        public func updateLayout(size: NSSize, transition: ContainedViewLayoutTransition) {
            let (textSize, textHeight) = textViewSize()
            
            transition.updateFrame(view: starView, frame: starView.centerFrameY(x: 10))
            
            transition.updateFrame(view: inputView, frame: CGRect(origin: CGPoint(x: starView.frame.maxX + 10, y: 7), size: textSize))
            inputView.updateLayout(size: textSize, textHeight: textHeight, transition: transition)
            
            ContainedViewLayoutTransition.immediate.updateFrame(view: usdView, frame: usdView.centerFrameY(x: size.width - usdView.frame.width - 10))
        }
        
        private func set(_ state: Updated_ChatTextInputState) {
            guard let item else {
                return
            }
            item.arguments.updateState(state)
            
            item.redraw(animated: true)
        }
    }
    
    private let inputView = Input(frame: NSMakeRect(0, 0, 40, 40))
    
    public required init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        addSubview(inputView)
    }
    public override var backdorColor: NSColor {
        return theme.colors.listBackground
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func set(item: TableRowItem, animated: Bool) {
        super.set(item: item, animated: animated)
        
        guard let item = item as? StarNftOfferInputItem else {
            return
        }
        
        self.inputView.update(item: item, animated: animated)
        
               
        self.inputView.updateLayout(size: self.frame.size, transition: animated ? .animated(duration: 0.2, curve: .easeOut) : .immediate)
    }
    
    public override func shakeView() {
        inputView.shake(beep: true)
    }
    
    public override func updateLayout(size: NSSize, transition: ContainedViewLayoutTransition) {
        super.updateLayout(size: size, transition: transition)
        
        transition.updateFrame(view: inputView, frame: NSMakeRect(20, 0, size.width - 40,40))
        inputView.updateLayout(size: inputView.frame.size, transition: transition)
        
    }
    public override var firstResponder: NSResponder? {
        return inputView.inputView.inputView
    }
}

private struct StarNftOfferState : Equatable {
    
    public var inputState: Updated_ChatTextInputState = .init()
    
    public var floorPrice: Int64?
    public let currency: CurrencyAmount.Currency = .stars
    public var offerDuration: Int = 48 * 60 * 60
    
    public var myBalance: StarsAmount?
    public var sendPaidMessageseStars: StarsAmount?
    
    public var peer: EnginePeer
    public var gift: StarGift.UniqueGift

    public var value: Int64 { Int64(inputState.string) ?? 0 }

    public func amount() -> StarsAmount { .init(value: value, nanos: 0) }
    
    public var okText: String {
        let amount = self.amount()
        let string = CurrencyAmount(amount: amount, currency: currency).fullyFormatted
        if amount.value == 0 {
            return "Enter Your Offer"
        } else {
            return "Offer \(string)"
        }
    }
}


private let _id_input = InputDataIdentifier("_id_input")
private let _id_duration = InputDataIdentifier("_id_duration")

private func entries(_ state: StarNftOfferState, arguments: Arguments) -> [InputDataEntry] {
    var entries: [InputDataEntry] = []
    
    var sectionId:Int32 = 0
    var index: Int32 = 0
    
    
    entries.append(.desc(sectionId: sectionId, index: index, text: .plain("DIAMONDS TO OFFER"), data: .init(color: theme.colors.listGrayText, viewType: .textTopItem)))
    index += 1
    
    entries.append(.custom(sectionId: sectionId, index: index, value: .none, identifier: _id_input, equatable: .init(state), comparable: nil, item: { initialSize, stableId in
        return StarNftOfferInputItem(initialSize, stableId: stableId, minStarAmount: state.gift.minOfferStars, value: Double(state.value), inputState: state.inputState, currency: state.currency, arguments: arguments)
    }))
    
    let giftString = "\(state.gift.title) #\(state.gift.number)"

    
  
    entries.append(.desc(sectionId: sectionId, index: index, text: .markdown("Enter the number of Diamonds you'd like to offer **\(giftString)**.", linkHandler: { _ in }), data: .init(color: theme.colors.listGrayText, viewType: .textBottomItem)))
    index += 1
    
    entries.append(.sectionId(sectionId, type: .normal))
    sectionId += 1
    
    var items: [ContextMenuItem] = []
    var duration = [21600, 43200, 86400, 129600, 172800, 259200]
    
    if arguments.context.debug {
        duration.insert(120, at: 0)
    }
    
    for duration in duration {
        items.append(ContextMenuItem(autoremoveLocalized(duration), handler: {
            arguments.setDuration(duration)
        }, state: duration == state.offerDuration ? .on : nil))
    }
    
    entries.append(.general(
        sectionId: sectionId,
        index: index,
        value: .none,
        error: nil,
        identifier: _id_duration,
        data: .init(
            name: strings().starGiftOfferDuration,
            color: theme.colors.text,
            type: .contextSelector(autoremoveLocalized(state.offerDuration), items),
            viewType: .singleItem
        )
    ))
    
    let currency = strings().starGiftOfferCurrencyStars

    entries.append(.desc(
        sectionId: sectionId,
        index: index,
        text: .plain(strings().starGiftOfferDurationDescription(state.peer._asPeer().compactDisplayTitle, currency)),
        data: .init(
            color: theme.colors.listGrayText,
            detectBold: true,
            viewType: .textBottomItem
        )
    ))

    index += 1


    
    entries.append(.sectionId(sectionId, type: .normal))
    sectionId += 1
    
    
    return entries
}



public func StarNftOfferController(context: (any AccountContextProtocol), peer: EnginePeer, gift: StarGift.UniqueGift, callback:@escaping(CurrencyAmount, Int32, StarsAmount?)->Void) -> InputDataModalController {
    
    
    let initialState = StarNftOfferState(inputState: .init(inputText: .initialize(string: "")), peer: peer, gift: gift)

    let statePromise = ValuePromise(initialState, ignoreRepeated: true)
    let stateValue = Atomic(value: initialState)
    let updateState: ((StarNftOfferState) -> StarNftOfferState) -> Void = { f in
        statePromise.set(stateValue.modify (f))
    }
    



    let actionsDisposable = DisposableSet()
    
    var close:(()->Void)? = nil
    var getController:(()->InputDataController?)? = nil
        
    var window:Window {
        get {
            return getController?()?.window ?? context.window
        }
    }
    
    let interactions = TextView_Interactions(presentation: initialState.inputState)
    
    let sendPaidMessageseStars = context.engine.data.subscribe(TelegramEngine.EngineData.Item.Peer.SendPaidMessageStars(id: peer.id))
    
    
    actionsDisposable.add(combineLatest(context.engine.payments.cachedStarGifts(), context.starsContext.state, sendPaidMessageseStars).start(next: { gifts, starsState, sendPaidMessageseStars in
        updateState { current in
            var current = current
            current.sendPaidMessageseStars = sendPaidMessageseStars
            current.myBalance = starsState?.balance
            current.floorPrice = gifts?.first(where: { $0.generic?.title == gift.title })?.generic?.availability?.minResaleStars
            return current
        }
    }))

    let arguments = Arguments(context: context, interactions: interactions, updateState: { [weak interactions] value in
        
        let inputState = value
        interactions?.update { _ in
            return inputState
        }
        updateState { current in
            var current = current
            current.inputState = inputState
            return current
        }
    }, setDuration: { duration in
        updateState { current in
            var current = current
            current.offerDuration = duration
            return current
        }
    })
    
    let signal = statePromise.get() |> deliverOnPrepareQueue |> map { state in
        return InputDataSignalValue(entries: entries(state, arguments: arguments))
    }
    let controller = InputDataController(dataSignal: signal, title: strings().starGiftOfferTitle)
    controller.analyticsScreen = .giftsOffer
    
    controller.validateData = { _ in
        
        let state = stateValue.with { $0 }
        
        let min_resale: Double
        let max_resale: Double
        
        min_resale = gift.minOfferStars.flatMap(Double.init) ?? context.appConfiguration.getGeneralValueDouble("stars_stargift_resale_amount_min", orElse: 125)
        max_resale = context.appConfiguration.getGeneralValueDouble("stars_stargift_resale_amount_max", orElse: 100000)
        
        let value = state.value
        
        if Double(value) < min_resale || Double(value) > max_resale {
            return .fail(.fields([_id_input : .shake]))
        }
        
        
        let myBalance = state.myBalance ?? StarsAmount(value: 0, nanos: 0)
        
        let fullAmount = CurrencyAmount(amount: state.amount(), currency: state.currency)

        if fullAmount.amount.value > myBalance.value {
            let sourceValue: Star_ListScreenSource = .buy(suffix: nil, amount: fullAmount.amount.value)
            showModal(with: Star_ListScreen(context: context, source: sourceValue), for: window)
            return .none
        }
        
        let giftString = "\(gift.title) #\(gift.number)"

        let data = ModalAlertData(title: strings().starGiftOfferConfirmTitle, info: strings().starGiftOfferConfirmInfo(fullAmount.fullyFormatted, peer._asPeer().displayTitle, giftString), description: nil, ok: strings().starGiftOfferPayButton(fullAmount.fullyFormatted), options: [], mode: .confirm(text: strings().modalCancel, isThird: false), footer: ModalAlertData.Footer.init(id: "footer", value: { initialSize, stableId, presentation, action in

            var rows: [InputDataTableBasedItem.Row] = []

            rows.append(.init(left: .init(.initialize(string: strings().starGiftOfferOfferLabel, color: theme.colors.text, font: .normal(.text))), right: .init(name: .init(.initialize(string: fullAmount.formatted, color: theme.colors.text, font: .normal(.text)), maximumNumberOfLines: 1), leftView: { previous in
                let control: ImageView
                if let previous = previous as? ImageView {
                    control = previous
                } else {
                    control = ImageView(frame: NSMakeRect(0, 0, 20, 20))
                }
                    control.image = TelegramThemeHooks.shared.image(.iconStarCurrency).precomposed()
                    control.setAccessibilityLabel(strings().voiceOverCommonStars)
                return control
            })))
            
            //paid stars
            if let paid = state.sendPaidMessageseStars {
                rows.append(.init(left: .init(.initialize(string: "Message Fee", color: theme.colors.text, font: .normal(.text))), right: .init(name: .init(.initialize(string: paid.value.formattedWithSeparator, color: theme.colors.text, font: .normal(.text)), maximumNumberOfLines: 1), leftView: { previous in
                    let control: ImageView
                    if let previous = previous as? ImageView {
                        control = previous
                    } else {
                        control = ImageView(frame: NSMakeRect(0, 0, 20, 20))
                    }
                    control.image = TelegramThemeHooks.shared.image(.iconStarCurrency).precomposed()
                    control.setAccessibilityLabel(strings().voiceOverCommonStars)
                    return control
                })))
            }
            
            rows.append(.init(left: .init(.initialize(string: "Duration", color: theme.colors.text, font: .normal(.text))), right: .init(name: .init(.initialize(string: timerText(state.offerDuration), color: theme.colors.text, font: .normal(.text)), maximumNumberOfLines: 1))))

            return InputDataTableBasedItem(initialSize, stableId: stableId, viewType: .singleItem, rows: rows, context: context)
        }))
        
        showModalAlert(for: window, data: data, completion: { result in
            if let paid = state.sendPaidMessageseStars {
                let remaining = myBalance.value - fullAmount.amount.value
                if paid.value > remaining {
                    let source: Star_ListScreenSource = .buy(suffix: nil, amount: paid.value - remaining)
                    showModal(with: Star_ListScreen(context: context, source: source), for: window)
                    return
                }
            }
            callback(fullAmount, Int32(state.offerDuration), state.sendPaidMessageseStars)
            close?()
        })
                
        return .none
    }
        
    controller.onDeinit = {
        actionsDisposable.dispose()
    }
    
   
    
    let modalInteractions = ModalInteractions(acceptTitle: initialState.okText, accept: { [weak controller] in
        _ = controller?.returnKeyAction()
    }, singleButton: true)

    
    
    actionsDisposable.add(statePromise.get().startStrict(next: { [weak modalInteractions] state in
        DispatchQueue.main.async {
            modalInteractions?.updateDone { button in
                button.isEnabled = true
            }
        }
    }))
    
    let modalController = InputDataModalController(controller, modalInteractions: modalInteractions)
    
    controller.leftModalHeader = ModalHeaderData(image: theme.icons.modalClose, handler: { [weak modalController] in
        modalController?.close()
    })
    
    controller.afterTransaction = { [weak modalInteractions] controller in
        modalInteractions?.updateDone { f in
            f.set(text: stateValue.with { $0.okText }, for: .Normal)
            f.isEnabled = stateValue.with { $0.amount().value > 0 }
        }
    }
    
    close = { [weak modalController] in
        modalController?.close()
    }
    getController = { [weak controller] in
        return controller
    }
    
    
    return modalController
}
