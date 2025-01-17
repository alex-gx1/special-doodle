import UIKit

protocol TabBarRouterProtocol: AnyObject {
    func switchToTab(index: Int)
    func openModule(at index: Int)
}

final class TabBarRouter: TabBarRouterProtocol {
    
    weak var root: UITabBarController?
    
    init(root: UITabBarController) {
        self.root = root
    }
    
    func switchToTab(index: Int) {
        root?.selectedIndex = index
    }
    
    func openModule(at index: Int) {
        if let navigationController = root?.viewControllers?[index] as? UINavigationController,
           let topViewController = navigationController.topViewController {
            root?.selectedIndex = index
            navigationController.popToRootViewController(animated: false)
            topViewController.present(MainScreenAssembler.make(), animated: true)
        }
    }
}
