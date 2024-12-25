import Foundation
import UIKit
import FirebaseAuth
import Firebase

protocol ResetAuthServiceProtocol {
    func resetPassword(
        email: String,
        completion: @escaping (Result<Bool, Error>) -> Void)
}

protocol ResetValidateServiceProtocol {
    func validateEmail(_ email: String?) -> Bool
}

protocol ResetRouterProtocol  {
    //navigation
    func back()
    //alert
    func showAlert(title: String, message: String?)
}

final class ResetViewModel: ResetViewModelProtocol {
    
    private let service: ResetAuthServiceProtocol
    
    private let validationService: ResetValidateServiceProtocol
    
    private let router: ResetRouterProtocol
    
    var shouldShowAlert: Closure<String>?
    
    init(service: ResetAuthServiceProtocol, validationService: ResetValidateServiceProtocol, router: ResetRouterProtocol) {
        self.service = service
        self.validationService = validationService
        self.router = router
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
            router.showAlert(title: "Error", message: "Invalid email format.")
            return
        }
        
        resetPasswordForUser(email: email) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.router.showAlert(title: "Succes", message: "Password reset email sent successfully!")
                case .failure(let error):
                    self?.router.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    func back() {
        router.back()
    }
}
