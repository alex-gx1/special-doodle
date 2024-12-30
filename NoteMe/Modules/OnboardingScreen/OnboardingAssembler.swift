import UIKit

final class OnboardingAssembler  {
    private init() {}
    
    static func make() -> UIViewController {
        let router = OnboardingRouter()
        
        let vm = OnboardingViewModel(router: router)
        
        let vc = OnboardingVC(viewModel: vm)
        
        router.root = vc
        
        return vc
    }
}
