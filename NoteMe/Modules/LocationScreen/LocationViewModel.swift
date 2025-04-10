import UIKit

protocol LocationRouterProtocol {}

final class LocationViewModel: LocationViewModelProtocol {
    
    private let router: LocationRouterProtocol
    
    init(router: LocationRouterProtocol) {
        self.router = router
    }
    
}
