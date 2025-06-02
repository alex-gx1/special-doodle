import Foundation
import CoreData

extension BaseNotificationMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BaseNotificationMO> {
        return NSFetchRequest<BaseNotificationMO>(entityName: "BaseNotificationMO")
    }

    @NSManaged public var identifier: String?
    @NSManaged public var title: String?
    @NSManaged public var subtitle: String?
    @NSManaged public var date: Date?
    @NSManaged public var completedDate: Date?
    
    @NSManaged public var work: String?
    @NSManaged public var other: String?
    
    @NSManaged public var critical: String?
    @NSManaged public var highPriority: String?
    @NSManaged public var mediumPriority: String?
    @NSManaged public var lowPriority: String?

}

extension BaseNotificationMO : Identifiable {}
