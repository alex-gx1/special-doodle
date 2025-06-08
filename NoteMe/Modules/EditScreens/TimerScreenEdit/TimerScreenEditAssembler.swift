import UIKit

final class TimerScreenEditAssembler {
    private init() {}
    
    static func make(with model: TimerTaskModel) -> UIViewController {
        let router = TimerScreenEditRouter()
        
        let vm = TimerScreenEditViewModel(
            router: router, model: model
        )
        
        let vc = TimerScreenEditVC(viewModel: vm)
        router.root = vc
        return vc
    }
}
