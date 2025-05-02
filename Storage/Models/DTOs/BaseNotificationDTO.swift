import Foundation
import CoreData

public struct  BaseNotificationDTO: DTODescription {
    
    public typealias MO = BaseNotificationMO
    
    public var id: String
    public var date: Date
    public var title: String
    public var subtitle: String?
    public var completedDate: Date?
    
    public init(
        id: String,
        title: String,
        subtitle: String? = nil,
        date: Date,
        completedDate: Date? = nil
        
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.date = date
        self.completedDate = completedDate
    }
    
    public static func fromMO(_ mo: MO) ->  BaseNotificationDTO? {
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
            completedDate: mo.completedDate
        )
    }
}
