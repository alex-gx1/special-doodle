import UIKit

final class TabBarAssembler {
    private init() {}
    
    static func make() -> UITabBarController {
        let tabBarController = TabBarVC(viewModel: TabBarViewModel(router: TabBarRouter(root: UITabBarController())))
        
        let router = TabBarRouter(root: tabBarController)
        
        let viewModel = TabBarViewModel(router: router)
        let vc = TabBarVC(viewModel: viewModel)
        
        return vc
    }
}
