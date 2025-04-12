import UIKit

final class TimerPickerRouter: TimerPickerRouterProtocol {
    
    weak var root: UIViewController?
    
    func dismiss() {
        root?.dismiss(animated: true)
    }
    
}
