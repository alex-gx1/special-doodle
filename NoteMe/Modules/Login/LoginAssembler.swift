import UIKit

final class LoginAssembler {
    
    private init() {}
    
    static func make(
        container: Container
    ) -> UIViewController {
        let router = LoginRouter(container: container)
        let authService = LoginAuthServiceUseCase(service: container.resolve())
        let validationService: ValidationService = container.resolve()
        
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
