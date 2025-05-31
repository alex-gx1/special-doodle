import CoreData
import Foundation

public final class DateNotificationStorage: NotificationsStorage<DateNotificationDTO> {
    
    public func fetch(
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor] = []) -> [DateNotificationDTO]
    {
        return super.fetch(
            predicate: predicate,
            sortDescriptors: sortDescriptors
        ).compactMap { $0 as? DateNotificationDTO}
    }
    
    public func delete(id: String, completion: CompletionHandler? = nil) {
        let context = CoreDataService.shared.backgroundContext
        context.perform { [weak self] in
            guard self != nil else { return }
            
            let predicate = NSPredicate(format: "identifier == %@", id)
            let request = NSFetchRequest<DateNotificationMO>(entityName: "DateNotificationMO")
            request.predicate = predicate
            
            do {
                let results = try context.fetch(request)
                guard let objectToDelete = results.first else {
                    DispatchQueue.main.async {
                        completion?(false)
                    }
                    return
                }
                
                guard objectToDelete.managedObjectContext == context else {
                    DispatchQueue.main.async {
                        completion?(false)
                    }
                    return
                }
                
                context.delete(objectToDelete)
                
                CoreDataService.shared.saveContext(context: context) { success in
                    DispatchQueue.main.async {
                        completion?(success)
                    }
                }
            } catch {
                print("Failed to fetch or delete object: \(error)")
                DispatchQueue.main.async {
                    completion?(false)
                }
            }
        }
    }
}
