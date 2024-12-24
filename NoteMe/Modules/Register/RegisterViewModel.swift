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

final class RegisterViewModel: RegisterViewModelProtocol {
    
    private let authService: RegisterAuthServiceProtocol
    private let validationService: ValidationService
    
    var shouldShowAlert: Closure<String>?
    
    init(authService: RegisterAuthServiceProtocol, validationService: ValidationService = ValidationService()) {
        self.validationService = validationService
        self.authService = authService
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
        guard let password = password, let repeatPassword = repeatPassword else { return false }
        return password == repeatPassword
    }
    
    func register(email: String, password: String) {
        guard validationService.validateEmail(email) else {
            shouldShowAlert?("Invalid email format.")
            return
        }
        
        guard validationService.validatePasswordStrength(password) else {
            shouldShowAlert?("Password must be at least 8 characters long and include uppercase, lowercase, a number, and a special character.")
            return
        }
        
        registerUser(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self?.shouldShowAlert?("Success")
                case .failure(let error):
                    self?.shouldShowAlert?(error.localizedDescription)
                }
            }
        }
    }
}

enum ValidationError: Error {
    case emptyFields
    var localizedDescription: String {
        switch self {
        case .emptyFields:
            return "Email and Password must not be empty."
        }
    }
}
