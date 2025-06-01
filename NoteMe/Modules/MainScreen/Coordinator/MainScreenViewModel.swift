import UIKit
import Storage

protocol MainScreenViewModelProtocol {
    func loadTimerTasks()
    func loadDateTasks()
    var tasksDidUpdate: (([NotificationModel]) -> Void)? { get set }
    var resetData: (() -> Void)? { get set }
    func didSelectFilter(_ filter: FilterItem)
    func model(at index: Int) -> NotificationModel?
    //for delete methods
    func deleteDateNotification(withId id: String, completion: @escaping (Bool) -> Void)
    func deleteTimerNotification(withId id: String, completion: @escaping (Bool) -> Void)
    func deleteLocationNotification(withId id: String, completion: @escaping (Bool) -> Void)
    
    func presentMenuPopover(from source: UIView, sourceRect: CGRect, forItemId id: String, deleteHandler: @escaping () -> Void)
    //for btn done methods
}

final class MainScreenViewModel: MainScreenViewModelProtocol {
    
    private let router: MainScreenRouterProtocol
    
    var tasksDidUpdate: (([NotificationModel]) -> Void)?
    
    var resetData: (() -> Void)?
    
    private var allModels: [NotificationModel] = []
    
    func model(at index: Int) -> NotificationModel? {
        guard index >= 0 && index < allModels.count else { return nil }
        return allModels[index]
    }
    
    private let dateStorage = DateNotificationStorage()
    private let timerStorage = TimerNotificationStorage()
    private let locationStorage = LocationNotificationStorage()
    
    init(router: MainScreenRouterProtocol) {
        self.router = router
    }
    
    func presentMenuPopover(from source: UIView, sourceRect: CGRect, forItemId id: String, deleteHandler: @escaping () -> Void) {
        router.presentMenuPopover(
            from: source,
            sourceRect: sourceRect,
            forItemId: id,
            deleteHandler: deleteHandler
        )
    }
        
    func deleteDateNotification(withId id: String, completion: @escaping (Bool) -> Void) {
        dateStorage.delete(id: id) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.allModels.removeAll { model in
                        if case .date(let dateModel) = model {
                            return dateModel.identifier == id
                        }
                        return false
                    }
                    self?.tasksDidUpdate?(self?.allModels ?? [])
                }
                completion(success)
            }
        }
    }
    
    func deleteTimerNotification(withId id: String, completion: @escaping (Bool) -> Void) {
        timerStorage.delete(id: id) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.allModels.removeAll { model in
                        if case .timer(let timerModel) = model {
                            return timerModel.identifier == id
                        }
                        return false
                    }
                    self?.tasksDidUpdate?(self?.allModels ?? [])
                }
                completion(success)
            }
        }
    }
    
    func deleteLocationNotification(withId id: String, completion: @escaping (Bool) -> Void) {
        locationStorage.delete(id: id) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    if let url = self?.getLocationImageUrl(for: id) {
                        self?.deleteImageIfNeeded(url: url)
                    }
                    
                    self?.allModels.removeAll { model in
                        if case .location(let locationModel) = model {
                            return locationModel.identifier == id
                        }
                        return false
                    }
                    self?.tasksDidUpdate?(self?.allModels ?? [])
                }
                completion(success)
            }
        }
    }
    
    private func getLocationImageUrl(for id: String) -> String? {
        return allModels.first { model in
            if case .location(let locationModel) = model {
                return locationModel.identifier == id
            }
            return false
        }.flatMap {
            if case .location(let locationModel) = $0 {
                return locationModel.url
            }
            return nil
        }
    }
    
    private func deleteImageIfNeeded(url: String) {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: url) {
            try? fileManager.removeItem(atPath: url)
        }
    }
    
    func loadTimerTasks() {
        let storage = TimerNotificationStorage()
        let dtos = storage.fetch()
        
        let tasks: [NotificationModel] = dtos.map {
            .timer(
                TimerTaskModel(
                    identifier: $0.id,
                    title: $0.title,
                    subtitle: $0.subtitle ?? "",
                    seconds: $0.seconds,
                    createdAt: $0.date,
                    completedDate: $0.completedDate ?? Date.distantPast
                )
            )
        }
        allModels = tasks
        tasksDidUpdate?(tasks)
    }
    
    func loadDateTasks() {
        let storage = DateNotificationStorage()
        let dtos = storage.fetch()
        
        let tasks: [NotificationModel] = dtos.map {
            let components = formatDateComponents(from: $0.targetDate)
            return .date(DateTaskModel(
                identifier: $0.id,
                title: $0.title,
                subtitle: $0.subtitle ?? "",
                dateString: components.full,
                day: components.day,
                month: components.month,
                createdAt: $0.date,
                targetDate: $0.targetDate,
                completedDate: $0.completedDate ?? Date.distantPast
            ))
        }
        allModels = tasks
        tasksDidUpdate?(tasks)
    }
    
    func loadLocationTasks() {
        let storage = LocationNotificationStorage()
        let dtos = storage.fetch()
        
        let tasks: [NotificationModel] = dtos.map {
            .location(
                LocationTaskModel(
                    identifier: $0.id,
                    title: $0.title,
                    subtitle: $0.subtitle ?? "",
                    url: $0.url,
                    completedDate: $0.completedDate ?? Date.distantPast
                )
            )
        }
        allModels = tasks
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
                        identifier: timerDTO.id,
                        title: timerDTO.title,
                        subtitle: timerDTO.subtitle ?? "",
                        seconds: timerDTO.seconds,
                        createdAt: timerDTO.date,
                        completedDate: timerDTO.completedDate ?? Date.distantPast
                    )
                )
            case let dateDTO as DateNotificationDTO:
                let components = formatDateComponents(from: dateDTO.targetDate)
                return .date(
                    DateTaskModel(
                        identifier: dateDTO.id,
                        title: dateDTO.title,
                        subtitle: dateDTO.subtitle ?? "",
                        dateString: components.full,
                        day: components.day,
                        month: components.month,
                        createdAt: dateDTO.date,
                        targetDate: dateDTO.targetDate,
                        completedDate: dateDTO.completedDate ?? Date.distantPast
                    )
                )
            case let locationDTO as LocationNotificationDTO:
                return .location(
                    LocationTaskModel(
                        identifier: locationDTO.id,
                        title: locationDTO.title,
                        subtitle: locationDTO.subtitle ?? "",
                        url: locationDTO.url,
                        completedDate: locationDTO.completedDate ?? Date.distantPast
                    )
                )
            default:
                return nil
            }
        }
        allModels = models
        tasksDidUpdate?(models)
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
    
    func didSelectFilter(_ filter: FilterItem) {
        resetData?()
        
        switch filter {
        case .timer:
            loadTimerTasks()
        case .date:
            loadDateTasks()
        case .all:
            loadAllTasks()
        case .location:
            loadLocationTasks()
        default:
            break
        }
    }
}
