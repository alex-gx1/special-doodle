import UIKit

protocol TimerRouterProtocol {
    func closeVC ()
}


final class TimerViewModel: TimerViewModelProtocol {
    
    private let router: TimerRouterProtocol
    
    init(router: TimerRouterProtocol) {
        self.router = router
    }
    
    func closeVC() {
        router.closeVC()
    }
}

