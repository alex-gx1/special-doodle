import UIKit

final class LoginAssembler {
    
    private init() {}
    
    static func make() -> UIViewController {
        let authServiceUseCase = LoginAuthServiceUseCase(service: AuthService())
        let vm = LoginViewModel(service: authServiceUseCase)
        let vc = LoginVC(viewModel: vm)
        return vc
    }
}
