import UIKit

protocol SmallPopOverViewModelProtocol {
    func editAction()
    func doneAction()
    func deleteAction()
}

final class SmallPopOverViewModel: SmallPopOverViewModelProtocol {
    
    private let router: SmallPopOverRouterProtocol

    init(router: SmallPopOverRouterProtocol) {
        self.router = router
    }

    func editAction() {
        router.editAction()
    }

    func doneAction() {
        router.doneAction()
    }

    func deleteAction() {
        router.deleteAction()
    }
}
