import UIKit

final class CalendarRouter: NSObject, CalendarRouterProtocol {
    weak var root: UIViewController?
    
    func openCalendarKeyboard(dateService: DateServiceProtocol, onDateUpdated: ((String) -> Void)? = nil) {
        let vc = CalendarPickerAssembler.make(dateService: dateService, onDateUpdated: onDateUpdated)
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        root?.present(vc, animated: true)
    }
}

extension CalendarRouter: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func closeVC () {
        root?.navigationController?.popViewController(animated: true)
    }
}
