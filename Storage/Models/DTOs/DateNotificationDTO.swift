import Foundation
import CoreData

public struct DateNotificationDTO: DTODescription {
    
    public typealias MO = DateNotificationMO
    
    public var id: String
    public var title: String
    public var subtitle: String?
    public var date: Date
    public var completedDate: Date?
    public var targetDate: Date
    
    public var work: String?
    public var other: String?
    public var critical: String?
    public var highPriority: String?
    public var mediumPriority: String?
    public var lowPriority: String?
    
    public init(
        id: String,
        title: String,
        subtitle: String? = nil,
        date: Date,
        completedDate: Date? = nil,
        targetDate: Date,
        
        work: String? = nil,
        other: String? = nil,
        critical: String? = nil,
        highPriority: String? = nil,
        mediumPriority: String? = nil,
        lowPriority: String? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.date = date
        self.completedDate = completedDate
        self.targetDate = targetDate
        
        self.work = work
        self.other = other
        self.critical = critical
        self.highPriority = highPriority
        self.mediumPriority = mediumPriority
        self.lowPriority = lowPriority
    }
    
    public static func fromMO(_ mo: DateNotificationMO) -> DateNotificationDTO? {
        guard
            let id = mo.identifier,
            let title = mo.title,
            let date = mo.date,
            let targetDate = mo.targetDate
        else { return nil }
        
        return DateNotificationDTO(
            id: id,
            title: title,
            subtitle: mo.subtitle,
            date: date,
            completedDate: mo.completedDate,
            targetDate: targetDate,
            
            work: mo.work,
            other: mo.other,
            critical: mo.critical,
            highPriority: mo.highPriority,
            mediumPriority: mo.mediumPriority,
            lowPriority: mo.lowPriority
        )
    }
    
    public func createMO(context: NSManagedObjectContext) -> DateNotificationMO? {
        let mo = DateNotificationMO(context: context)
        mo.apply(dto: self)
        return mo
    }
}
