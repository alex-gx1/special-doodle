import UIKit

class ValidationService {
    
    func validateEmail(_ email: String?) -> Bool {
        guard let email = email else { return false }
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")
        return emailPredicate.evaluate(with: email)
    }
    
    func validatePasswordStrength(_ password: String?) -> Bool {
        guard let password = password else { return false }
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$")
        return passwordPredicate.evaluate(with: password)
    }
}
