import Foundation

protocol FullMapRouterProtocol {
    func openSearchScreen()
}

final class FullMapViewModel: FullMapViewModelProtocol {
    
    private let router: FullMapRouterProtocol
    
    init(router: FullMapRouterProtocol) {
        self.router = router
    }
    func openSearchScreen() {
        router.openSearchScreen()
    }
}
