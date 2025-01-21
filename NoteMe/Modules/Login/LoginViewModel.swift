import Foundation
import FirebaseAuth

protocol LoginAuthServiceProtocol {
    func signIn(
        email: String?,
        password: String?,
        completion: @escaping (Result<Bool, Error>) -> Void)
}

//сохранять после успешного логина в parametrsService что юзер залогинился

protocol LoginValidateServiceProtocol {
    func validateEmail(_ email: String?) -> Bool
}

protocol LoginRouterProtocol {
    //navigation
    func openRegisterModule()
    func openResetModule()
    func openOnboardingModule()
    //alert
    func showAlert(title: String, message: String?)
}

final class LoginViewModel: LoginViewModelProtocol {
    
    private let authService: LoginAuthServiceProtocol
    
    private let validationService: LoginValidateServiceProtocol
    
    private let router: LoginRouterProtocol
    
    private let parametersService: ParametersService
    
    var shouldShowAlert: Closure<String>?
    
    init(service: LoginAuthServiceProtocol, validationService: LoginValidateServiceProtocol, router: LoginRouterProtocol, parametersService: ParametersService) {
        self.authService = service
        self.validationService = validationService
        self.router = router
        self.parametersService = parametersService
    }
    
    func loginUser(email: String?, password: String?, completion: @escaping (Result<String, Error>) -> Void) {
        
        authService.signIn(email: email, password: password) { result in
            switch result {
            case .success:
                self.parametersService.set(value: true, for: .isUserLogin)
                completion(.success("Successfully logged in!"))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    func login(email: String, password: String) {
        guard validationService.validateEmail(email) else {
            router.showAlert(title: "Error", message: "Invalid email  format.")
            return
        }
        
        loginUser(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(_):
                    self?.openOnboardingModule()
                case .failure(let error):
                    self?.router.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    func openOnboardingModule() {
        router.openOnboardingModule()
    }
    
    func openResetModule() {
        router.openResetModule()
    }
    
    func openRegisterModule() {
        router.openRegisterModule()
    }
}

enum LoginError: Error {
    case invalidEmail
    case invalidPassword
}
