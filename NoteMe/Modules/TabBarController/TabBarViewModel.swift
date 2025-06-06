import UIKit

protocol TabBarRouterProtocol {
    func removeOnboardingScreens()
    func presentMenuPopover(from source: UIView, sourceRect: CGRect)
}

final class TabBarViewModel: TabBarViewModelProtocol {
    
    private let router: TabBarRouterProtocol
    
    init(router: TabBarRouterProtocol) {
        self.router = router
    }
    
    func viewDidAppear() {
        router.removeOnboardingScreens()
        print("экран удаленннн")
    }
    
    func plusButtonTapped(from source: UIView, sourceRect: CGRect) {
        router.presentMenuPopover(from: source, sourceRect: sourceRect)
    }
}
