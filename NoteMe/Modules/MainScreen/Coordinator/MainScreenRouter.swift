import UIKit
import Storage

enum EditMenuItem {
    case edit
    case done
    case delete
}

protocol MainScreenRouterProtocol {
    func presentMenuPopover(
        from source: UIView,
        sourceRect: CGRect,
        forItemId id: String,
        deleteHandler: @escaping () -> Void,
        completeHandler: @escaping () -> Void,
        editHandler: @escaping () -> Void
    )
    
    func navigateToEditTimer(with model: TimerTaskModel)
    func navigateToEditDate(with model: DateTaskModel)
}

final class MainScreenRouter: MainScreenRouterProtocol {
    weak var root: UIViewController?
    
    func presentMenuPopover(
        from source: UIView,
        sourceRect: CGRect,
        forItemId id: String,
        deleteHandler: @escaping () -> Void,
        completeHandler: @escaping () -> Void,
        editHandler: @escaping () -> Void
    ) {
        let menuVC = SmallPopOverAssembler.make { (item: EditMenuItem) in
            switch item {
            case .edit:
                editHandler()
            case .done:
                completeHandler()
            case .delete:
                deleteHandler()
            }
        }
        
        menuVC.modalPresentationStyle = .popover
        menuVC.preferredContentSize = CGSize(width: 100, height: 200)
        
        if let popover = menuVC.popoverPresentationController {
            popover.sourceView = source
            popover.sourceRect = sourceRect
            popover.permittedArrowDirections = .right
            popover.delegate = root as? UIPopoverPresentationControllerDelegate
        }
        
        root?.present(menuVC, animated: true)
    }
    
    func navigateToEditTimer(with model: TimerTaskModel) {
        let editVC = TimerScreenEditAssembler.make(with: model)
        root?.navigationController?.pushViewController(editVC, animated: true)
    }
    
    func navigateToEditDate(with model: DateTaskModel) {
        let editVC = DateScreenEditAssembler.make(with: model)
        root?.navigationController?.pushViewController(editVC, animated: true)
    }
}
