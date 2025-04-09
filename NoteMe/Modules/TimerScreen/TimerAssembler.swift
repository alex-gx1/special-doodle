import UIKit

final class TimerAssembler {
    private init() {}
    
    static func make() -> UIViewController {
        let router = TimerRouter()
        
        let vm = TimerViewModel(
            router: router
        )
        
        let vc = TimerVC(viewModel: vm)
        router.root = vc
        return vc
    }
    
}
