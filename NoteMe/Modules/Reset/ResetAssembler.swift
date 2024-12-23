import UIKit

final class ResetAssembler {
    private init() {}
    
    static func make() -> UIViewController {
        let authService = AuthService()
        let vm = ResetViewModel(service: authService)
        let vc = ResetVC(viewModel: vm)
        return vc
    }
}
