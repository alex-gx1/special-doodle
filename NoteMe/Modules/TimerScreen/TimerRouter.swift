import  UIKit

final class TimerRouter: NSObject, TimerRouterProtocol {
    weak var root: UIViewController?
    
    func openTimerKeyboard(timerService: TimerServiceProtocol, onTimeUpdated: ((String) -> Void)? = nil) {
        let vc = TimerPickerAssembler.make(timerService: timerService, onTimeUpdated: onTimeUpdated)
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        root?.present(vc, animated: true)
    }
    
}

extension TimerRouter: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}
