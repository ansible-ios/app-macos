import Cocoa
import TGUIKit
import SwiftSignalKit
import InputView
import TelegramCore
import Postbox
import CurrencyFormat
import Localization
import AnsibleTheme
import AnsibleContext
import AnsibleUtils
import GeneralRows
import InputDataUI
import InputTextView
import LocalAnimations
import ChatHistoryModel
import StarsUI
import InlineStickerLayer
import AppAnalytics

private final class HeaderItem : GeneralRowItem {
    fileprivate let titleLayout: TextViewLayout
    fileprivate let balance: TextViewLayout
    private let spokenBalance: String
    fileprivate let arguments: Arguments
    fileprivate let hasBalance: Bool
    init(_ initialSize: NSSize, stableId: AnyHashable, currency: CurrencyAmount.Currency, balance: Int64, title: String, hasBalance: Bool, arguments: Arguments) {
        self.arguments = arguments
        self.hasBalance = hasBalance
        self.titleLayout = .init(.initialize(string: title, color: theme.colors.text, font: .medium(.text)), maximumNumberOfLines: 1)
        let attr = NSMutableAttributedString()
        
        let formatted = balance.formattedWithSeparator
        
        self.spokenBalance = strings().starPurchaseBalance("\(formatted) \(strings().starListTelegramStars)")
        attr.append(string: strings().starPurchaseBalance("\(clown + TINY_SPACE)\(formatted)"), color: theme.colors.text, font: .normal(.text))
        attr.insertEmbedded(.embeddedAnimated(LocalAnimatedSticker.star_currency_new.file), for: clown)
        
        self.balance = .init(attr)
        self.balance.measure(width: .greatestFiniteMagnitude)
        
        self.titleLayout.measure(width: initialSize.width - self.balance.layoutSize.width - 40)
        
        super.init(initialSize, height: 50, stableId: stableId)
    }
    
    override func viewClass() -> AnyClass {
        return HeaderView.self
    }

    override var accessibilityLabel: String? {
        return titleLayout.attributedString.string
    }

    override var accessibilityValue: String? {
        return hasBalance ? spokenBalance : nil
    }
}

private final class HeaderView : GeneralRowView {
    private let title = InteractiveTextView()
    private let balance = InteractiveTextView()
    private let dismiss = ImageButton()
    required init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        addSubview(title)
        addSubview(balance)
        addSubview(dismiss)
        
        dismiss.set(handler: { [weak self] _ in
            if let item = self?.item as? HeaderItem {
                item.arguments.close()
            }
        }, for: .Click)
        dismiss.setAccessibilityLabel(strings().voiceOverCommonClose)
    }
    
    override var backdorColor: NSColor {
        return theme.colors.listBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func set(item: TableRowItem, animated: Bool) {
        super.set(item: item, animated: animated)
        
        guard let item = item as? HeaderItem else {
            return
        }
        
        dismiss.set(image: theme.icons.glass_close, for: .Normal)
        dismiss.setGlassEffect(size: NSMakeSize(36, 36))
        dismiss.sizeToFit(.zero, NSMakeSize(36, 36), thatFit: true)
        dismiss.autohighlight = false
        dismiss.scaleOnClick = true
        
        
        balance.isHidden = !item.hasBalance
        
        
        title.set(text: item.titleLayout, context: item.arguments.context)
        balance.set(text: item.balance, context: item.arguments.context)
        
        needsLayout = true

    }
    
    override func layout() {
        super.layout()
        
        title.center()
        balance.centerY(x: frame.width - balance.frame.width - 20)
        dismiss.centerY(x: 20)
    }
}


private final class InputItem : GeneralRowItem {
    let inputState: Updated_ChatTextInputState
    let arguments: Arguments
    let interactions: TextView_Interactions
    let balance: StarsAmount
    let value: Int64
    let currency: CurrencyAmount.Currency
    let hasBalance: Bool
    let usdLayout: TextViewLayout
    init(_ initialSize: NSSize, stableId: AnyHashable, value: Int64, currency: CurrencyAmount.Currency, balance: StarsAmount, inputState: Updated_ChatTextInputState, hasBalance: Bool, arguments: Arguments) {
        self.inputState = inputState
        self.arguments = arguments
        self.balance = balance
        self.currency = currency
        self.value = value
        self.hasBalance = hasBalance
        self.interactions = arguments.interactions
        
        let usd_rate: Double
        usd_rate = arguments.context.appConfiguration.getGeneralValueDouble("star_usd_rate", orElse: 0.013)
        
        let units = Double(value)
        self.usdLayout = .init(.initialize(string: "~\("\(units * usd_rate)".prettyCurrencyNumberUsd)", color: theme.colors.grayText, font: .normal(.short)))
        self.usdLayout.measure(width: .greatestFiniteMagnitude)
        super.init(initialSize, stableId: stableId)
    }
    
