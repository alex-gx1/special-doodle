import UIKit

final class ResetRouter: ResetRouterProtocol {
    
    weak var root: UIViewController?
    
    func back(){
        root?.navigationController?.popViewController(animated: true)
    }
    
    func showAlert(
        title: String,
        message: String?
    ){
        let alert = AlertBuilder.buildOkAlert(title: title, message: message)
        root?.present(alert, animated: true)
    }
}
