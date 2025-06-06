import UIKit

final class StatsAssembler {
    private init() {}
    
    static func make() -> UIViewController {
        let router = StatsRouter()
        let vm = StatsViewModel(router: router)
        let vc = StatsVC(viewModel: vm)
        router.root = vc 
        return vc
    }
}
