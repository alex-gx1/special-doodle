import Foundation
import FirebaseAuth
final class LoginViewModel {
    private let service: AuthService
    
    init(service: AuthService = AuthService()) {
        self.service = service
    }
    
    func validateEmail(_ email: String?) -> Bool {
        guard let email = email else { return false }
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")
        return emailPredicate.evaluate(with: email)
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
}

enum LoginError: Error {
    case invalidEmail
    case invalidPassword
}
