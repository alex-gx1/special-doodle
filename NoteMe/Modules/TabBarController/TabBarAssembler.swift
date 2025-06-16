import UIKit

final class TabBarAssembler {
    private init() {}
    
    static func make() -> UITabBarController {
        
        let router = TabBarRouter()
        let viewModel = TabBarViewModel(router: router)
        let tabBar = TabBarVC(viewModel: viewModel)
        
        router.root = tabBar
        
        let mainScreen = MainScreenAssembler.make()
        
        let profileScreen = ProfileScreenAssembler.make()
        
        mainScreen.tabBarItem = UITabBarItem(title: "Главная", image: Images.homeTabBar, tag: 0)
        
        profileScreen.tabBarItem = UITabBarItem(title: "Профиль", image: Images.profileTabBar, tag: 2)
        
        tabBar.viewControllers = [mainScreen, profileScreen]
        
        return tabBar
    }
}
