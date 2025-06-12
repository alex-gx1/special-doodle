import Foundation
import FirebaseDatabase
import Storage
import FirebaseAuth

final class FirebaseBackupService {
    
    private var userId: String? {
        return Auth.auth().currentUser?.uid
    }
    
    private var ref: DatabaseReference {
        return Database.database().reference()
    }
    
    func backup(dto: any DTODescription) {
        guard let userId else { return }
        let backupModel = BackupModel(dto: dto)
        let dict = backupModel.buildDict()
        
        ref .child("notifications")
            .child(userId)
            .child(dto.id).setValue(
                dict
            )
    }
    
    func loadBackup() {
        guard let userId else { return }
        ref
            .child("notifications")
            .child(userId)
            .getData { error, snapshot in
                guard
                    let snapshotDict = snapshot?.value as? [String: Any]
                else {
                    return
                }
                let value = snapshotDict.map { _, value in value }
                guard
                    //                    let value = snapshot?.value,
                    let data = try? JSONSerialization.data(withJSONObject: value),
                    let backupModels = try? JSONDecoder().decode(
                        [BackupModel].self,
                        from: data
                    )
                else {
                    return
                }
                print(backupModels)
            }
    }
}

