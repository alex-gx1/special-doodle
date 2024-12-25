import UIKit

final class AlertBuilder {
    private init() { }
        
        static func buildOkAlert(
            title: String?,
            message: String?
        ) -> UIViewController {
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            return alert
        }
        
}
