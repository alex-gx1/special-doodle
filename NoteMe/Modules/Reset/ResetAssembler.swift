import UIKit

final class ResetAssembler {
    private init() {}
    
    static func make() -> UIViewController {
        let router = ResetRouter()
        let authService = ResetAuthServiceUseCase(service: AuthService())
        let validationService = ValidationService()
        let vm = ResetViewModel(
            service: authService,
            validationService: validationService,
            router: router
            
        )
        let vc = ResetVC(viewModel: vm)
        
        router.root = vc
        
        return vc
    }
}
