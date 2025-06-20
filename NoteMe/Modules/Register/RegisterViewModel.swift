import Foundation
import UIKit
import FirebaseAuth
import Firebase

protocol RegisterAuthServiceProtocol {
    func createNewUser(
        email: String?,
        password: String?,
        completion: @escaping (Result<Bool, Error>) -> Void)
}

protocol RegisterValidationServiceProtocol {
    func validateEmail(_ email: String?) -> Bool
    func validatePasswordStrength(_ password: String?) -> Bool
}

protocol RegisterRouterProtocol {
    func back()
    
    func showAlert(title: String, message: String?)
}

final class RegisterViewModel: RegisterViewModelProtocol {
    
    private let authService: RegisterAuthServiceProtocol
    
    private let validationService: RegisterValidationServiceProtocol
    
    private let router: RegisterRouterProtocol
    
    var shouldShowAlert: Closure<String>?
    
    init(authService: RegisterAuthServiceProtocol, validationService: RegisterValidationServiceProtocol, router: RegisterRouterProtocol) {
        self.validationService = validationService
        self.authService = authService
        self.router = router
    }
    
    func registerUser(email: String?, password: String?, completion: @escaping (Result<String, Error>) -> Void) {
        authService.createNewUser(email: email, password: password) { result in
            switch result {
            case .success:
                completion(.success("User registered successfully"))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func validatePasswords(password: String?, repeatPassword: String?) -> Bool {
        guard
            let password = password,
            let repeatPassword = repeatPassword
        else { return false }
        
        return password == repeatPassword
    }
    
    func register(email: String, password: String) {
        guard validationService.validateEmail(email) else {
            router.showAlert(title: "Ошибка", message: "Неправильный email формат!")
            
            return
        }
        
        guard validationService.validatePasswordStrength(password) else {
            router.showAlert(title: "Ошибка", message: "Пароль должен быть в длину не менее 8 симвволов, соержать маленькие и заглавные буквы, а также спецсимволы.")
            return
        }
        
        registerUser(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self?.router.showAlert(title: "Успешно", message: "Вы зарегестрировались!")
                case .failure(let error):
                    self?.router.showAlert(title: "Ошибка", message: error.localizedDescription)
                }
            }
        }
    }
    
    func back() {
        router.back()
    }
}

enum ValidationError: Error {
    case emptyFields
    var localizedDescription: String {
        switch self {
        case .emptyFields:
            return "Email и пароль не должны быть пустыми."
        }
    }
}
