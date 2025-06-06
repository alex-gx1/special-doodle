import UIKit
import Storage

protocol MainScreenViewModelProtocol {
    //    func loadTimerTasks(with sortDescriptors: [NSSortDescriptor])
    //    func loadDateTasks()
    var tasksDidUpdate: (([NotificationModel]) -> Void)? { get set }
    var resetData: (() -> Void)? { get set }
    func didSelectFilter(_ filter: FilterItem)
    func model(at index: Int) -> NotificationModel?
    //    func loadAllTasks()
    //for delete methods
    func deleteDateNotification(withId id: String, completion: @escaping (Bool) -> Void)
    func deleteTimerNotification(withId id: String, completion: @escaping (Bool) -> Void)
    func deleteLocationNotification(withId id: String, completion: @escaping (Bool) -> Void)
    
    func presentMenuPopover(from source: UIView, sourceRect: CGRect, forItemId id: String,
                            deleteHandler: @escaping () -> Void, completeHandler: @escaping () -> Void)
    //for btn done methods
    func completeDateNotification(withId id: String, completion: @escaping (Bool) -> Void)
    func completeTimerNotification(withId id: String, completion: @escaping (Bool) -> Void)
    func completeLocationNotification(withId id: String, completion: @escaping (Bool) -> Void)
    
    //for sort btn
    func toggleSortOrder()
    var isAscendingOrder: Bool { get }
    
    //for search
    func searchTasks(with text: String)
    func clearSearch()
}

final class MainScreenViewModel: MainScreenViewModelProtocol {
    
