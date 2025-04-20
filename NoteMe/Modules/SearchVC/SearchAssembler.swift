import UIKit

final class SearchAssembler {
    private init() {}
    
    static func make() -> UIViewController {
        let router = SearchRouter()
        
        let vm = SearchViewModel(
            router: router
        )
        let vc = SearchVC(viewModel: vm)
        router.root = vc
        return vc
    }
}
