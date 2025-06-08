import UIKit

final class TimerScreenEditAssembler {
    private init() {}
    
    static func make() -> UIViewController {
        let router = TimerScreenEditRouter()
        
        let vm = TimerScreenEditViewModel(
            router: router
        )
        
        let vc = TimerScreenEditVC(viewModel: vm)
        router.root = vc
        return vc
    }
}