    func searchTasks(with text: String) {
        let searchText = text.lowercased()
        let sortDescriptor = currentSortDescriptor()
        let predicate = NSPredicate(format: "title CONTAINS[c] %@ OR subtitle CONTAINS[c] %@", searchText, searchText)
        
        let storage = AllNotficationStorage()
        let dtos = storage.fetch(predicate: predicate, sortDescriptors: [sortDescriptor])
        
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
                        completedDate: timerDTO.completedDate ?? Date.distantPast,
                        work: timerDTO.work ?? "",
                        other: timerDTO.other ?? "",
                        critical: timerDTO.critical ?? "",
                        highPriority: timerDTO.highPriority ?? "",
                        mediumPriority: timerDTO.mediumPriority ?? "",
                        lowPriority: timerDTO.lowPriority ?? ""
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
                        completedDate: dateDTO.completedDate ?? Date.distantPast,
                        work: dateDTO.work ?? "",
                        other: dateDTO.other ?? "",
                        critical: dateDTO.critical ?? "",
                        highPriority: dateDTO.highPriority ?? "",
                        mediumPriority: dateDTO.mediumPriority ?? "",
                        lowPriority: dateDTO.lowPriority ?? ""
                    )
                )
            case let locationDTO as LocationNotificationDTO:
                return .location(
                    LocationTaskModel(
                        identifier: locationDTO.id,
                        title: locationDTO.title,
                        subtitle: locationDTO.subtitle ?? "",
                        url: locationDTO.url,
                        createdAt: locationDTO.date,
                        completedDate: locationDTO.completedDate ?? Date.distantPast,
                        x: locationDTO.x,
                        y: locationDTO.y,
                        radius: locationDTO.radius,
                        work: locationDTO.work ?? "",
                        other: locationDTO.other ?? "",
                        critical: locationDTO.critical ?? "",
                        highPriority: locationDTO.highPriority ?? "",
                        mediumPriority: locationDTO.mediumPriority ?? "",
                        lowPriority: locationDTO.lowPriority ?? ""
                    )
                )
            default:
                return nil
            }
        }
        
        allModels = models
        tasksDidUpdate?(models)
    }

    func clearSearch() {
        didSelectFilter(currentFilter)
    }
    
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
    
    private var currentFilter: FilterItem = .all
    private var isAscending = false
    
    var isAscendingOrder: Bool {
        return isAscending
    }
    
    func toggleSortOrder() {
        isAscending.toggle()
        didSelectFilter(currentFilter)
    }
    
    private func currentSortDescriptor() -> NSSortDescriptor {
        return isAscending ?
        NSSortDescriptor.Notification.byDateAscending :
        NSSortDescriptor.Notification.byDate
    }
    
    init(router: MainScreenRouterProtocol) {
        self.router = router
    }
    
    func presentMenuPopover(from source: UIView, sourceRect: CGRect, forItemId id: String,
                            deleteHandler: @escaping () -> Void, completeHandler: @escaping () -> Void) {
        router.presentMenuPopover(
            from: source,
            sourceRect: sourceRect,
            forItemId: id,
            deleteHandler: deleteHandler,
            completeHandler: completeHandler
        )
    }
    
    func completeDateNotification(withId id: String, completion: @escaping (Bool) -> Void) {
        dispatchPrecondition(condition: .onQueue(DispatchQueue.main))
        
        dateStorage.updateCompletedDate(id: id, date: Date()) { [weak self] success in
            
            if success, let index = self?.allModels.firstIndex(where: { model in
                if case .date(let dateModel) = model {
                    return dateModel.identifier == id
                }
                return false
            }), case .date(let dateModel) = self?.allModels[index] {
                
                let updatedModel = DateTaskModel(
                    identifier: dateModel.identifier,
                    title: dateModel.title,
                    subtitle: dateModel.subtitle,
                    dateString: dateModel.dateString,
                    day: dateModel.day,
                    month: dateModel.month,
                    createdAt: dateModel.createdAt,
                    targetDate: dateModel.targetDate,
                    completedDate: Date(),
                    work: dateModel.work,
                    other: dateModel.other,
                    critical: dateModel.critical,
                    highPriority: dateModel.highPriority,
                    mediumPriority: dateModel.mediumPriority,
                    lowPriority: dateModel.lowPriority
                )
                
                self?.allModels[index] = .date(updatedModel)
                self?.tasksDidUpdate?(self?.allModels ?? [])
            }
            
            completion(success)
        }
    }
    
    func completeTimerNotification(withId id: String, completion: @escaping (Bool) -> Void) {
        dispatchPrecondition(condition: .onQueue(DispatchQueue.main))
        
        timerStorage.updateCompletedDate(id: id, date: Date()) { [weak self] success in
            if success, let index = self?.allModels.firstIndex(where: { model in
                if case .timer(let timerModel) = model {
                    return timerModel.identifier == id
                }
                return false
            }), case .timer(let timerModel) = self?.allModels[index] {
                
                let updatedModel = TimerTaskModel(
                    identifier: timerModel.identifier,
                    title: timerModel.title,
                    subtitle: timerModel.subtitle,
                    seconds: timerModel.seconds,
                    createdAt: timerModel.createdAt,
                    completedDate: Date(),
                    work: timerModel.work,
                    other: timerModel.other,
                    critical: timerModel.critical,
                    highPriority: timerModel.highPriority,
                    mediumPriority: timerModel.mediumPriority,
                    lowPriority: timerModel.lowPriority
                )
                
                self?.allModels[index] = .timer(updatedModel)
                self?.tasksDidUpdate?(self?.allModels ?? [])
            }
            
            completion(success)
        }
    }
    
    func completeLocationNotification(withId id: String, completion: @escaping (Bool) -> Void) {
        dispatchPrecondition(condition: .onQueue(DispatchQueue.main))
        
        locationStorage.updateCompletedDate(id: id, date: Date()) { [weak self] success in
            if success, let index = self?.allModels.firstIndex(where: { model in
                if case .location(let locationModel) = model {
                    return locationModel.identifier == id
                }
                return false
            }), case .location(let locationModel) = self?.allModels[index] {
                
                let updatedModel = LocationTaskModel(
                    identifier: locationModel.identifier,
                    title: locationModel.title,
                    subtitle: locationModel.subtitle,
                    url: locationModel.url,
                    createdAt: locationModel.createdAt,
                    completedDate: Date(),
                    x: locationModel.x,
                    y: locationModel.y,
                    radius: locationModel.radius,
                    work: locationModel.work,
                    other: locationModel.other,
                    critical: locationModel.critical,
                    highPriority: locationModel.highPriority,
                    mediumPriority: locationModel.mediumPriority,
                    lowPriority: locationModel.lowPriority
                )
                
                self?.allModels[index] = .location(updatedModel)
                self?.tasksDidUpdate?(self?.allModels ?? [])
            }
            
            completion(success)
        }
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
    
    func loadTimerTasks(with sortDescriptors: [NSSortDescriptor] = []) {
        let storage = TimerNotificationStorage()
        let dtos = storage.fetch(sortDescriptors: sortDescriptors)
        
        let tasks: [NotificationModel] = dtos.map {
            .timer(
                TimerTaskModel(
                    identifier: $0.id,
                    title: $0.title,
                    subtitle: $0.subtitle ?? "",
                    seconds: $0.seconds,
                    createdAt: $0.date,
                    completedDate: $0.completedDate ?? Date.distantPast,
                    work: $0.work ?? "",
                    other: $0.other ?? "",
                    critical: $0.critical ?? "",
                    highPriority: $0.highPriority ?? "",
                    mediumPriority: $0.mediumPriority ?? "",
                    lowPriority: $0.lowPriority ?? ""
                )
            )
        }
        allModels = tasks
        tasksDidUpdate?(tasks)
    }
    
    func loadDateTasks(with sortDescriptors: [NSSortDescriptor] = []) {
        let storage = DateNotificationStorage()
        let dtos = storage.fetch(sortDescriptors: sortDescriptors)
        
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
                completedDate: $0.completedDate ?? Date.distantPast,
                work: $0.work ?? "",
                other: $0.other ?? "",
                critical: $0.critical ?? "",
                highPriority: $0.highPriority ?? "",
                mediumPriority: $0.mediumPriority ?? "",
                lowPriority: $0.lowPriority ?? ""
            ))
        }
        allModels = tasks
        tasksDidUpdate?(tasks)
    }
    
    func loadLocationTasks(with sortDescriptors: [NSSortDescriptor] = []) {
        let storage = LocationNotificationStorage()
        let dtos = storage.fetch(sortDescriptors: sortDescriptors)
        
        let tasks: [NotificationModel] = dtos.map {
            .location(
                LocationTaskModel(
                    identifier: $0.id,
                    title: $0.title,
                    subtitle: $0.subtitle ?? "",
                    url: $0.url,
                    createdAt: $0.date,
                    completedDate: $0.completedDate ?? Date.distantPast,
                    x: $0.x,
                    y: $0.y,
                    radius: $0.radius,
                    work: $0.work ?? "",
                    other: $0.other ?? "",
                    critical: $0.critical ?? "",
                    highPriority: $0.highPriority ?? "",
                    mediumPriority: $0.mediumPriority ?? "",
                    lowPriority: $0.lowPriority ?? ""
                )
            )
        }
        allModels = tasks
        tasksDidUpdate?(tasks)
    }
    
    func loadAllTasks(with sortDescriptors: [NSSortDescriptor] = []) {
        let storage = AllNotficationStorage()
        let dtos = storage.fetch(sortDescriptors: sortDescriptors)
        
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
                        completedDate: timerDTO.completedDate ?? Date.distantPast,
                        work: timerDTO.work ?? "",
                        other: timerDTO.other ?? "",
                        critical: timerDTO.critical ?? "",
                        highPriority: timerDTO.highPriority ?? "",
                        mediumPriority: timerDTO.mediumPriority ?? "",
                        lowPriority: timerDTO.lowPriority ?? ""
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
                        completedDate: dateDTO.completedDate ?? Date.distantPast,
                        work: dateDTO.work ?? "",
                        other: dateDTO.other ?? "",
                        critical: dateDTO.critical ?? "",
                        highPriority: dateDTO.highPriority ?? "",
                        mediumPriority: dateDTO.mediumPriority ?? "",
                        lowPriority: dateDTO.lowPriority ?? ""
                    )
                )
            case let locationDTO as LocationNotificationDTO:
                return .location(
                    LocationTaskModel(
                        identifier: locationDTO.id,
                        title: locationDTO.title,
                        subtitle: locationDTO.subtitle ?? "",
                        url: locationDTO.url,
                        createdAt: locationDTO.date,
                        completedDate: locationDTO.completedDate ?? Date.distantPast,
                        x: locationDTO.x,
                        y: locationDTO.y,
                        radius: locationDTO.radius,
                        work: locationDTO.work ?? "",
                        other: locationDTO.other ?? "",
                        critical: locationDTO.critical ?? "",
                        highPriority: locationDTO.highPriority ?? "",
                        mediumPriority: locationDTO.mediumPriority ?? "",
                        lowPriority: locationDTO.lowPriority ?? ""
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
    
    private func filterTasksByWork(with sortDescriptors: [NSSortDescriptor] = []) {
        loadAllTasks(with: sortDescriptors)
        let workModels = allModels.filter { model in
            switch model {
            case .timer(let timerModel): return !timerModel.work.isEmpty
            case .date(let dateModel): return !dateModel.work.isEmpty
            case .location(let locationModel): return !locationModel.work.isEmpty
            }
        }
        allModels = workModels
        tasksDidUpdate?(allModels)
    }
    
    private func filterTasksByOther(with sortDescriptors: [NSSortDescriptor] = []) {
        loadAllTasks(with: sortDescriptors)
        let otherModels = allModels.filter { model in
            switch model {
            case .timer(let timerModel): return !timerModel.other.isEmpty
            case .date(let dateModel): return !dateModel.other.isEmpty
            case .location(let locationModel): return !locationModel.other.isEmpty
            }
        }
        allModels = otherModels
        tasksDidUpdate?(allModels)
    }
    
    private func filterTasksByCritical(with sortDescriptors: [NSSortDescriptor] = []) {
        loadAllTasks(with: sortDescriptors)
        let criticalModels = allModels.filter { model in
            switch model {
            case .timer(let timerModel): return !timerModel.critical.isEmpty
            case .date(let dateModel): return !dateModel.critical.isEmpty
            case .location(let locationModel): return !locationModel.critical.isEmpty
            }
        }
        allModels = criticalModels
        tasksDidUpdate?(allModels)
    }
    
    private func filterTasksByHigh(with sortDescriptors: [NSSortDescriptor] = []) {
        loadAllTasks(with: sortDescriptors)
        let highPriorityModels = allModels.filter { model in
            switch model {
            case .timer(let timerModel): return !timerModel.highPriority.isEmpty
            case .date(let dateModel): return !dateModel.highPriority.isEmpty
            case .location(let locationModel): return !locationModel.highPriority.isEmpty
            }
        }
        allModels = highPriorityModels
        tasksDidUpdate?(allModels)
    }
    
    private func filterTasksByMedium(with sortDescriptors: [NSSortDescriptor] = []) {
        loadAllTasks(with: sortDescriptors)
        let mediumPriorityModels = allModels.filter { model in
            switch model {
            case .timer(let timerModel): return !timerModel.mediumPriority.isEmpty
            case .date(let dateModel): return !dateModel.mediumPriority.isEmpty
            case .location(let locationModel): return !locationModel.mediumPriority.isEmpty
            }
        }
        allModels = mediumPriorityModels
        tasksDidUpdate?(allModels)
    }
    
    private func filterTasksByLow(with sortDescriptors: [NSSortDescriptor] = []) {
        loadAllTasks(with: sortDescriptors)
        let lowPriorityModels = allModels.filter { model in
            switch model {
            case .timer(let timerModel): return !timerModel.lowPriority.isEmpty
            case .date(let dateModel): return !dateModel.lowPriority.isEmpty
            case .location(let locationModel): return !locationModel.lowPriority.isEmpty
            }
        }
        allModels = lowPriorityModels
        tasksDidUpdate?(allModels)
    }
    
    private func filterTasksByActive(with sortDescriptors: [NSSortDescriptor] = []) {
        loadAllTasks(with: sortDescriptors)
        let activeModels = allModels.filter { model in
            switch model {
            case .timer(let timerModel): return timerModel.completedDate == .distantPast
            case .date(let dateModel): return dateModel.completedDate == .distantPast
            case .location(let locationModel): return locationModel.completedDate == .distantPast
            }
        }
        allModels = activeModels
        tasksDidUpdate?(allModels)
    }
    
    private func filterTasksByCompleted(with sortDescriptors: [NSSortDescriptor] = []) {
        loadAllTasks(with: sortDescriptors)
        let completedModels = allModels.filter { model in
            switch model {
            case .timer(let timerModel): return timerModel.completedDate != .distantPast
            case .date(let dateModel): return dateModel.completedDate != .distantPast
            case .location(let locationModel): return locationModel.completedDate != .distantPast
            }
        }
        allModels = completedModels
        tasksDidUpdate?(allModels)
    }
    
    func didSelectFilter(_ filter: FilterItem) {
        currentFilter = filter
        resetData?()
        
        let sortDescriptor = currentSortDescriptor()
        
        switch filter {
        case .timer:
            loadTimerTasks(with: [sortDescriptor])
        case .date:
            loadDateTasks(with: [sortDescriptor])
        case .all:
            loadAllTasks(with: [sortDescriptor])
        case .location:
            loadLocationTasks(with: [sortDescriptor])
        case .active:
            filterTasksByActive(with: [sortDescriptor])
        case .completed:
            filterTasksByCompleted(with: [sortDescriptor])
        case .work:
            filterTasksByWork(with: [sortDescriptor])
        case .other:
            filterTasksByOther(with: [sortDescriptor])
        case .critical:
            filterTasksByCritical(with: [sortDescriptor])
        case .high:
            filterTasksByHigh(with: [sortDescriptor])
        case .medium:
            filterTasksByMedium(with: [sortDescriptor])
        case .low:
            filterTasksByLow(with: [sortDescriptor])
        default:
            break
        }
    }
}
