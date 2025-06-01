import UIKit
import Storage

enum EditMenuItem {
    case edit
    case done
    case delete
}

protocol MainScreenRouterProtocol {
    func presentMenuPopover(from source: UIView, sourceRect: CGRect, forItemId id: String, deleteHandler: @escaping () -> Void, completeHandler: @escaping () -> Void)
}

final class MainScreenRouter: MainScreenRouterProtocol {
    weak var root: UIViewController?
    
    func presentMenuPopover
    (
        from source: UIView,
        sourceRect: CGRect,
        forItemId id: String,
        deleteHandler: @escaping () -> Void,
        completeHandler: @escaping () -> Void
    ) {
        let menuVC = SmallPopOverAssembler.make { (item: EditMenuItem) in
            switch item {
            case .edit:
                print("edit tapped")
            case .done:
                completeHandler()
                print("done tapped")
            case .delete:
                deleteHandler()
                print("delete tapped")
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
