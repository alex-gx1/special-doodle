import UIKit

protocol TimerRouterProtocol {

}

final class TimerViewModel: TimerViewModelProtocol {
    
    private let router: TimerRouterProtocol
    
    init(router: TimerRouterProtocol) {
        self.router = router
    }
    
}
