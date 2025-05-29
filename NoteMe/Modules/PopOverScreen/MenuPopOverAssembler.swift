import UIKit

final class MenuPopOverAssembler {
    private init() {}
    
    static func make(onItemSelected: @escaping (MenuItem) -> Void) -> UIViewController {
        let router = MenuPopOverRouter()
        router.onScreenSelected = onItemSelected
        let viewModel = MenuPopOverViewModel(router: router)
        let vc = MenuPopoverVC(viewModel: viewModel)
        router.root = vc
        return vc
    }

}
