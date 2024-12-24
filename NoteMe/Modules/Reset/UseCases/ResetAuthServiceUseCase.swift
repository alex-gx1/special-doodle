import UIKit
import FirebaseAuth
import Firebase

struct ResetAuthServiceUseCase: ResetAuthServiceProtocol {
    
    private let service: AuthService
    
    init(service: AuthService)  {
        self.service = service
    }
    
    func resetPassword(
        email: String,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        guard !email.isEmpty else {
            completion(.failure(SignError.invalidUser))
            return
        }
        service.resetPassword(email: email, completion: completion)
    }
}
