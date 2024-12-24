import UIKit

final class RegisterRouter: RegisterRouterProtocol {
    
    weak var root: UIViewController?
    
    func back() {
        root?.navigationController?.popViewController(animated: true)
    }
}
