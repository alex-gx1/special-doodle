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
    
    public init(
        id: String,
        title: String,
        subtitle: String? = nil,
        date: Date,
        completedDate: Date? = nil,
        targetDate: Date
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.date = date
        self.completedDate = completedDate
        self.targetDate = targetDate
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
            targetDate: targetDate
        )
    }
}
