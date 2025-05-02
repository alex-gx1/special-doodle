import CoreData
import Foundation

public final class DateNotificationStorage: NotificationsStorage<DateNotificationDTO> {
    
    public func fetch(
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor] = []) -> [DateNotificationDTO]
    {
        return super.fetch(
            predicate: predicate,
            sortDescriptors: sortDescriptors
        ).compactMap { $0 as? DateNotificationDTO}
    }
}
