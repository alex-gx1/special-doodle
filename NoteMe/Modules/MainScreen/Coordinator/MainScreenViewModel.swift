import UIKit
import Storage


final class MainScreenViewModel: MainScreenViewModelProtocol {
    
    var tasksDidUpdate: (([NotificationModel]) -> Void)?
    
    var resetData: (() -> Void)?
        
    private func formatSeconds(_ seconds: Double) -> String {
        let totalSeconds = Int(seconds)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let secs = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, secs)
    }
    
    private static let fullFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    private static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter
    }()
    
    private static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter
    }()
    
    private func formatDateComponents(from date: Date) -> (day: String, month: String, full: String) {
        return (
            day: Self.dayFormatter.string(from: date),
            month: Self.monthFormatter.string(from: date),
            full: Self.fullFormatter.string(from: date)
        )
    }

    func loadTimerTasks() {
        let storage = TimerNotificationStorage()
        let dtos = storage.fetch()
        
        let tasks: [NotificationModel] = dtos.map {
            .timer(
                TimerTaskModel(
                    title: $0.title,
                    subtitle: $0.subtitle ?? "",
                    seconds: $0.seconds,
                    createdAt: $0.date
                )
            )
        }
        tasksDidUpdate?(tasks)
    }
    
    func loadDateTasks() {
        let storage = DateNotificationStorage()
        let dtos = storage.fetch()
        
        let tasks: [NotificationModel] = dtos.map {
            let components = formatDateComponents(from: $0.targetDate)
            return .date(DateTaskModel(
                title: $0.title,
                subtitle: $0.subtitle ?? "",
                dateString: components.full,
                day: components.day,
                month: components.month
            ))
        }
        
        tasksDidUpdate?(tasks)
    }
    
    func loadAllTasks() {
        let storage = AllNotficationStorage()
        let dtos = storage.fetch(sortDescriptors: [.Notification.byDate])
        
        let models: [NotificationModel] = dtos.compactMap { dto in
            switch dto {
            case let timerDTO as TimerNotificationDTO:
                return .timer(
                    TimerTaskModel(
                        title: timerDTO.title,
                        subtitle: timerDTO.subtitle ?? "",
                        seconds: timerDTO.seconds,
                        createdAt: timerDTO.date
                    )
                )
            case let dateDTO as DateNotificationDTO:
                let components = formatDateComponents(from: dateDTO.targetDate)
                return .date(
                    DateTaskModel(
                        title: dateDTO.title,
                        subtitle: dateDTO.subtitle ?? "",
                        dateString: components.full,
                        day: components.day,
                        month: components.month
                    )
                )
            default:
                return nil
            }
        }
        
        tasksDidUpdate?(models)
    }
    
    func didSelectFilter(_ filter: FilterItem) {
        resetData?()
        
        switch filter {
        case .timer:
            loadTimerTasks()
        case .date:
            loadDateTasks()
        case .all:
            loadAllTasks()
            
        default:
            break
        }
    }
    
}
