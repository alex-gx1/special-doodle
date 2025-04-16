import UIKit

final class LocationRouter: LocationRouterProtocol {
    weak var root: UIViewController?
    
    func closeVC() {
        root?.navigationController?.popViewController(animated: true)
    }
}
