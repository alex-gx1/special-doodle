import UIKit


final class LoginRouter: LoginRouterProtocol {
    
    weak var root: UIViewController?
    
    func openRegisterModule() {
        let vc = RegisterAssembler.make()
        root?.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func openResetModule() {
        let vc = ResetAssembler.make()
        root?.navigationController?.pushViewController(vc, animated: true)
    }
}
