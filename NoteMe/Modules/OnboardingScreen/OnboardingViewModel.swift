import UIKit


protocol OnboardingRouterProtocol {
   func openOnboardingSecondModule()
}

final class OnboardingViewModel: OnboardingViewModelProtocol {
    
    private let router: OnboardingRouterProtocol
    
    init(router: OnboardingRouterProtocol) {
        self.router = router
    }
    
    func openOnboardingSecondModule() {
        router.openOnboardingSecondModule()
    }
}
