import Foundation

protocol TabBarViewModelProtocol: AnyObject {
    func switchToTab(index: Int)
    func openModuleAtTab(index: Int)
}

final class TabBarViewModel: TabBarViewModelProtocol {
    
    private let router: TabBarRouterProtocol
    
    init(router: TabBarRouterProtocol) {
        self.router = router
    }
    
    func switchToTab(index: Int) {
        router.switchToTab(index: index)
    }
    
    func openModuleAtTab(index: Int) {
        router.openModule(at: index)
    }
}
