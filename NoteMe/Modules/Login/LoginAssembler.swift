import UIKit

final class LoginAssembler {
    
    private init() {}
    
    static func make() -> UIViewController {

        let authService = LoginAuthServiceUseCase(service: AuthService())
        let validationService = ValidationService()
        

        let vm = LoginViewModel(
            service: authService,
            validationService: validationService
        )
        
        let vc = LoginVC(viewModel: vm)
        return vc
    }
}
