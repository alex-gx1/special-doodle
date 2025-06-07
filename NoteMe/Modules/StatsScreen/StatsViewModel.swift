import UIKit
import DGCharts
import Storage

protocol StatsRouterProtocol {}

final class StatsViewModel: StatsViewModelProtocol {
    private let router: StatsRouterProtocol
    private let allNotificationsStorage = AllNotficationStorage()
    
    init(router: StatsRouterProtocol) {
        self.router = router
    }
    
    func getFirstPieChartData() -> [PieChartDataEntry] {
        let allTasks = allNotificationsStorage.fetch()
        
        var dateCount = 0
        var timerCount = 0
        var locationCount = 0
        
        for task in allTasks {
            if task is DateNotificationDTO {
                dateCount += 1
            } else if task is TimerNotificationDTO {
                timerCount += 1
            } else if task is LocationNotificationDTO {
                locationCount += 1
            }
        }
        
        return [
            PieChartDataEntry(value: Double(dateCount), label: "Дата"),
            PieChartDataEntry(value: Double(timerCount), label: "Таймер"),
            PieChartDataEntry(value: Double(locationCount), label: "Локация")
        ]
    }
    
    func getSecondPieChartData() -> [PieChartDataEntry] {
        let allTasks = allNotificationsStorage.fetch()
        
        var completedCount = 0
        var notCompletedCount = 0
        
        for task in allTasks {
            if let dateTask = task as? DateNotificationDTO {
                dateTask.completedDate == nil ? (notCompletedCount += 1) : (completedCount += 1)
            } else if let timerTask = task as? TimerNotificationDTO {
                timerTask.completedDate == nil ? (notCompletedCount += 1) : (completedCount += 1)
            } else if let locationTask = task as? LocationNotificationDTO {
                locationTask.completedDate == nil ? (notCompletedCount += 1) : (completedCount += 1)
            }
        }
        
        return [
            PieChartDataEntry(value: Double(Int(completedCount)), label: "Выполнено"),
            PieChartDataEntry(value: Double(notCompletedCount), label: "Не выполнено")
        ]
    }
}
