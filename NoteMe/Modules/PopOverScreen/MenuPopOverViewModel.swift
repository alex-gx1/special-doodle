import UIKit

protocol MenuPopOverRouterProtocol {
    func openTimerScreen()
    func openLocationScreen()
    func openCalenderScreen()
}

final class MenuPopOverViewModel: MenuPopOverViewModelProtocol {
    
    private let router: MenuPopOverRouterProtocol
    
    init(router: MenuPopOverRouterProtocol) {
        self.router = router
    }
    
    func openTimerScreen() {
        router.openTimerScreen()
    }
    
    func openLocationScreen() {
        router.openLocationScreen()
    }
    
    func openCalenderScreen() {
        router.openCalenderScreen()
    }
}
