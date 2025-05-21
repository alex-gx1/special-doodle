import UIKit

final class MainScreenAssembler {
    private init() {}
    
    static func make() -> UIViewController {
        
        let vm = MainScreenViewModel()
        
        let vc = MainScreenVC(viewModel: vm)
        
        return vc
    }
}
