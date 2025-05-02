import CoreData
import Foundation

public final class TimerNotificationStorage: NotificationsStorage<TimerNotificationDTO> {
    
    public func fetch(
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor] = []) -> [TimerNotificationDTO]
    {
        return super.fetch(
            predicate: predicate,
            sortDescriptors: sortDescriptors
        ).compactMap { $0 as? TimerNotificationDTO}
    }
}
