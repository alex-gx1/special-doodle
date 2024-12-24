import UIKit

final class RegisterAssembler {
    private init() {}
    
    static func make() -> UIViewController {
        let router = RegisterRouter()
        let authService = AuthService()
        let authServiceUseCase = RegisterAuthServiceUseCase(service: authService)
        let validationService = ValidationService() 
        
        let vm = RegisterViewModel(
            authService: authServiceUseCase,
            validationService: validationService,
            router: router
        )

        let vc = RegisterVC(viewModel: vm)
        
        router.root = vc
        
        return vc
    }
}
