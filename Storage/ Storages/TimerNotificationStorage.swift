import CoreData
import Foundation

public final class TimerNotificationStorage: NotificationsStorage<TimerNotificationDTO> {
    
    public func fetch(
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor] = []) -> [TimerNotificationDTO]
    {
        return super.fetch(
            predicate: predicate,
            sortDescriptors: sortDescriptors
        ).compactMap { $0 as? TimerNotificationDTO}
    }
    
//    override public func updateOrCreate(
//        dto: TimerNotificationDTO,
//        completion: CompletionHandler? = nil
//    ) {
//        super.updateOrCreate(dto: dto, completion: completion)
//    }
//    
//    override public func updateCompletedDate(
//        id: String,
//        date: Date,
    //        completion: CompletionHandler? = nil
    //    ) {
    //        super.updateCompletedDate(id: id, date: date, completion: completion)
    //    }
    
    public override func update(
        dto: TimerNotificationDTO,
        completion: CompletionHandler? = nil
    ) {
        // Просто вызываем родительский метод update
        super.update(dto: dto, completion: completion)
    }
    
    public func delete(id: String, completion: CompletionHandler? = nil) {
        let context = CoreDataService.shared.backgroundContext
        context.perform { [weak self] in
            guard self != nil else { return }
            
            let predicate = NSPredicate(format: "identifier == %@", id)
            let request = NSFetchRequest<TimerNotificationMO>(entityName: "TimerNotificationMO")
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
                print("Failed to fetch or delete timer object: \(error)")
                DispatchQueue.main.async {
                    completion?(false)
                }
            }
        }
    }
}
