import UIKit

final class TimerPickerAssembler {
    private init() {}
    
    static func make(timerService: TimerServiceProtocol, onTimeUpdated: ((String) -> Void)? = nil) -> UIViewController {
        let router = TimerPickerRouter()
        let viewModel = TimerPickerViewModel(router: router, timerService: timerService, onTimeUpdated: onTimeUpdated)
        let vc = TimerPickerVC(viewModel: viewModel)
        router.root = vc
        return vc
    }
}
