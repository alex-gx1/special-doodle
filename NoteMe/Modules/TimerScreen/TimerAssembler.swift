import UIKit

final class TimerAssembler {
    private init() {}
    
    static func make() -> UIViewController {
        let router = TimerRouter()
        let timerService = TimerService()
        
        let vm = TimerViewModel(
            router: router,
            timerService: timerService
        )
        
        let vc = TimerVC(viewModel: vm)
        router.root = vc
        return vc
    }
}
