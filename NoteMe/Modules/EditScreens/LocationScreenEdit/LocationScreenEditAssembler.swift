import UIKit

final class LocationScreenEditAssembler {
    private init() {}
    
    static func make(with model: LocationTaskModel) -> UIViewController {
        let router = LocationScreenEditRouter()
        
        let vm = LocationScreenEditViewModel(
            router: router, model: model
        )
        let vc = LocationScreenEditVC(viewModel: vm)
        router.root = vc
        return vc
    }
}
