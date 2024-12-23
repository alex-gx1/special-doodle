import Foundation
import UIKit
import FirebaseAuth
import Firebase

final class ResetViewModel: ResetViewModelProtocol {
    private let service: AuthService
    private let validationService: ValidationService
    
    var shouldShowAlert: Closure<String>?
    
    init(service: AuthService = AuthService(), validationService: ValidationService = ValidationService()) {
        self.service = service
        self.validationService = validationService
    }
    
    func resetPasswordForUser(email: String?, completion: @escaping (Result<String, Error>) -> Void) {
        guard let email = email, !email.isEmpty else {
            completion(.failure(SignError.invalidUser))
            return
        }
        
        service.resetPassword(email: email) { result in
            switch result {
            case .success:
                completion(.success("Password reset email sent successfully."))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func reset(email: String)  {
        guard validationService.validateEmail(email) else {
            shouldShowAlert?("Invalid email format.")
            return
        }
        
        resetPasswordForUser(email: email) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.shouldShowAlert?("Password reset email sent successfully!")
                case .failure(let error):
                    self?.shouldShowAlert?(error.localizedDescription)
                }
            }
        }
    }
}
