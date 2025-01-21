import UIKit

final class OnboardingSecondAssembler {
    private init() {}
    
    static func make() -> UIViewController {
        let router = OnboardingSecondRouter()
        let parametersService =  ParametersService()
        
        let vm = OnboardingSecondViewModel(
            router: router,
            parametersService: parametersService
        )
        let vc = OnboardingSecondVC(viewModel: vm)
        router.root = vc
        return vc
    }
}
