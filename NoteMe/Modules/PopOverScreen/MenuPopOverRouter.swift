import UIKit

final class MenuPopOverRouter: MenuPopOverRouterProtocol {
    weak var root: UIViewController?
    var onScreenSelected: ((MenuItem) -> Void)?
    
    func openTimerScreen() {
        dismissAndSend(.timer)
    }
    
    func openLocationScreen() {
        dismissAndSend(.location)
    }
    
    func openCalenderScreen() {
        dismissAndSend(.calendar)
    }
    
    private func dismissAndSend(_ item: MenuItem) {
        root?.dismiss(animated: true) { [weak self] in
            self?.onScreenSelected?(item)
        }
    }
}
