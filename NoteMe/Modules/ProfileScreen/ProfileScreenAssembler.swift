import UIKit

final class ProfileScreenAssembler {
    private init() {}
    
    static func make() -> UIViewController {
        
        let vm = ProfileScreenViewModel()
        
        let vc = ProfileScreenVC(viewModel: vm)
                
        return vc
    }
}
