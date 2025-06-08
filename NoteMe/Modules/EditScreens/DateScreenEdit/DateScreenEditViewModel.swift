import UIKit
import Storage

protocol DateScreenEditRouterProtocol {
    func closeVC ()
    func showAlert(title: String, message: String?)
}

final class DateScreenEditViewModel: DateScreenEditViewModelProtocol {
    func saveNotification(title: String, targetDate: Date, subtitle: String, category: String, priority: String) {
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
        
        let dto = DateNotificationDTO(
            id: UUID().uuidString,
            title: title,
            subtitle: subtitle,
            date: currentDate,
            targetDate: targetDate,
            work: work,
            other: other,
            critical: critical,
            highPriority: highPriority,
            mediumPriority: mediumPriority,
            lowPriority: lowPriority
        )
        
        storage.create(dto: dto) { success in
            print(success ? (NotificationCenter.default.post(
                name: .taskDidChange,
                object: nil,
                userInfo: ["type": "date"]
            )) : "Ошибка при сохранении")
        }
        if let storeURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            print("Путь к базе данных:", storeURL.path)
        }
    }
    
    private let router: DateScreenEditRouterProtocol
    
    private let storage = DateNotificationStorage()
    
    init(router: DateScreenEditRouterProtocol) {
        self.router = router
    }
    
    func closeVC() {
        router.closeVC()
    }
    
    func showAlert(title: String, message: String?) {
        router.showAlert(title: title, message: message)
    }
}
