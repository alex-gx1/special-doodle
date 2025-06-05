import Foundation
import CoreData

public extension NSSortDescriptor {
    
    enum Notification {
        //сортировка по возрастанию
        public static var byDate: NSSortDescriptor {
            let dateKeyPath = #keyPath(BaseNotificationMO.date)
            return .init(key: dateKeyPath, ascending: false)
        }
        
        // Сортировка по возрастанию (старые сначала)
        public static var byDateAscending: NSSortDescriptor {
            let dateKeyPath = #keyPath(BaseNotificationMO.date)
            return .init(key: dateKeyPath, ascending: true)
        }
    }
}
