import UIKit

protocol CalendarRouterProtocol {
    func openCalendarKeyboard(dateService: DateServiceProtocol, onDateUpdated: ((String) -> Void)?)
    func closeVC ()
}

final class CalendarViewModel: CalendarViewModelProtocol {
    
    private let router: CalendarRouterProtocol
    private let dateService: DateServiceProtocol
    
    var dateString: Observable<String> = Observable("")
    
    init(router: CalendarRouterProtocol, dateService: DateServiceProtocol) {
        self.router = router
        self.dateService = dateService
    }
    
    func openCalendarKeyboard() {
        router.openCalendarKeyboard(dateService: dateService) { [weak self] date in
            self?.dateString.value = date
        }
    }
    
    func closeVC() {
        router.closeVC()
    }
    
}
