import UIKit

protocol CalendarRouterProtocol {
    func closeVC ()
}

final class CalendarViewModel: CalendarViewModelProtocol {
    
    private let router: CalendarRouterProtocol
    
    init(router: CalendarRouterProtocol) {
        self.router = router
    }
    
    func closeVC() {
        router.closeVC()
    }
}
