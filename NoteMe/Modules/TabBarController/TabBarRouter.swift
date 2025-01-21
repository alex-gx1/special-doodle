import UIKit

final class TabBarRouter: TabBarRouterProtocol {
    
    weak var root: UIViewController?
    
    func removeOnboardingScreens() {
        root?.navigationController?.viewControllers.removeAll(where: { $0 is OnboardingScreens})
    }
}
