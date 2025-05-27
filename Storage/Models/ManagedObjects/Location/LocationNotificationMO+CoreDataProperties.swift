import Foundation
import CoreData


extension LocationNotificationMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationNotificationMO> {
        return NSFetchRequest<LocationNotificationMO>(entityName: "LocationNotificationMO")
    }

    @NSManaged public var x: Double
    @NSManaged public var y: Double
    @NSManaged public var radius: Double
    @NSManaged public var url: String
    
}
