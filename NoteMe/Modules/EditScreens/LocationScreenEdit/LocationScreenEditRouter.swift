import UIKit

final class LocationScreenEditRouter: LocationScreenEditRouterProtocol {
    weak var root: UIViewController?
    
    func closeVC() {
        root?.navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: .taskCreatedNotification, object: nil)
    }
    
    func openFullMap(imageObservable: Observable<UIImage?>, x: Observable<Double>, y: Observable<Double>, radius: Observable<Double>) {
        let vc = FullMapAssembler.make(
            imageObservable: imageObservable,
            x: x,
            y: y,
            radius: radius)
        root?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showAlert(title: String, message: String?) {
        let alert = AlertBuilder.buildOkAlert(
            title: title,
            message: message
        )
        root?.present(alert, animated: true)
    }
}
