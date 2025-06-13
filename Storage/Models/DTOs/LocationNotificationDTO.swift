import Foundation
import CoreData

public struct LocationNotificationDTO: DTODescription {
    
    public typealias MO = LocationNotificationMO
    
    public var id: String
    public var title: String
    public var subtitle: String?
    public var date: Date
    public var completedDate: Date?
    public var x: Double
    public var y: Double
    public var radius: Double
    public var url: String
    
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
        x: Double,
        y: Double,
        radius: Double,
        url: String,
        
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
        self.x = x
        self.y = y
        self.radius = radius
        self.url = url
        
        self.work = work
        self.other = other
        self.critical = critical
        self.highPriority = highPriority
        self.mediumPriority = mediumPriority
        self.lowPriority = lowPriority
    }
    
    public init?(mo: LocationNotificationMO) {
        guard
            let id = mo.identifier,
            let title = mo.title,
            let date = mo.date
        else { return nil }
        
        self.id = id
        self.title = title
        self.subtitle = mo.subtitle
        self.date = date
        self.completedDate = mo.completedDate
        self.x = mo.x
        self.y = mo.y
        self.radius = mo.radius
        self.url = mo.url
        
        self.work = mo.work
        self.other = mo.other
        self.critical = mo.critical
        self.highPriority = mo.highPriority
        self.mediumPriority = mo.mediumPriority
        self.lowPriority = mo.lowPriority
    }
    
    public static func fromMO(_ mo: LocationNotificationMO) -> LocationNotificationDTO? {
        guard
            let id = mo.identifier,
            let title = mo.title,
            let date = mo.date
        else { return nil }
        
        return LocationNotificationDTO(
            id: id,
            title: title,
            subtitle: mo.subtitle,
            date: date,
            completedDate: mo.completedDate,
            x: mo.x,
            y: mo.y,
            radius: mo.radius,
            url: mo.url,
            work: mo.work,
            other: mo.other,
            critical: mo.critical,
            highPriority: mo.highPriority,
            mediumPriority: mo.mediumPriority,
            lowPriority: mo.lowPriority
            
        )
    }
    
    public func createMO(context: NSManagedObjectContext) -> LocationNotificationMO? {
        let mo = LocationNotificationMO(context: context)
        mo.apply(dto: self)
        return mo
    }
}
