import CoreData
import Foundation

public final class LocationNotificationStorage: NotificationsStorage<LocationNotificationDTO> {
    
    public func fetch(
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor] = []) -> [LocationNotificationDTO]
    {
        return super.fetch(
            predicate: predicate,
            sortDescriptors: sortDescriptors
        ).compactMap { $0 as? LocationNotificationDTO}
    }
}
