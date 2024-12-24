import UIKit

final class LoginAssembler {
    
    private init() {}
    
    static func make() -> UIViewController {
        let router = LoginRouter()
        let authService = LoginAuthServiceUseCase(service: AuthService())
        let validationService = ValidationService()
        

        let vm = LoginViewModel(
            service: authService,
            validationService: validationService,
            router: router
        )
    
        let vc = LoginVC(viewModel: vm)
        
        router.root = vc
        
        return vc
    }
}
