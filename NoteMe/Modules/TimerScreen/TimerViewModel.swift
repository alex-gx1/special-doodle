import UIKit
import Storage

protocol TimerRouterProtocol {
    func closeVC ()
    func showAlert(title: String, message: String?)
}

final class TimerViewModel: TimerViewModelProtocol {
    
    private let router: TimerRouterProtocol
    
    private let storage = TimerNotificationStorage()
    
    init(router: TimerRouterProtocol) {
        self.router = router
    }
    
    func closeVC() {
        router.closeVC()
    }
    
    func saveNotification(title: String, seconds: Double, subtitle: String) {
        let currentDate = Date()
        
        let dto = TimerNotificationDTO(
            id: UUID().uuidString,
            title: title,
            subtitle: subtitle,
            date: currentDate,
            seconds: seconds
        )
        
        storage.create(dto: dto) { success in
            print(success ? (NotificationCenter.default.post(name: .taskDidChange, object: nil, userInfo: ["type": "timer"])) : "Ошибка при сохранении")
        }
        if let storeURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            print("Путь к базе данных:", storeURL.path)
        }
    }
    
    func showAlert(title: String, message: String?) {
        router.showAlert(title: title, message: message)
    }
    
}
