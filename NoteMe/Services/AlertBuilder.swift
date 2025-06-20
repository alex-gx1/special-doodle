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
    
    static func buildOkCancelAlert(
        title: String?,
        message: String?,
        onOk: @escaping () -> Void,
        onCancel: (() -> Void)? = nil
    ) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            onOk()
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { _ in
            onCancel?()
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        return alert
    }

    
}
