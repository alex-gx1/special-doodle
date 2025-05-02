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
    
    public init(
        id: String,
        title: String,
        subtitle: String? = nil,
        date: Date,
        completedDate: Date? = nil,
        x: Double,
        y: Double,
        radius: Double
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.date = date
        self.completedDate = completedDate
        self.x = x
        self.y = y
        self.radius = radius
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
            radius: mo.radius
        )
    }
}
