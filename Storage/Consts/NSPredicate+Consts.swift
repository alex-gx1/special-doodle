import CoreData

public extension NSPredicate {
    
    enum Notification {
        public static var allNotComleted: NSPredicate {
            let completedDateKeyPath = #keyPath(BaseNotificationMO.completedDate)
            return .init(format: "\(completedDateKeyPath) == NULL" )
        }
        
        public  static func notification(byId id: String) -> NSPredicate {
            let idKeypath = #keyPath(BaseNotificationMO.identifier)
            return .init(format: "\(idKeypath) CONTAINS[cd] %@", id)
        }
    }
}
