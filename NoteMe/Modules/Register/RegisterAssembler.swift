import UIKit

final class RegisterAssembler {
    private init() {}
    
    static func make() -> UIViewController {
        let authServiceUseCase = RegisterAuthServiceUseCase(service: AuthService())
        let vm = RegisterViewModel(authService: authServiceUseCase)
        let vc = RegisterVC(viewModel: vm)
        return vc
    }
}
