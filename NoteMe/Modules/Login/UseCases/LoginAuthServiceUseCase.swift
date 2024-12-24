import UIKit
import Firebase
import FirebaseAuth


struct LoginAuthServiceUseCase: LoginAuthServiceProtocol {
    
    private let service: AuthService
    
    init(service: AuthService) {
        self.service = service
    }
    
    func signIn(
        email: String?,
        password: String?,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        guard let email = email, !email.isEmpty else {
            completion(.failure(LoginError.invalidEmail))
            return
        }
        
        guard let password = password, !password.isEmpty else {
            completion(.failure(LoginError.invalidPassword))
            return
        }
        
        let user = UserData(email: email, password: password)
        
        service.signIn(user: user, completion: completion)
    }
}
