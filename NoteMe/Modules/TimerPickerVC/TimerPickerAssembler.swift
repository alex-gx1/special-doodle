import UIKit

final class TimerPickerAssembler {
    static func make(delegate: TimerPickerDelegate?) -> UIViewController {
        let router = TimerPickerRouter()
        router.delegate = delegate
        let vm = TimerPickerViewModel(router: router)
        let vc = TimerPickerVC(viewModel: vm)
        router.root = vc
        return vc
    }
}
