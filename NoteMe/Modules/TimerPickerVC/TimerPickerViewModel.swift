import UIKit

protocol TimerPickerRouterProtocol: AnyObject {
    func dismiss()
    func dismissWithTime(hours: Int, minutes: Int, seconds: Int)
}

final class TimerPickerViewModel: TimerPickerViewModelProtocol {
    
    private weak var router: TimerPickerRouterProtocol?
    
    var hours = 0
    var minutes = 0
    var seconds = 0
    
    init(router: TimerPickerRouterProtocol) {
        self.router = router
    }
    
    func didTapCancel() {
        router?.dismiss()
    }
    
    func didTapDone() {
        router?.dismissWithTime(hours: hours, minutes: minutes, seconds: seconds)
    }
}

