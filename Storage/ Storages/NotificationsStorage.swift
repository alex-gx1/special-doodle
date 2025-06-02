import Foundation
import CoreData

public class NotificationsStorage<DTO: DTODescription> {
    public typealias CompletionHandler = (Bool) -> Void
    public init() {}
    
    public func fetchMO(
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor] = []
    ) -> [DTO.MO] {
        let request = NSFetchRequest<DTO.MO>(entityName: "\(DTO.MO.self)")
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        let context = CoreDataService.shared.mainContext
        let results = try? context.fetch(request)
        return results ?? []
    }
    
    public func fetch(
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor] = []
    ) -> [any DTODescription] {
        return fetchMO(predicate: predicate, sortDescriptors: sortDescriptors)
            .compactMap { $0.toDTO() }
    }
    
    public func create(
        dto: DTO,
        completion: CompletionHandler? = nil
    ) {
        let context = CoreDataService.shared.backgroundContext
        context.perform {
            let mo = DTO.MO(context: context)
            mo.apply(dto: dto)
            CoreDataService.shared.saveContext(context: context, completion: completion)
        }
    }
    
    public func update(
        dto: DTO,
        completion: CompletionHandler? = nil
    ) {
        let context = CoreDataService.shared.backgroundContext
        context.perform { [weak self] in
            guard let mo = self?.fetchMO(predicate: .Notification.notification(byId: dto.id)).first else { return }
            mo.apply(dto: dto)
            CoreDataService.shared.saveContext(context: context, completion: completion)
        }
    }
    
    public func updateOrCreate(
        dto: DTO,
        completion: CompletionHandler? = nil
    ) {
        if fetchMO(predicate: .Notification.notification(byId: dto.id)).isEmpty {
            create(dto: dto, completion: completion)
        } else {
            update(dto: dto, completion: completion)
        }
    }
        
    public func updateCompletedDate(
        id: String,
        date: Date,
        completion: CompletionHandler? = nil
    ) {
        let context = CoreDataService.shared.backgroundContext
        
        context.perform {
            let request = NSFetchRequest<DTO.MO>(entityName: "\(DTO.MO.self)")
            request.predicate = NSPredicate(format: "identifier == %@", id)
            
            do {
                guard let mo = try context.fetch(request).first as? MODescription else {
                    DispatchQueue.main.async {
                        completion?(false)
                    }
                    return
                }
                
                print("Current completedDate: \(mo.completedDate?.description ?? "nil")")
                mo.completedDate = date
                print("New completedDate: \(mo.completedDate?.description ?? "nil")")
                
                try context.save()
                
                DispatchQueue.main.async {
                    completion?(true)
                }
                
            } catch {
                print("Failed to update completedDate: \(error)")
                DispatchQueue.main.async {
                    completion?(false)
                }
            }
        }
    }
    
    public func delete(
        predicate: NSPredicate,
        completion: CompletionHandler? = nil
    ) {
        let context = CoreDataService.shared.backgroundContext
        context.perform { [weak self] in
            guard let self = self else { return }
            let objects = self.fetchMO(predicate: predicate)
            for object in objects {
                context.delete(object)
            }
            CoreDataService.shared.saveContext(context: context, completion: completion)
        }
    }
    
    public func delete(by id: String, completion: CompletionHandler? = nil) {
        let context = CoreDataService.shared.backgroundContext
        context.perform {
            let predicate = NSPredicate(format: "identifier == %@", id)
            let objects = self.fetchMO(predicate: predicate)
            for obj in objects {
                context.delete(obj)
            }
            CoreDataService.shared.saveContext(context: context, completion: completion)
        }
    }
    
}
