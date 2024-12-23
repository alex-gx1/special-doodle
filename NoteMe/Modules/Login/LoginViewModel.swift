import Foundation
import FirebaseAuth
final class LoginViewModel: LoginViewModelProtocol {
    private let service: AuthService
    private let validationService: ValidationService
    var shouldShowAlert: Closure<String>?
    
    init(service: AuthService = AuthService(), validationService: ValidationService = ValidationService()) {
        self.service = service
        self.validationService = validationService
    }
    
    func loginUser(email: String?, password: String?, completion: @escaping (Result<String, Error>) -> Void) {
        guard let email = email, !email.isEmpty else {
            completion(.failure(LoginError.invalidEmail))
            return
        }
        
        guard let password = password, !password.isEmpty else {
            completion(.failure(LoginError.invalidPassword))
            return
        }
        
        let user = UserData(email: email, password: password)
        
        service.signIn(user: user) { result in
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
