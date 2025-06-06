import UIKit

protocol StatsRouterProtocol {
    
}

final class StatsViewModel: StatsViewModelProtocol{
    private let router: StatsRouterProtocol
    
    init(router: StatsRouterProtocol) {
        self.router = router
    }
}
