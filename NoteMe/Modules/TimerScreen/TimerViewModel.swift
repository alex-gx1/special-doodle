import UIKit

protocol TimerRouterProtocol {
    func openTimerKeyboard(timerService: TimerServiceProtocol, onTimeUpdated: ((String) -> Void)?)
}


final class TimerViewModel: TimerViewModelProtocol {
    
    private let router: TimerRouterProtocol
    private let timerService: TimerServiceProtocol
    
    var timerString: Observable<String> = Observable("")
    
    init(router: TimerRouterProtocol, timerService: TimerServiceProtocol) {
        self.router = router
        self.timerService = timerService
    }
    
    func openTimerKeyboard() {
        router.openTimerKeyboard(timerService: timerService) { [weak self] time in
            self?.timerString.value = time
        }
    }
}