    override var height: CGFloat {
        return 40
    }
    
    override func viewClass() -> AnyClass {
        return InputView.self
    }

    override var accessibilityLabel: String? {
        return strings().fragmentStarAmountPlaceholder
    }

    override var accessibilityValue: String? {
        return usdLayout.attributedString.string
    }
}


private final class InputView : GeneralRowView {
    
    
    private final class Input : View {
        
        private weak var item: InputItem?
        let inputView: UITextView = UITextView(frame: NSMakeRect(0, 0, 100, 40))
        private let starView = InteractiveTextView()
        private let usdView = TextView()
        required init(frame frameRect: NSRect) {
            super.init(frame: frameRect)
            addSubview(starView)
            addSubview(inputView)
            addSubview(usdView)

            layer?.cornerRadius = 10
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func update(item: InputItem, animated: Bool) {
            self.item = item
            self.backgroundColor = theme.colors.background
            
            let attr = NSMutableAttributedString()
            attr.append(string: clown)
            attr.insertEmbedded(.embeddedAnimated(LocalAnimatedSticker.star_currency_new.file), for: clown)
            
            let layout = TextViewLayout(attr)
            layout.measure(width: .greatestFiniteMagnitude)
            
            self.starView.set(text: layout, context: item.arguments.context)
            self.usdView.update(item.usdLayout)

            
            inputView.placeholder = item.accessibilityLabel ?? ""
            
            inputView.context = item.arguments.context
            inputView.interactions.max_height = 500
            inputView.interactions.min_height = 13
            inputView.interactions.emojiPlayPolicy = .onceEnd
            inputView.interactions.canTransform = false
            
            item.interactions.min_height = 13
            item.interactions.max_height = 500
            item.interactions.emojiPlayPolicy = .onceEnd
            item.interactions.canTransform = false
            
            let value = item.value
            let max = item.balance.value
            
            inputView.inputTheme = inputView.inputTheme.withUpdatedTextColor(value > max && item.hasBalance ? theme.colors.redUI : theme.colors.text)
            
            
            item.interactions.filterEvent = { event in
                return digitsOnlyFilterEvent(event)
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
        
        
        var textWidth: CGFloat {
            guard let item else {
                return frame.width - 20
            }
            return frame.width - 20 - item.usdLayout.layoutSize.width - 10
        }
        
        func textViewSize() -> (NSSize, CGFloat) {
            return inputTextViewSize(inputView, width: textWidth)
        }
        
        private func inputDidUpdateLayout(animated: Bool) {
            self.updateLayout(size: frame.size, transition: animated ? .animated(duration: 0.2, curve: .easeOut) : .immediate)
        }
        
        func updateLayout(size: NSSize, transition: ContainedViewLayoutTransition) {
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
    
    required init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        addSubview(inputView)
    }
    override var backdorColor: NSColor {
        return theme.colors.listBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func set(item: TableRowItem, animated: Bool) {
        super.set(item: item, animated: animated)
        
        guard let item = item as? InputItem else {
            return
        }
        
        self.inputView.update(item: item, animated: animated)
               
        
        self.inputView.updateLayout(size: self.frame.size, transition: animated ? .animated(duration: 0.2, curve: .easeOut) : .immediate)
    }
    
    override func shakeView() {
        inputView.shake(beep: true)
    }
    
    override func updateLayout(size: NSSize, transition: ContainedViewLayoutTransition) {
        super.updateLayout(size: size, transition: transition)
        
        transition.updateFrame(view: inputView, frame: NSMakeRect(20, 0, size.width - 40,40))
        inputView.updateLayout(size: inputView.frame.size, transition: transition)
        
    }
    override var firstResponder: NSResponder? {
        return inputView.inputView.inputView
    }
}



private final class Arguments {
    let context: any AccountContextProtocol
    let interactions: TextView_Interactions
    let updateState: (Updated_ChatTextInputState)->Void
    let close:()->Void
    let date:()->Void
    init(context: any AccountContextProtocol, interactions: TextView_Interactions, updateState: @escaping(Updated_ChatTextInputState)->Void, close:@escaping()->Void, date:@escaping()->Void) {
        self.context = context
        self.interactions = interactions
        self.updateState = updateState
        self.close = close
        self.date = date
    }
}

private struct State : Equatable {
    var starAmount: Int64 = 0
    let currency: CurrencyAmount.Currency = .stars
    var inputState: Updated_ChatTextInputState = .init()
    var date: Int32?
    var mode: ChatInterfaceState.ChannelSuggestPost.Mode
    var starsState: StarsContext.State?
    var peer: EnginePeer?
    
    var effectiveState: StarsContext.State? { starsState }
    var amount: Int64 {
        get { starAmount }
        set { starAmount = newValue }
    }
    
    var starsAmount: StarsAmount {
        return .init(value: amount, nanos: 0)
    }
    
    var currencyAmount: CurrencyAmount {
        return .init(amount: starsAmount, currency: currency)
    }
    
    var result: ChatInterfaceState.ChannelSuggestPost {
        return .init(amount: currencyAmount, date: date, mode: mode)
    }
    
    var ok: String {
        switch mode {
        case .edit, .suggest:
            return strings().editPostSuggestionActionUpdate
        case .new:
            return strings().editPostSuggestionActionOffer(currencyAmount.suggestedPostAmountText)
        }
    }
}

private let _id_input = InputDataIdentifier("_id_input")
private let _id_date = InputDataIdentifier("_id_date")

private func entries(_ state: State, arguments: Arguments) -> [InputDataEntry] {
    var entries:[InputDataEntry] = []
    
    var sectionId:Int32 = 0
    var index: Int32 = 0
    
    let title: String
    let hasBalance: Bool
    switch state.mode {
    case .new:
        title = strings().editPostSuggestionTitleNew
        hasBalance = true
    case .edit:
        title = strings().editPostSuggestionTitleEdit
        hasBalance = true
    case .suggest:
        title = strings().editPostSuggestionTitleSuggest
        hasBalance = false
    }
    
    if let starsState = state.effectiveState, let peer = state.peer {
        
        entries.append(.custom(sectionId: sectionId, index: index, value: .none, identifier: .init("header"), equatable: .init(state), comparable: nil, item: { initialSize, stableId in
            return HeaderItem(initialSize, stableId: stableId, currency: state.currency, balance: starsState.balance.value, title: title, hasBalance: hasBalance, arguments: arguments)
        }))
        
        entries.append(.sectionId(sectionId, type: .customModern(10)))
        sectionId += 1
        
        
        let inputHeader: String
        let inputInfo: String
        inputHeader = strings().editPostSuggestionPriceLabel
        inputInfo = strings().editPostSuggestionPriceDescription(peer._asPeer().displayTitle)
              
        entries.append(.desc(sectionId: sectionId, index: index, text: .plain(inputHeader), data: .init(color: theme.colors.listGrayText, viewType: .textTopItem)))
        index += 1
        
        entries.append(.custom(sectionId: sectionId, index: index, value: .none, identifier: _id_input, equatable: .init(state), comparable: nil, item: { initialSize, stableId in
            return InputItem(initialSize, stableId: stableId, value: state.amount, currency: state.currency, balance: starsState.balance, inputState: state.inputState, hasBalance: hasBalance, arguments: arguments)
        }))
        
        entries.append(.desc(sectionId: sectionId, index: index, text: .plain(inputInfo), data: .init(color: theme.colors.listGrayText, viewType: .textBottomItem)))

        index += 1
    }
    

    // entries
    
    entries.append(.sectionId(sectionId, type: .normal))
    sectionId += 1
    
    
    entries.append(.general(sectionId: sectionId, index: index, value: .none, error: nil, identifier: _id_date, data: .init(name: strings().editPostSuggestionTimeLabel, color: theme.colors.text, type: .nextContext(state.date.flatMap({ stringForDate(timestamp: $0) }) ?? strings().editPostSuggestionTimeAnytime), viewType: .singleItem, action: arguments.date)))
    
    entries.append(.desc(sectionId: sectionId, index: index, text: .plain(strings().editPostSuggestionTimeDescription), data: .init(color: theme.colors.listGrayText, viewType: .textBottomItem)))
    index += 1
    
    entries.append(.sectionId(sectionId, type: .normal))
    sectionId += 1
    
    return entries
}

public func EditPostSuggestionController(chatInteraction: ChatInteraction, data: ChatInterfaceState.ChannelSuggestPost) -> InputDataModalController? {
    guard data.amount?.currency != .ton else { return nil }
    
    let context = chatInteraction.context

    let actionsDisposable = DisposableSet()
    
    let min_stars = context.appConfiguration.getGeneralValue64("stars_suggested_post_amount_min", orElse: 5)

    
    let amount = data.amount ?? .init(amount: .init(value: min_stars, nanos: 0), currency: .stars)

    let starAmount = amount.currency == .stars ? amount.amount.value : min_stars
    let initialState = State(starAmount: starAmount, inputState: .init(inputText: .initialize(string: String(starAmount))), date: data.date, mode: data.mode)

    let statePromise = ValuePromise(initialState, ignoreRepeated: true)
    let stateValue = Atomic(value: initialState)
    let updateState: ((State) -> State) -> Void = { f in
        statePromise.set(stateValue.modify (f))
    }
    
    var getController:(()->ViewController?)? = nil
    var close:(()->Void)? = nil
    
    var window:Window {
        get {
            return bestWindow(context, getController?())
        }
    }
    
    let peer = context.engine.data.get(TelegramEngine.EngineData.Item.Peer.RenderedPeer(id: chatInteraction.peerId))
    
    actionsDisposable.add(combineLatest(context.starsContext.state, peer).startStrict(next: { state, peer in
        updateState { current in
            var current = current
            current.starsState = state
            current.peer = peer?.chatOrMonoforumMainPeer
            return current
        }
    }))
        
    let interactions = TextView_Interactions(presentation: initialState.inputState)
    
    let max_stars = context.appConfiguration.getGeneralValue64("stars_suggested_post_amount_max", orElse: 10000)
    

    let arguments = Arguments(context: context, interactions: interactions, updateState: { [weak interactions] value in
                
        let previous = value.string
        let maximum = max_stars
        let minimum = min_stars
        
        let parsed = previous.isEmpty ? 0 : Int64(previous)
        let number = parsed.map { max(min($0, maximum), minimum) } ?? stateValue.with { $0.amount }
        let input = parsed == number ? previous : String(number)
                
        let value = Updated_ChatTextInputState(inputText: .initialize(string: input))
        
        updateState { current in
            var current = current
            current.inputState = value
            current.amount = number
            return current
        }
        if value.string != previous {
            DispatchQueue.main.async {
                interactions?.update { _ in
                    return value
                }
            }
        }
        
    }, close: {
        close?()
    }, date: {
        
        let current = stateValue.with { $0.date }
        
        let mode: ChatDateSelectorMode
        if current != nil {
            mode = .dateAction(
                title: strings().editPostSuggestionDateTitle,
                done: { _ in strings().editPostSuggestionDateDone },
                action: .init(string: strings().editPostSuggestionDateReset, callback: {
                    updateState { current in
                        var current = current
                        current.date = nil
                        return current
                    }
                })
            )
        } else {
            mode = .date(
                title: strings().editPostSuggestionDateTitle,
                doneTitle: strings().editPostSuggestionDateDone
            )
        }
        
        showModal(with: chatDateSelector(context: context, mode: mode, selectedAt: { date, _ in
            updateState { current in
                var current = current
                current.date = Int32(date.timeIntervalSince1970)
                return current
            }
        }), for: context.window)
    })
    
    let signal = statePromise.get() |> deliverOnPrepareQueue |> map { state in
        return InputDataSignalValue(entries: entries(state, arguments: arguments))
    }
    

    let controller = InputDataController(dataSignal: signal, title: "")
    controller.analyticsScreen = .chatSuggestedPostEditor
    
    controller.validateData = { [weak chatInteraction] _ in
        
        let state = stateValue.with { $0 }
        
        guard let starsState = state.effectiveState else {
            return .fail(.none)
        }
        
        switch data.mode {
        case .new, .edit:
            if starsState.balance.value < state.starsAmount.value {
                showModal(with: Star_ListScreen(context: context, source: .buy(suffix: nil, amount: state.amount)), for: window)
                return .fail(.fields([_id_input : .shake]))
            }
        case .suggest:
            break
        }
       
    
        chatInteraction?.update {
            $0.updatedInterfaceState {
                $0.withUpdatedSuggestPost(stateValue.with { $0.result })
            }
        }
        close?()
        
        return .none
    }
    
    getController = { [weak controller] in
        return controller
    }
    
    controller.onDeinit = {
        actionsDisposable.dispose()
    }
    
    

    
    let modalInteractions = ModalInteractions(acceptTitle: stateValue.with { $0.ok }, accept: { [weak controller] in
        _ = controller?.returnKeyAction()
    }, singleButton: true)
    
    controller.afterTransaction = { [weak modalInteractions] _ in
        modalInteractions?.updateDone { value in
            value.set(text: stateValue.with { $0.ok }, for: .Normal)
        }
    }
    
    let modalController = InputDataModalController(controller, modalInteractions: modalInteractions)
    
    controller.leftModalHeader = ModalHeaderData(image: theme.icons.modalClose, handler: { [weak modalController] in
        modalController?.close()
    })
    
    close = { [weak modalController] in
        modalController?.modal?.close()
    }
    
    return modalController
    
}




