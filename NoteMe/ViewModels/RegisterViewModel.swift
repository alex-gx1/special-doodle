import Foundation
import UIKit
import FirebaseAuth
import Firebase

final class RegisterViewModel {
    private let service: AuthService
    
    init(service: AuthService = AuthService()) {
        self.service = service
    }
    
    func registerUser(email: String?, password: String?, completion: @escaping (Result<String, Error>) -> Void) {
        guard let email = email, !email.isEmpty,
              let password = password, !password.isEmpty else {
            completion(.failure(ValidationError.emptyFields))
            return
        }
        
        let user = UserData(email: email, password: password)
        service.createNewUser(user: user) { result in
            switch result {
            case .success:
                completion(.success("User registered successfully"))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func validateEmail(_ email: String?) -> Bool {
        guard let email = email else { return false }
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")
        return emailPredicate.evaluate(with: email)
    }
    
    func validatePasswords(password: String?, repeatPassword: String?) -> Bool {
        guard let password = password, let repeatPassword = repeatPassword else { return false }
        return password == repeatPassword
    }
    
    func validatePasswordStrength(_ password: String?) -> Bool {
        guard let password = password else { return false }
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$")
        return passwordPredicate.evaluate(with: password)
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
