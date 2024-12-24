import Foundation
import FirebaseAuth

protocol LoginAuthServiceProtocol {
    func signIn(
        email: String?,
        password: String?,
        completion: @escaping (Result<Bool, Error>) -> Void)
}

protocol LoginValidateServiceProtocol {
    func validateEmail(_ email: String?) -> Bool
}

protocol LoginRouterProtocol {
    func openRegisterModule()
    func openResetModule()
}

final class LoginViewModel: LoginViewModelProtocol {
    
    private let authService: LoginAuthServiceProtocol
    
    private let validationService: LoginValidateServiceProtocol
    
    private let router: LoginRouterProtocol
    
    var shouldShowAlert: Closure<String>?
    
    init(service: LoginAuthServiceProtocol, validationService: LoginValidateServiceProtocol, router: LoginRouterProtocol) {
        self.authService = service
        self.validationService = validationService
        self.router = router
    }
    
    func loginUser(email: String?, password: String?, completion: @escaping (Result<String, Error>) -> Void) {
        
        authService.signIn(email: email, password: password) { result in
            switch result {
            case .success:
                completion(.success("Successfully logged in!"))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    func login(email: String, password: String) {
        guard validationService.validateEmail(email) else {
            shouldShowAlert?("Invalid email  format.")
            return
        }
        
        loginUser(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    print("Succes go to next screen")
                case .failure(let error):
                    self?.shouldShowAlert?(error.localizedDescription)
                }
            }
        }
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
