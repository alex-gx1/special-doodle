import UIKit

protocol OnboardingSecondRouterProtocol {
    func openMainScreenModule()
}

final class OnboardingSecondViewModel: OnboardingSecondViewModelProtocol {
    
    private let router: OnboardingSecondRouterProtocol
    
    init(router: OnboardingSecondRouterProtocol) {
        self.router = router
    }
    
    func openMainScreenModule() {
        router.openMainScreenModule()
    }
}

