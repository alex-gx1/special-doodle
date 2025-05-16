import UIKit
import Storage

protocol CalendarRouterProtocol {
    func closeVC ()
    func showAlert(title: String, message: String?)
}

final class CalendarViewModel: CalendarViewModelProtocol {
    
    private let router: CalendarRouterProtocol
    
    private let storage = DateNotificationStorage()
    
    init(router: CalendarRouterProtocol) {
        self.router = router
    }
    
    func closeVC() {
        router.closeVC()
    }
    
    func showAlert(title: String, message: String?) {
        router.showAlert(title: title, message: message)
    }
    
    func saveNotification(title: String, targetDate: Date, subtitle: String) {
        let currentDate = Date()
        
        let dto = DateNotificationDTO(
            id: UUID().uuidString,
            title: title,
            subtitle: subtitle,
            date: currentDate,
            targetDate: targetDate
        )
        
        storage.create(dto: dto) { success in
            print(success ? "Успешно сохранено" : "Ошибка при сохранении")
        }
        if let storeURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            print("Путь к базе данных:", storeURL.path)
        }
    }
}
