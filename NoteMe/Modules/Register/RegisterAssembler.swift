import UIKit

final class RegisterAssembler {
    private init() {}
    
    static func make(
        container: Container
    ) -> UIViewController {
        let router = RegisterRouter()
        let authServiceUseCase = RegisterAuthServiceUseCase(service: container.resolve())
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
