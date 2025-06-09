import UIKit

final class ProfileScreenRouter: ProfileScreenRouterProtocol {
    private var currentAlert: UIAlertController?
    weak var root: UIViewController?
    
    func showAlert(title: String, message: String?, onConfirm: @escaping () -> Void) {
        let alert = AlertBuilder.buildOkCancelAlert(
            title: title,
            message: message,
            onOk: {
                onConfirm()
            }
        )
        root?.present(alert, animated: true)
    }
    
    func showErrorAlert(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        root?.present(alert, animated: true)
    }
    
    func showProgressAlert(title: String, message: String?, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        currentAlert = alert
        root?.present(alert, animated: true) {
            completion()
        }
    }
    
    func dismissAlert(completion: @escaping () -> Void) {
        currentAlert?.dismiss(animated: true) {
            self.currentAlert = nil
            completion()
        }
    }
    
    func showShareSheet(with url: URL) {
        guard FileManager.default.fileExists(atPath: url.path) else {
            showErrorAlert(title: "Ошибка", message: "Файл не найден")
            return
        }
        
        let fileURL = url as NSURL
        _ = fileURL.startAccessingSecurityScopedResource()
        
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        activityVC.completionWithItemsHandler = { _, _, _, _ in
            fileURL.stopAccessingSecurityScopedResource()
        }
        
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = root?.view
            popover.sourceRect = CGRect(x: root?.view.bounds.midX ?? 0,
                                      y: root?.view.bounds.midY ?? 0,
                                      width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        
        root?.present(activityVC, animated: true)
    }
    
    func openStatsScreen() {
        let vc = StatsAssembler.make()
        root?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openLoginScreen() {
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.restartApp()
    }
}
