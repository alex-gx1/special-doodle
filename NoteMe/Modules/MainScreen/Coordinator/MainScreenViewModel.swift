import UIKit
import Storage


final class MainScreenViewModel: MainScreenViewModelProtocol {
    
    var tasksDidUpdate: (([NotificationModel]) -> Void)?
    
    var resetData: (() -> Void)?
    
    private var timer: Timer?
    private var timerTasksDTO: [TimerNotificationDTO] = []
    private var timerStartDate: Date?
    
    private func formatSeconds(_ seconds: Double) -> String {
        let totalSeconds = Int(seconds)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let secs = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, secs)
    }
    
    private func startTimer() {
        timerStartDate = Date()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateTimerTasks()
        }
    }
    
    private func updateTimerTasks() {
        guard let startDate = timerStartDate else { return }
        let elapsed = Date().timeIntervalSince(startDate)
        
        let tasks: [NotificationModel] = timerTasksDTO.map { dto in
            let remaining = max(0, dto.seconds - elapsed)
            return .timer(
                TimerTaskModel(
                    title: dto.title,
                    subtitle: dto.subtitle ?? "",
                    timeString: formatSeconds(remaining)
                )
            )
        }
        tasksDidUpdate?(tasks)
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = nil
        timerStartDate = nil
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
        timerTasksDTO = storage.fetch()
        startTimer()
        updateTimerTasks()
    }
    
    func loadDateTasks() {
        resetTimer()
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
        resetTimer()
        let storage = AllNotficationStorage()
        let dtos = storage.fetch(sortDescriptors: [.Notification.byDate])
        
        let models: [NotificationModel] = dtos.compactMap { dto in
            switch dto {
            case let timerDTO as TimerNotificationDTO:
                return .timer(
                    TimerTaskModel(
                        title: timerDTO.title,
                        subtitle: timerDTO.subtitle ?? "",
                        timeString: formatSeconds(timerDTO.seconds)
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
