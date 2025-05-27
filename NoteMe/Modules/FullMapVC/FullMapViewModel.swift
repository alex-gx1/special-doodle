import Foundation
import MapKit
import UIKit
import SnapKit

protocol FullMapRouterProtocol {
    func openSearchScreen()
    func closeVC()
    func createAndCloseVC()
}

final class FullMapViewModel: FullMapViewModelProtocol {
    
    private let router: FullMapRouterProtocol
    
    let screenshotImage: Observable<UIImage?>
    let x: Observable<Double>
    let y: Observable<Double>
    let radius: Observable<Double>
    
    init(router: FullMapRouterProtocol, screenshotImage: Observable<UIImage?>, x: Observable<Double>, y: Observable<Double>, radius: Observable<Double>) {
        self.router = router
        self.screenshotImage = screenshotImage
        self.x = x
        self.y = y
        self.radius = radius
    }
    func openSearchScreen() {
        router.openSearchScreen()
    }
    
    func closeVC() {
        router.closeVC()
    }
    
    func createAndCloseVC() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.router.createAndCloseVC()
        }
    }
    
    func captureScreenshot(from mapView: MKMapView, image: UIImageView, in view: UIView) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let screenshotSize = CGSize(
                width: mapView.frame.width,
                height: image.frame.height * 2
            )
            
            let offsetY: CGFloat = -50
            
            let contentRect = CGRect(
                origin: CGPoint(
                    x: 0,
                    y: -(view.bounds.height / 2 - screenshotSize.height / 2) + offsetY
                ),
                size: view.bounds.size
            )
            
            UIGraphicsBeginImageContextWithOptions(screenshotSize, false, UIScreen.main.scale)
            view.drawHierarchy(in: contentRect, afterScreenUpdates: true)
            let screenshot = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            self.screenshotImage.value = screenshot
        }
    }
    
}
