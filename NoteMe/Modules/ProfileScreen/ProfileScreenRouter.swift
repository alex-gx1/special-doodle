import UIKit

final class ProfileScreenRouter: ProfileScreenRouterProtocol{
    
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
    func openStatsScreen() {
        let vc = StatsAssembler.make()
        root?.navigationController?.pushViewController(vc, animated: true)
    }

    func openLoginScreen() {
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.restartApp()
    }
}
