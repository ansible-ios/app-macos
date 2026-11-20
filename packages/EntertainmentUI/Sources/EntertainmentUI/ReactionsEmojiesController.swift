import Cocoa
import AnsibleUIKit
import ChatModeTypes

public protocol ReactionsEmojiesController: ViewController {
    var closeCurrent: (() -> Void)? { get set }
    var animateAppearance: (([TableRowItem]) -> Void)? { get set }
    func update(with interactions: EntertainmentInteractions?, chatInteraction: any ChatInteractionProtocol)
}

extension EmojiesController: ReactionsEmojiesController {

}
