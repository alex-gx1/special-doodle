import Foundation
import FirebaseDatabase
import Storage
import FirebaseAuth
import FirebaseCore

final class FirebaseBackupService {
    
    private let backupQueue: DispatchQueue = .init(label: "com.noteme.backup", qos: .background, attributes: .concurrent)
    
    private var userId: String? {
        return Auth.auth().currentUser?.uid
    }
    
    private var ref: DatabaseReference {
        return Database.database(url: "https://noteme-ad1cd-default-rtdb.europe-west1.firebasedatabase.app/").reference()
    }
    
    
    private var storage: AllNotficationStorage
    
    init(storage: AllNotficationStorage) {
        self.storage = storage
    }
    
    func backup(dto: any DTODescription) {
        guard let userId else { return }
        backupQueue.async { [weak ref] in
            let backupModel = BackupModel(dto: dto)
            let dict = backupModel.buildDict()
            
            ref? .child("notifications")
                .child(userId)
                .child(dto.id).setValue(
                    dict
                )
        }
    }
        
    func loadBackup(completion: @escaping ([any DTODescription]) -> Void) {
        guard let userId else { return }
        ref
            .child("notifications")
            .child(userId)
            .getData { [weak self] error, snapshot in
//                self?.backupQueue.async {
                    guard
                        let snapshotDict = snapshot?.value as? [String: Any]
                    else {
                        completion([])
                        return
                    }
                    
                    let value = snapshotDict.map { _, value in value }
                    
                    guard
                        let data = try? JSONSerialization.data(withJSONObject: value),
                        let backupModels = try? JSONDecoder().decode(
                            [BackupModel].self,
                            from: data
                        )
                    else {
                        completion([])
                        return
                    }
                    
                    completion(backupModels.map{ $0.dto})
//                }
            }
    }
}

extension FirebaseBackupService {
    func backupAllData(completion: @escaping (Bool) -> Void) {
        guard let userId = userId else {
            DispatchQueue.main.async { completion(false) }
            return
        }
        
        let allNotifications = storage.fetch()
        let group = DispatchGroup()
        var success = true
        
        for dto in allNotifications {
            group.enter()
            
            let backupModel = BackupModel(dto: dto)
            if let dict = backupModel.buildDict() {
                ref.child("notifications")
                    .child(userId)
                    .child(dto.id)
                    .setValue(dict) { error, _ in
                        if error != nil {
                            success = false
                        }
                        group.leave()
                    }
            } else {
                success = false
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(success)
        }
    }
    
    func clearLocalData(completion: @escaping () -> Void) {
        storage.delete(predicate: NSPredicate(value: true)) { _ in
            completion()
        }
    }
    
    func signOut(completion: @escaping (Bool) -> Void) {
        backupAllData { success in
            if success {
                self.clearLocalData {
                    try? Auth.auth().signOut()
                    completion(true)
                }
            } else {
                completion(false)
            }
        }
    }
    
//    func signIn(completion: @escaping (Bool) -> Void) {
//        clearLocalData {
//            self.loadBackup()
//            completion(true)
//        }
//    }
}
