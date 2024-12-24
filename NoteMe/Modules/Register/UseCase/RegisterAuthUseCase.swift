import UIKit
import Firebase
import FirebaseAuth

struct RegisterAuthServiceUseCase: RegisterAuthServiceProtocol {
    
    private let service: AuthService
    
    init(service: AuthService){
        self.service = service
    }
    
    func createNewUser(
        email: String?,
        password: String?,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        guard let email = email, !email.isEmpty,
              let password = password, !password.isEmpty else {
            completion(.failure(ValidationError.emptyFields))
            return
        }
        
        let user = UserData(email: email, password: password)
        
        service.createNewUser(user: user, completion: completion)
    }
    
}
