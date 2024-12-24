import UIKit

final class ResetAssembler {
    private init() {}
    
    static func make() -> UIViewController {
        let authService = ResetAuthServiceUseCase(service: AuthService())
        let validationService = ValidationService()
        let vm = ResetViewModel(service: authService, validationService: validationService)
        let vc = ResetVC(viewModel: vm)
        return vc
    }
}
