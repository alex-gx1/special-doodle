import Foundation
import CoreData

public final class FRCService<DTO: DTODescription>: NSObject, NSFetchedResultsControllerDelegate {
    
    public var didChangeContent: (([any DTODescription]) -> Void)?
    
    private let request: NSFetchRequest<DTO.MO> = {
        return NSFetchRequest<DTO.MO>(entityName: "\(DTO.MO.self)")
    }()
    
    private lazy var frc: NSFetchedResultsController<DTO.MO> = {
        let frc = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: CoreDataService.shared.mainContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        frc.delegate = self
        return frc
    }()
    
    public var fetchedDTOs: [any DTODescription] {
        let dtos = frc.fetchedObjects?.compactMap{ $0.toDTO() }
        return dtos ?? []
    }
    
    init(_ requestBuilder: (NSFetchRequest<DTO.MO>) -> Void ) {
        requestBuilder(self.request)
    }
    
    public func startHandle() {
        try? frc.performFetch()
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        try? controller.performFetch()
        didChangeContent?(fetchedDTOs)
    }
}
