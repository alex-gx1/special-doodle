import UIKit

final class OnboardingRouter: OnboardingRouterProtocol  {
    
    weak var root: UIViewController?
    
    func openOnboardingSecondModule() {
        let vc = OnboardingSecondAssembler.make()
        root?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func removeAuthScreens() {
        root?.navigationController?.viewControllers.removeAll(where: { $0 is AuthScreen })
    }
}
