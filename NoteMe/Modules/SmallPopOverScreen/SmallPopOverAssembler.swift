import UIKit

final class SmallPopOverAssembler {
    private init() {}

    static func make(onActionSelected: @escaping (EditMenuItem) -> Void) -> UIViewController {
        let router = SmallPopOverRouter()
        router.onActionSelected = onActionSelected
        let viewModel = SmallPopOverViewModel(router: router)
        let vc = SmallPopOverVC(viewModel: viewModel)
        router.root = vc
        return vc
    }
}
