import Foundation

protocol FullMapRouterProtocol {
    
}

final class FullMapViewModel: FullMapViewModelProtocol {
    
    private let router: FullMapRouterProtocol
    
    init(router: FullMapRouterProtocol) {
        self.router = router
    }
}
