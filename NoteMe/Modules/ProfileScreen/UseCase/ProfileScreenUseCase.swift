import UIKit
import Firebase
import FirebaseAuth

struct ProfileScreenServiceUseCase: ProfileScreenServiceProtocol {
    
    private let service: AuthService
    
    init(service: AuthService) {
        self.service = service
    }
    
    func signOut() {
        service.signOut()
    }
    
    func getUserMail() -> String {
        return service.getUserMail() ?? "Error"
    }
}
