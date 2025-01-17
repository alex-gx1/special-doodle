import UIKit


final class LoginRouter: LoginRouterProtocol {
    
    private let container: Container
    
    weak var root: UIViewController?
    
    init(container: Container) {
        self.container = container
    }
    
    func openRegisterModule() {
        let vc = RegisterAssembler.make(container: container)
        root?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openResetModule() {
        let vc = ResetAssembler.make()
        root?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openOnboardingModule() {
        let vc = OnboardingAssembler.make()
        root?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showAlert(
        title: String,
        message: String?
    ) {
        let alert = AlertBuilder.buildOkAlert(title: title, message: message)
        root?.present(alert, animated: true)
    }
    
}
