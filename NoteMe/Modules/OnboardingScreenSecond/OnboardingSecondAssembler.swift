import UIKit

final class OnboardingSecondAssembler {
    private init() {}
    
    static func make() -> UIViewController {
        let router = OnboardingSecondRouter()
        let vm = OnboardingSecondViewModel(router: router)
        let vc = OnboardingSecondVC(viewModel: vm)
        router.root = vc
        return vc
    }
}
