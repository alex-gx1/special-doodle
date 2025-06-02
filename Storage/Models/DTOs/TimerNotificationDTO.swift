import Foundation
import CoreData

public struct TimerNotificationDTO: DTODescription {
    
    public typealias MO = TimerNotificationMO
    
    public var id: String
    public var title: String
    public var subtitle: String?
    public var date: Date
    public var completedDate: Date?
    
    public var work: String?
    public var other: String?
    public var critical: String?
    public var highPriority: String?
    public var mediumPriority: String?
    public var lowPriority: String?
    
    public var seconds: Double
    
    public init(
        id: String,
        title: String,
        subtitle: String? = nil,
        date: Date,
        completedDate: Date? = nil,
        seconds: Double,
        
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
        self.seconds = seconds
        
        self.work = work
        self.other = other
        self.critical = critical
        self.highPriority = highPriority
        self.mediumPriority = mediumPriority
        self.lowPriority = lowPriority
    }
    
    public static func fromMO(_ mo: TimerNotificationMO) -> TimerNotificationDTO? {
        guard
            let id = mo.identifier,
            let title = mo.title,
            let date = mo.date
        else { return nil }
        
        return TimerNotificationDTO(
            id: id,
            title: title,
            subtitle: mo.subtitle,
            date: date,
            completedDate: mo.completedDate,
            seconds: mo.seconds,
            work: mo.work,
            other: mo.other,
            critical: mo.critical,
            highPriority: mo.highPriority,
            mediumPriority: mo.mediumPriority,
            lowPriority: mo.lowPriority
        )
    }
}
