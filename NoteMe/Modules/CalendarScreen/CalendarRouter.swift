import UIKit

final class CalendarRouter: NSObject, CalendarRouterProtocol {
    weak var root: UIViewController?
    
    func closeVC () {
        root?.navigationController?.popViewController(animated: true)
    }
}
