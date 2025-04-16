import UIKit

final class CalendarPickerRouter: CalendarPickerRouterProtocol {
    weak var root: UIViewController?
    
    func dismiss() {
        root?.dismiss(animated: true)
    }
}
