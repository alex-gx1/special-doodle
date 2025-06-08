import UIKit

final class DateScreenEditAssembler {
    private init() {}
    
    static func make(with model: DateTaskModel) -> UIViewController {
        let router = DateScreenEditRouter()
        let vm = DateScreenEditViewModel(
            router: router, model: model 
        )
        let vc = DateScreenEditVC(viewModel: vm)
        router.root = vc
        return vc
    }
}
