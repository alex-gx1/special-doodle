import Foundation
import CoreData

public struct  BaseNotificationDTO: DTODescription {
    
    public typealias MO = BaseNotificationMO
    
    public var id: String
    public var date: Date
    public var title: String
    public var subtitle: String?
    public var completedDate: Date?
    
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
        
        self.work = work
        self.other = other
        self.critical = critical
        self.highPriority = highPriority
        self.mediumPriority = mediumPriority
        self.lowPriority = lowPriority
    }
    
    public static func fromMO(_ mo: MO) -> BaseNotificationDTO? {
        guard
            let id = mo.identifier,
            let title = mo.title,
            let date = mo.date
        else { return nil }
        
        return BaseNotificationDTO(
            id: id,
            title: title,
            subtitle: mo.subtitle,
            date: date,
            completedDate: mo.completedDate,
            work: mo.work,
            other: mo.other,
            critical: mo.critical,
            highPriority: mo.highPriority,
            mediumPriority: mo.mediumPriority,
            lowPriority: mo.lowPriority
        )
    }
}
