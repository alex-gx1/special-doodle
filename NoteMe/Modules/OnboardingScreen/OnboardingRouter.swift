import UIKit

final class OnboardingRouter: OnboardingRouterProtocol  {
    
    weak var root: UIViewController?
    
    func openOnboardingSecondModule() {
        let vc = OnboardingSecondAssembler.make()
        root?.navigationController?.pushViewController(vc, animated: true)
    }
}
