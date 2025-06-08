import UIKit

final class DateScreenEditAssembler {
    private init() {}
    
    static func make() -> UIViewController {
        let router = DateScreenEditRouter()
        let vm = DateScreenEditViewModel(
            router: router
        )
        let vc = DateScreenEditVC(viewModel: vm)
        router.root = vc
        return vc
    }
}
