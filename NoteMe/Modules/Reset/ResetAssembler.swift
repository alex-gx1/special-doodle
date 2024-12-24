import UIKit

final class ResetAssembler {
    private init() {}
    
    static func make() -> UIViewController {
        let authServiceUseCase = ResetAuthServiceUseCase(service: AuthService())
        let vm = ResetViewModel(service: authServiceUseCase)
        let vc = ResetVC(viewModel: vm)
        return vc
    }
}
