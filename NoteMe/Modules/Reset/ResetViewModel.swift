import Foundation
import UIKit
import FirebaseAuth
import Firebase

protocol ResetAuthServiceProtocol {
    func resetPassword(
        email: String,
        completion: @escaping (Result<Bool, Error>) -> Void)
}

final class ResetViewModel: ResetViewModelProtocol {
    private let service: ResetAuthServiceProtocol
    private let validationService: ValidationService
    
    var shouldShowAlert: Closure<String>?
    
    init(service: ResetAuthServiceProtocol, validationService: ValidationService = ValidationService()) {
        self.service = service
        self.validationService = validationService
    }
    
    func resetPasswordForUser(email: String?, completion: @escaping (Result<String, Error>) -> Void) {
        
        service.resetPassword(email: email ?? "") { result in
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
