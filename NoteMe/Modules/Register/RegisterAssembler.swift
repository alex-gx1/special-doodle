import UIKit

final class RegisterAssembler {
    private init() {}
    
    static func make() -> UIViewController {
        let authService = AuthService()
        let authServiceUseCase = RegisterAuthServiceUseCase(service: authService)
        let validationService = ValidationService() 
        
        let vm = RegisterViewModel(
            authService: authServiceUseCase,
            validationService: validationService
        )

        let vc = RegisterVC(viewModel: vm)
        return vc
    }
}
