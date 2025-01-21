import UIKit

protocol OnboardingSecondRouterProtocol {
    func openMainScreenModule()
}

final class OnboardingSecondViewModel: OnboardingSecondViewModelProtocol {
    
    private let router: OnboardingSecondRouterProtocol
    
    private let parametersService: ParametersService
    
    init(router: OnboardingSecondRouterProtocol, parametersService: ParametersService) {
        self.router = router
        self.parametersService = parametersService
    }
    
    func openMainScreenModule() {
        //сохранять в pS что юхер прошел onboarding
        router.openMainScreenModule()
        self.parametersService.set(value: true, for: .isFinishedOnBoarding)
    }
}

