import UIKit


protocol OnboardingRouterProtocol {
    
   func openOnboardingSecondModule()
    
    func removeAuthScreens()
}

final class OnboardingViewModel: OnboardingViewModelProtocol {
    
    private let router: OnboardingRouterProtocol
    
    init(router: OnboardingRouterProtocol) {
        self.router = router
    }
    
    func openOnboardingSecondModule() {
        router.openOnboardingSecondModule()
    }
    
    func viewDidAppear() {
        router.removeAuthScreens()
    }
}
