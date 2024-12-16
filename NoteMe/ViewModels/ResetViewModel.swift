import Foundation
import UIKit
import FirebaseAuth
import Firebase

final class ResetViewModel {
    private let service: AuthService
    
    init(service: AuthService = AuthService()) {
        self.service = service
    }
    func validateEmail(_ email: String?) -> Bool {
        guard let email = email else { return false }
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")
        return emailPredicate.evaluate(with: email)
    }
    //дальше буду доделывать
}
