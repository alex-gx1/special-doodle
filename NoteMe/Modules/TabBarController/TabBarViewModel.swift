import UIKit

protocol TabBarRouterProtocol {
    func removeOnboardingScreens()
    func presentMenuPopover(from source: UIView, sourceRect: CGRect)
}

final class TabBarViewModel {
    
    private let router: TabBarRouterProtocol
    
    init(router: TabBarRouterProtocol) {
        self.router = router
    }
    
    func viewDidAppear() {
        router.removeOnboardingScreens()
    }
    
    func plusButtonTapped(from source: UIView, sourceRect: CGRect) {
        router.presentMenuPopover(from: source, sourceRect: sourceRect)
    }
}
