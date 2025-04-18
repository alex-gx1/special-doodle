import  UIKit

final class TimerRouter: NSObject, TimerRouterProtocol {
    weak var root: UIViewController?
    
    func closeVC () {
        root?.navigationController?.popViewController(animated: true)
    }
    
}
