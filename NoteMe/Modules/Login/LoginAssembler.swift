import UIKit

final class LoginAssembler {
    
    private init() {}
    
    static func make() -> UIViewController {
        let authService = AuthService()
        let vm = LoginViewModel(service: authService)
        let vc = LoginVC(viewModel: vm)
        return vc
    }
}
