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

final class LoginViewModel: LoginViewModelProtocol {
    
    private let authService: LoginAuthServiceProtocol
    private let validationService: LoginValidateServiceProtocol
    
    var shouldShowAlert: Closure<String>?
    
    init(service: LoginAuthServiceProtocol, validationService: LoginValidateServiceProtocol) {
        self.authService = service
        self.validationService = validationService
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
}

enum LoginError: Error {
    case invalidEmail
    case invalidPassword
}
