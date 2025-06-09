import UIKit
import MapKit
import Storage

protocol LocationScreenEditRouterProtocol {
    func closeVC()
    func openFullMap(imageObservable: Observable<UIImage?>, x: Observable<Double>, y: Observable<Double>, radius: Observable<Double>)
    func showAlert(title: String, message: String?)
}

final class LocationScreenEditViewModel: LocationScreenEditViewModelProtocol {
    
    func saveNotification(title: String, x: Double, y: Double, radius: Double, url: String, subtitle: String, category: String, priority: String) {
        let currentDate = Date()
        
        var work: String? = nil
        var other: String? = nil
        var critical: String? = nil
        var highPriority: String? = nil
        var mediumPriority: String? = nil
        var lowPriority: String? = nil
        
        switch category {
        case "Work":
            work = "Work"
        case "Other":
            other = "Other"
        default:
            break
        }
        
        switch priority {
        case "Critical":
            critical = "Critical"
        case "High":
            highPriority = "High"
        case "Medium":
            mediumPriority = "Medium"
        case "Low":
            lowPriority = "Low"
        default:
            break
        }
        
        let dto = LocationNotificationDTO(
            id: model.identifier,
            title: title,
            subtitle: subtitle,
            date: currentDate,
            completedDate: nil,
            x: x,
            y: y,
            radius: radius,
            url: url,
            work: work,
            other: other,
            critical: critical,
            highPriority: highPriority,
            mediumPriority: mediumPriority,
            lowPriority: lowPriority
        )
        
        storage.update(dto: dto) { success in
            print(success ? (NotificationCenter.default.post(
                name: .taskDidChange,
                object: nil,
                userInfo: ["type": "location"]
            )) : "Ошибка при сохранении")
        }
        if let storeURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            print("Путь к базе данных:", storeURL.path)
        }
    }
    
    private let router: LocationScreenEditRouterProtocol
    let model: LocationTaskModel
    private let storage = LocationNotificationStorage()
    
    let locationImage = Observable<UIImage?>(nil)
    let x = Observable<Double>(0)
    let y = Observable<Double>(0)
    let radius = Observable<Double>(0)
    
    private lazy var locationManager: CLLocationManager = .init( )
    
    init(router: LocationScreenEditRouterProtocol, model: LocationTaskModel) {
        self.router = router
        self.model = model
    }
    
    func showAlert(title: String, message: String?) {
        router.showAlert(title: title, message: message)
    }
    
    func closeVC() {
        router.closeVC()
    }
    
    func askPermission() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func openFullMap() {
        router.openFullMap(imageObservable: locationImage, x: x, y: y, radius: radius)
    }
    
    func saveImageToDocuments(_ image: UIImage, fileName: String) -> String? {
        guard let data = image.pngData() else { return nil }
        
        let fileManager = FileManager.default
        let directory = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        
        let imagesDirectory = directory.appendingPathComponent("LocationImages")
        try? fileManager.createDirectory(at: imagesDirectory, withIntermediateDirectories: true)
        
        let fileURL = imagesDirectory.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            return fileURL.path
        } catch {
            print("Error saving image: \(error.localizedDescription)")
            return nil
        }
    }
}
