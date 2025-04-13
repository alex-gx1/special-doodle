import UIKit
import FirebaseAuth
import Firebase

protocol ProfileScreenServiceProtocol {
    func signOut()
    
}

protocol ProfileScreenRouterProtocol {
    func showAlert(
        title: String,
        message: String?,
        onConfirm: @escaping () -> Void
    )
    func openLoginScreen()
}

final class ProfileScreenViewModel: ProfileScreenViewModelProtocol{
    
    private let router: ProfileScreenRouterProtocol
    private let authService: ProfileScreenServiceProtocol
    private let parametersService: ParametersService

    
    init(router: ProfileScreenRouterProtocol, authService: ProfileScreenServiceProtocol, parametersService: ParametersService) {
        self.router = router
        self.authService = authService
        self.parametersService = parametersService
    }
    
    func showAlert(Title: String, Message: String?) {
        router.showAlert(
            title: Title,
            message: Message,
            onConfirm: { [weak self] in
                self?.authService.signOut()
                self?.parametersService.set(value: false, for: .isUserLogin)
                self?.router.openLoginScreen()
            }
        )
    }

}
