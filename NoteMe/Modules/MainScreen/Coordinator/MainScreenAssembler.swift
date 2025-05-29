import UIKit

final class MainScreenAssembler {
    private init() {}
    
    static func make() -> UIViewController {
        let router = MainScreenRouter()
        
        let vm = MainScreenViewModel(router: router)
        
        let vc = MainScreenVC(viewModel: vm)
        
        router.root = vc
        
        return vc
    }
}
