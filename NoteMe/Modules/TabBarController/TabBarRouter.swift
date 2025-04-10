import UIKit

enum MenuItem {
    case timer
    case location
    case calendar
}

final class TabBarRouter: TabBarRouterProtocol {
    
    weak var root: UIViewController?
    
    func removeOnboardingScreens() {
        root?.navigationController?.viewControllers.removeAll(where: { $0 is OnboardingScreens})
    }
    
    func presentMenuPopover(from source: UIView, sourceRect: CGRect) {
        let menuVC = MenuPopOverAssembler.make { [weak self] (item: MenuItem) in
            switch item {
            case .timer:
                let vc = TimerAssembler.make()
                self?.root?.navigationController?.pushViewController(vc, animated: true)
            case .location:
                let vc = LocationAssembler.make()
                self?.root?.navigationController?.pushViewController(vc, animated: true)
                break
            case .calendar:
                let vc = CalendarAssembler.make()
                self?.root?.navigationController?.pushViewController(vc, animated: true)
                break
            }
        }
        
        menuVC.modalPresentationStyle = .popover
        menuVC.preferredContentSize = CGSize(width: 200, height: 150)
        
        if let popover = menuVC.popoverPresentationController {
            popover.sourceView = source
            popover.sourceRect = sourceRect
            popover.permittedArrowDirections = UIPopoverArrowDirection.any
            popover.delegate = root as? UIPopoverPresentationControllerDelegate
        }
        
        root?.present(menuVC, animated: true)
    }
    
}
