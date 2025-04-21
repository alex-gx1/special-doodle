import UIKit

final class LocationRouter: LocationRouterProtocol {
    weak var root: UIViewController?
    
    func closeVC() {
        root?.navigationController?.popViewController(animated: true)
    }
    
    func openFullMap(imageObservable: Observable<UIImage?>) {
        let vc = FullMapAssembler.make(imageObservable: imageObservable)
        root?.navigationController?.pushViewController(vc, animated: true)
    }
}
