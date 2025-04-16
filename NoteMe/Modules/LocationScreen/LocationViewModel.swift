import UIKit

protocol LocationRouterProtocol {
    func closeVC()
}

final class LocationViewModel: LocationViewModelProtocol {
    
    private let router: LocationRouterProtocol
    
    init(router: LocationRouterProtocol) {
        self.router = router
    }
    
    func closeVC() {
        router.closeVC()
    }
}
