import UIKit
import MapKit
import Storage

protocol LocationRouterProtocol {
    func closeVC()
    func openFullMap(imageObservable: Observable<UIImage?>, x: Observable<Double>, y: Observable<Double>, radius: Observable<Double>)
    func showAlert(title: String, message: String?)
}

final class LocationViewModel: LocationViewModelProtocol {
    
    private let router: LocationRouterProtocol
    
    private let storage = LocationNotificationStorage()
    
    let locationImage = Observable<UIImage?>(nil)
    let x = Observable<Double>(0)
    let y = Observable<Double>(0)
    let radius = Observable<Double>(0)
    
    private lazy var locationManager: CLLocationManager = .init( )
    
    init(router: LocationRouterProtocol) {
        self.router = router
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
    
//    func saveImageToDocuments(_ image: UIImage, fileName: String) -> String? {
//        guard let data = image.pngData() else { return nil }
//        
//        let fileManager = FileManager.default
//        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let fileURL = documentsURL.appendingPathComponent(fileName)
//
//        do {
//            try data.write(to: fileURL)
//            return fileURL.path
//        } catch {
//            print("Error saving image: \(error.localizedDescription)")
//            return nil
//        }
//    }
    func saveImageToDocuments(_ image: UIImage, fileName: String) -> String? {
        guard let data = image.pngData() else { return nil }
        
        let fileManager = FileManager.default
        let directory = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        
        // Создаем подпапку для изображений
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

    func saveNotification(title: String, x: Double, y: Double, radius: Double , url: String, subtitle: String) {
        let currentDate = Date()
        
        let dto = LocationNotificationDTO(
            id: UUID().uuidString,
            title: title,
            subtitle: subtitle,
            date: currentDate,
            x: x,
            y: y,
            radius: radius,
            url: url
        )
        
        storage.create(dto: dto) { success in
            print(success ? "Успешно сохранено" : "Ошибка при сохранении")
        }
        if let storeURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            print("Путь к базе данных:", storeURL.path)
        }
    }
}
