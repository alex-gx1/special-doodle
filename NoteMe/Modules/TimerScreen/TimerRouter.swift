import  UIKit

final class TimerRouter: NSObject, TimerRouterProtocol {
    weak var root: UIViewController?
    
    func showAlert(title: String, message: String?) {
        let alert = AlertBuilder.buildOkAlert(
            title: title,
            message: message
        )
        root?.present(alert, animated: true)
    }
    
    func closeVC () {
        root?.navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: .taskCreatedNotification, object: nil)
    }
}
