import UIKit

final class ResetRouter: ResetRouterProtocol {
    
    weak var root: UIViewController?
    
    func back(){
        root?.navigationController?.popViewController(animated: true)
    }
}
