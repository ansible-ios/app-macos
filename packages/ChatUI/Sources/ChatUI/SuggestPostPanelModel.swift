import Cocoa
import AnsibleUIKit
import SwiftSignalKit
import Postbox
import TelegramCore
import Localization
import AnsibleTheme
import AnsibleContext
import AnsibleUtils
import LocalAnimations
import ChatHistoryModel
import InlineStickerLayer

public class SuggestPostPanelModel: ChatAccessoryModel {
    
    
    let data: ChatInterfaceState.ChannelSuggestPost
    
    public init(data: ChatInterfaceState.ChannelSuggestPost, editing: Bool = false, context: any AccountContextProtocol) {
        self.data = data
        super.init(context: context)
        self.make()
    }
    deinit {
    }
    
    public override var modelType: ChatAccessoryModel.ModelType {
        return .classic
    }
    
    func make() -> Void {
        
        let title: String
        switch data.mode {
        case .edit:
            title = strings().suggestPostPanelTitleEdit
        case .new:
            title = strings().suggestPostPanelTitleNew
        case .suggest:
            title = strings().suggestPostPanelTitleSuggest
        }

        
        self.header = .init(.initialize(string: title, color: theme.colors.accent, font: .medium(.text)), maximumNumberOfLines: 1)
        
        
        let text: NSMutableAttributedString = NSMutableAttributedString()

        if data.amount?.currency == .ton {
            text.append(string: strings().chatUnsupportedMessageTitle, color: theme.colors.text, font: .normal(.text))
        } else if let amount = data.amount, amount.amount.value > 0 {
            let dateString = data.date.flatMap({ stringForDate(timestamp: $0) }) ?? strings().suggestPostPanelTextAnytime
            let formatted = strings().suggestPostPanelTextPriceAndDate(amount.suggestedPostAmountText, dateString)
            text.append(string: "\(clown_space)\(formatted)", color: theme.colors.text, font: .normal(.text))

            text.insertEmbedded(.embeddedAnimated(LocalAnimatedSticker.star_currency_new.file), for: clown)

        } else if let time = data.date {
            let dateString = stringForDate(timestamp: time)
            let formatted = strings().suggestPostPanelTextFreeAndDate(dateString)
            text.append(string: formatted, color: theme.colors.text, font: .normal(.text))
        } else {
            text.append(string: strings().suggestPostPanelTextOfferPrice, color: theme.colors.text, font: .normal(.text))
        }

        
        self.message = .init(text, maximumNumberOfLines: 1)

        
        nodeReady.set(.single(true))
        self.setNeedDisplay()
    }
    

}
