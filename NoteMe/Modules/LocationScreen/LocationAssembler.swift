import UIKit

final class LocationAssembler {
    private init() {}
    
    static func make() -> UIViewController {
        let router = LocationRouter()
        let vm = LocationViewModel(
            router: router
        )
        let vc = LocationVC(viewModel: vm)
        router.root = vc
        return vc
    }
}
