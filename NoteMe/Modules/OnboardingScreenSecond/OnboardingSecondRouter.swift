import UIKit

final class OnboardingSecondRouter: OnboardingSecondRouterProtocol {
    
    weak var root: UIViewController?
    
    func openMainScreenModule() {
        let vc = MainScreenAssembler.make()
        root?.navigationController?.pushViewController(vc, animated: true)
    }
}
