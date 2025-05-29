import UIKit

enum EditMenuItem {
    case edit
    case done
    case delete
}

final class MainScreenRouter: MainScreenRouterProtocol {
    weak var root: UIViewController?
    
    func presentMenuPopover(from source: UIView, sourceRect: CGRect) {
        let menuVC = SmallPopOverAssembler.make { [weak self] (item: EditMenuItem) in
            switch item {
            case .edit:
                //                let vc = TimerAssembler.make()
                //                self?.root?.navigationController?.pushViewController(vc, animated: true)
                print("edit tapped")
            case .done:
                print("done tapped")
                break
            case .delete:
                print("delete tapped")
                break
            }
        }
        
        menuVC.modalPresentationStyle = .popover
        menuVC.preferredContentSize = CGSize(width: 100, height: 200)
        
        if let popover = menuVC.popoverPresentationController {
            popover.sourceView = source
            popover.sourceRect = sourceRect
            popover.permittedArrowDirections = UIPopoverArrowDirection.right
            popover.delegate = root as? UIPopoverPresentationControllerDelegate
        }
        
        root?.present(menuVC, animated: true)
    }
}
