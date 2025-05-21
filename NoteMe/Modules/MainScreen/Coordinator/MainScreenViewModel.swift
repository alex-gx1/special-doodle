import UIKit
import Storage


final class MainScreenViewModel: MainScreenViewModelProtocol {
    
    var tasksDidUpdate: ((MainScreenInput) -> Void)?
    var resetData: (() -> Void)?
    
    private func formatSeconds(_ seconds: Double) -> String {
        let totalSeconds = Int(seconds)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let secs = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, secs)
    }
    
    func loadTimerTasks() {
        let storage = TimerNotificationStorage()
        let dtos = storage.fetch()
        let tasks = dtos.map {
            TimerTaskModel(
                title: $0.title,
                subtitle: $0.subtitle ?? "",
                timeString: formatSeconds($0.seconds)
            )
        }
        tasksDidUpdate?(.timer(tasks))
    }
    
    func loadDateTasks() {
        let storage = DateNotificationStorage()
        let dtos = storage.fetch()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        let tasks = dtos.map {
            DateTaskModel(
                title: $0.title,
                subtitle: $0.subtitle ?? "",
                dateString: formatter.string(from: $0.targetDate)
            )
        }
        tasksDidUpdate?(.date(tasks))
    }
    
    func didSelectFilter(_ filter: FilterItem) {
        resetData?()
        switch filter {
        case .timer:
            loadTimerTasks()
        case .date:
            loadDateTasks()
        case .all:
            loadTimerTasks()
            loadDateTasks()
        case .location:
            print("location tapped")
        case .laguage:
            print("laguage tapped")
        case .sedfswerdf:
            print("sedfswerdf tapped")
        }
    }
}
