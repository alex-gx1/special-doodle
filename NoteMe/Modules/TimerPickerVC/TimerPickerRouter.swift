import UIKit

protocol TimerPickerDelegate: AnyObject {
    func timerPicked(hours: Int, minutes: Int, seconds: Int)
}

final class TimerPickerRouter: TimerPickerRouterProtocol {
    
    weak var root: UIViewController?
    
    weak var delegate: TimerPickerDelegate?
    
    func dismiss() {
        root?.dismiss(animated: true)
    }
    
    func dismissWithTime(hours: Int, minutes: Int, seconds: Int) {
        delegate?.timerPicked(hours: hours, minutes: minutes, seconds: seconds)
        root?.dismiss(animated: true)
    }
}
