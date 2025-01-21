import UIKit

final class LoginAssembler {
    
    private init() {}
    
    static func make(
        container: Container
    ) -> UIViewController {
        let router = LoginRouter(container: container)
        let authService = LoginAuthServiceUseCase(service: container.resolve())
        let validationService: ValidationService = container.resolve()
        let parametersService = ParametersService()
        
        let vm = LoginViewModel(
            service: authService,
            validationService: validationService,
            router: router,
            parametersService: parametersService 
        )
    
        let vc = LoginVC(viewModel: vm)
        
        router.root = vc
        
        return vc
    }
}
