import UIKit

protocol SearchRouterProtocol {
    
}

final class SearchViewModel: SearchViewModelProtocol {
    
    private let router: SearchRouterProtocol
    
    init(router: SearchRouterProtocol) {
        self.router = router
    }
}
