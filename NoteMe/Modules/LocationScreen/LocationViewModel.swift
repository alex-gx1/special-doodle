import UIKit
import MapKit

protocol LocationRouterProtocol {
    func closeVC()
    func openFullMap()
}

final class LocationViewModel: LocationViewModelProtocol {
    
    private let router: LocationRouterProtocol
    
    private lazy var locationManager: CLLocationManager = .init( )
    
    init(router: LocationRouterProtocol) {
        self.router = router
    }
    
    func closeVC() {
        router.closeVC()
    }
    
    func askPermission() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func openFullMap() {
        router.openFullMap()
    }
}
