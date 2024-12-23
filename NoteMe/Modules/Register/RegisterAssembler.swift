import Foundation
import UIKit

final class RegisterAssembler {
    private init() {}
    
    static func make() -> UIViewController {
        let authService = AuthService()
        let vm = RegisterViewModel(service: authService)
        let vc = RegisterVC(viewModel: vm)
        return vc
    }
}
