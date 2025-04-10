import UIKit

protocol CalendarRouterProtocol {}

final class CalendarViewModel: CalendarViewModelProtocol {
    
    private let router: CalendarRouterProtocol
    
    init(router: CalendarRouterProtocol) {
        self.router = router
    }
    
}
