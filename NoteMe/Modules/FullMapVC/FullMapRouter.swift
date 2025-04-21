import UIKit

final class FullMapRouter: FullMapRouterProtocol {
    weak var root: UIViewController?
    
    func openSearchScreen() {
        let vc = SearchAssembler.make()
        
        guard let rootVC = root else { return }
        rootVC.addChild(vc)
        rootVC.view.addSubview(vc.view)
        
        vc.view.frame = CGRect(x: 0, y: rootVC.view.frame.height / 2, width: rootVC.view.frame.width, height: rootVC.view.frame.height / 2)
        vc.didMove(toParent: rootVC)
    }
    
    func closeVC() {
        root?.navigationController?.popViewController(animated: true)
    }
    
    func createAndCloseVC() {
        root?.navigationController?.popViewController(animated: true)
    }
    
}
