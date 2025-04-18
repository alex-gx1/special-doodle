import UIKit

final class FullMapAssembler {
    private init() {}
    
    static func make() -> UIViewController {
        let router = FullMapRouter()
        
        let vm = FullMapViewModel(
            router: router
        )
        let vc = FullMapVC(viewModel: vm)
        router.root = vc
        return vc
    }
}
