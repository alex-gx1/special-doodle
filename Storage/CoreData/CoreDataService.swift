import Foundation
import CoreData

final class CoreDataService {
    
    static var shared: CoreDataService = .init()
    typealias CompletionHandler = ((Bool) -> Void)
    
    private init() {}
    
    var backgroundContext: NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        return context
    }
    
    var mainContext: NSManagedObjectContext {
        let context = persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context 
    }
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NotificationDataBase")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved CoreData error: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveMainContext(completion: CompletionHandler? = nil) {
        saveContext(context: mainContext, completion: completion)
    }
    
    func saveContext(context: NSManagedObjectContext,
                     completion: ((Bool) ->  Void)? = nil) {
        if context.hasChanges {
            do{
                try context.save()
                completion?(true)
            } catch {
                let nserror = error as NSError
                completion?(false)
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            
        }
    }
}
