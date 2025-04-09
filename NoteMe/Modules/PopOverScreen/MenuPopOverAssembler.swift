import UIKit

final class MenuPopOverAssembler {
    private init() {}
    
    static func make() -> UIViewController {
        let router = MenuPopOverRouter()
        
        let vm = MenuPopOverViewModel(
            router: router
        )
        let vc = MenuPopoverVC(viewModel: vm)
        router.root = vc
        
        return vc
    }
}
