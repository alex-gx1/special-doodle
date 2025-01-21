import UIKit

protocol TabBarRouterProtocol {
    func removeOnboardingScreens()
}

final class TabBarViewModel {
    
    private let router: TabBarRouterProtocol
    
    init(router: TabBarRouterProtocol) {
        self.router = router
    }
    
    func viewDidAppear() {
        router.removeOnboardingScreens()
    }
}
