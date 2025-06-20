import Foundation
import CoreLocation
import UserNotifications

final class NotificationManager: NSObject {
    static let shared = NotificationManager()
    private let handler = NotificationHandler()
    private var observers = [Any]()
    private let locationManager = CLLocationManager()
    
    private override init() {
        super.init()
        setupObservers()
        setupLocationManager()
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("Все уведомления отменены")
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func requestLocationAuthorization() {
        let status: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            status = locationManager.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }
        
        switch status {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
        case .authorizedAlways:
            startMonitoringLocation()
        case .denied, .restricted:
            print("Доступ к геолокации ограничен или запрещен")
        @unknown default:
            print("Неизвестный статус авторизации")
        }
    }
    
    func startMonitoringLocation() {
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    private func setupObservers() {
        let center = NotificationCenter.default
        let observer = center.addObserver(
            forName: .taskDidChange,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self = self else { return }
            
            if let type = notification.userInfo?["type"] as? String {
                switch type {
                case "date":
                    self.handler.checkAndScheduleDateNotifications()
                case "timer":
                    self.handler.checkAndScheduleTimerNotifications()
                case "location":
                    self.handler.checkAndScheduleLocationNotifications()
                default:
                    break
                }
            } else {
                self.handler.checkAllNotifications()
            }
        }
        observers.append(observer)
    }
    
    func checkNotificationsImmediately() {
        handler.checkAllNotifications()
    }
    
    deinit {
        observers.forEach { observer in
            NotificationCenter.default.removeObserver(observer)
        }
    }
}

extension Notification.Name {
    static let taskDidChange = Notification.Name("TaskDidChangeNotification")
}

extension NotificationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            startMonitoringLocation()
            handler.checkAndScheduleLocationNotifications()
        case .authorizedWhenInUse:
            print("Для работы фоновых уведомлений требуется 'Always' доступ")
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else { return }
        print("Обновление локации: \(mostRecentLocation.coordinate)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Ошибка LocationManager: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Ошибка мониторинга региона: \(error.localizedDescription)")
    }
}
