import UIKit

protocol SmallPopOverRouterProtocol {
    func editAction()
    func doneAction()
    func deleteAction()
}

final class SmallPopOverRouter: SmallPopOverRouterProtocol {
    
    weak var root: UIViewController?
    var onActionSelected: ((EditMenuItem) -> Void)?

    func editAction() {
        dismissAndSend(.edit)
    }

    func doneAction() {
        dismissAndSend(.done)
    }

    func deleteAction() {
        dismissAndSend(.delete)
    }

    private func dismissAndSend(_ item: EditMenuItem) {
        root?.dismiss(animated: true) { [weak self] in
            self?.onActionSelected?(item)
        }
    }
}
