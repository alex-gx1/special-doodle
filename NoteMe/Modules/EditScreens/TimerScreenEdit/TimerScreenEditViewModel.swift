import UIKit
import Storage

protocol TimerScreenEditRouterProtocol {
    func closeVC ()
    func showAlert(title: String, message: String?)
}

final class TimerScreenEditViewModel: TimerScreenEditViewModelProtocol {
    
    func saveNotification(title: String, seconds: Double, subtitle: String, category: String, priority: String) {
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
        
        let dto = TimerNotificationDTO(
            id: model.identifier,
            title: title,
            subtitle: subtitle,
            date: currentDate,
            completedDate: nil,
            seconds: seconds,
            work: work,
            other: other,
            critical: critical,
            highPriority: highPriority,
            mediumPriority: mediumPriority,
            lowPriority: lowPriority
        )
        
        storage.update(dto: dto) { success in
            if success {
                NotificationCenter.default.post(name: .taskDidChange, object: nil, userInfo: ["type": "timer"])
            } else {
                self.showAlert(title: "Ошибка", message: "Не удалось обновить данные")
            }
        }
        
        if let storeURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            print("Путь к базе данных:", storeURL.path)
        }
    }
    
    private let router: TimerScreenEditRouterProtocol
    let model: TimerTaskModel
    private let storage = TimerNotificationStorage()
    
    init(router: TimerScreenEditRouterProtocol, model: TimerTaskModel) {
        self.router = router
        self.model = model
    }
    
    func closeVC() {
        router.closeVC()
    }
    
    func showAlert(title: String, message: String?) {
        router.showAlert(title: title, message: message)
    }
}
