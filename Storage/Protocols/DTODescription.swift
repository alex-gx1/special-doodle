import Foundation
import CoreData

public protocol DTODescription {
    
    associatedtype MO: MODescription
    
    var id: String { get set }
    var date: Date { get set }
    var title: String { get set }
    var subtitle: String? { get set }
    var completedDate: Date? { get set }
    
    var work: String? { get set }
    var other: String? { get set }
    var critical: String? { get set }
    var highPriority: String? { get set }
    var mediumPriority: String? { get set }
    var lowPriority: String? { get set }
    
    static func fromMO(_ mo: MO) -> Self?
    
    func createMO(context: NSManagedObjectContext) -> MO?
}

public protocol MODescription: NSManagedObject, NSFetchRequestResult {
    var completedDate: Date? { get set }
    func apply(dto: any DTODescription)
    func toDTO() -> (any DTODescription)?
}
