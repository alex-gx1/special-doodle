import UIKit
import Storage
import FirebaseAuth
import Firebase

protocol ProfileScreenServiceProtocol {
    func signOut()
    func getUserMail() -> String
}

protocol ProfileScreenRouterProtocol {
    func showAlert(
        title: String,
        message: String?,
        onConfirm: @escaping () -> Void
    )
    func showProgressAlert(
        title: String,
        message: String?,
        completion: @escaping () -> Void
    )
    func showErrorAlert(
        title: String,
        message: String?
    )
    func dismissAlert(completion: @escaping () -> Void)
    func showShareSheet(with url: URL)
    func openLoginScreen()
    func openStatsScreen()
}

final class ProfileScreenViewModel: ProfileScreenViewModelProtocol{
    
    let storage = AllNotficationStorage()
    func importData() {
        
        let backupService = FirebaseBackupService(storage: storage)
        
        backupService.loadBackup { [weak self] dtos in
            self?.storage.createDTOs(dtos: dtos )
        }}

private let router: ProfileScreenRouterProtocol
private let authService: ProfileScreenServiceProtocol
private let parametersService: ParametersService


init(router: ProfileScreenRouterProtocol, authService: ProfileScreenServiceProtocol, parametersService: ParametersService) {
    self.router = router
    self.authService = authService
    self.parametersService = parametersService
}

func getUserMail() -> String {
    return authService.getUserMail()
}

//    func showAlert(Title: String, Message: String?) {
//        router.showAlert(
//            title: Title,
//            message: Message,
//            onConfirm: { [weak self] in
//                self?.authService.signOut()
//                self?.parametersService.set(value: false, for: .isUserLogin)
//                self?.router.openLoginScreen()
//            }
//        )
//    }
func showAlert(Title: String, Message: String?) {
    router.showAlert(
        title: Title,
        message: Message,
        onConfirm: { [weak self] in
            guard let self = self else { return }
            
            
            self.router.showProgressAlert(
                title: "Сохранение данных",
                message: "Пожалуйста, подождите..."
            ) {
                
                let storage = AllNotficationStorage()
                let firebaseService = FirebaseBackupService(storage: storage)
                
                
                firebaseService.backupAllData { success in
                    DispatchQueue.main.async {
                        self.router.dismissAlert {
                            if success {
                                storage.delete(predicate: NSPredicate(value: true))
                                
                                self.authService.signOut()
                                self.parametersService.set(value: false, for: .isUserLogin)
                                self.router.openLoginScreen()
                            } else {
                                
                                self.router.showAlert(
                                    title: "Внимание",
                                    message: "Не удалось сохранить данные. Выйти без сохранения?",
                                    onConfirm: {
                                        self.authService.signOut()
                                        self.parametersService.set(value: false, for: .isUserLogin)
                                        self.router.openLoginScreen()
                                    }
                                )
                            }
                        }
                    }
                }
            }
        }
    )
}

func openStatsScreen() {
    router.openStatsScreen()
}

func exportData() {
    router.showProgressAlert(
        title: "Экспорт данных",
        message: "Подготавливаем ваши задачи..."
    ) { [weak self] in
        DispatchQueue.global(qos: .userInitiated).async {
            guard let url = self?.exportDataToCSV() else {
                DispatchQueue.main.async {
                    self?.router.dismissAlert {
                        self?.router.showErrorAlert(
                            title: "Ошибка",
                            message: "Не удалось экспортировать данные"
                        )
                    }
                }
                return
            }
            
            DispatchQueue.main.async {
                self?.router.dismissAlert {
                    self?.router.showShareSheet(with: url)
                }
            }
        }
    }
}

private func performExport() {
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        guard let self = self else { return }
        
        let url = self.exportDataToCSV()
        
        DispatchQueue.main.async {
            if let url = url {
                self.router.showShareSheet(with: url)
            } else {
                self.router.showErrorAlert(
                    title: "Ошибка",
                    message: "Не удалось экспортировать данные"
                )
            }
        }
    }
}
}

extension ProfileScreenViewModel {
    
    private func formatDateComponents(from date: Date) -> (full: String, day: String, month: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let full = formatter.string(from: date)
        
        formatter.dateFormat = "dd"
        let day = formatter.string(from: date)
        
        formatter.dateFormat = "MM"
        let month = formatter.string(from: date)
        
        return (full, day, month)
    }
    func exportDataToCSV() -> URL? {
        let storage = AllNotficationStorage()
        let dtos = storage.fetch()
        
        var csvString = "Type,ID,Title,Subtitle,CreatedAt,CompletedDate,Work,Other,Critical,HighPriority,MediumPriority,LowPriority,"
        csvString += "Seconds,TargetDate,DateString,Day,Month,URL,X,Y,Radius\n"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        for dto in dtos {
            var baseFields = ""
            
            switch dto {
            case let timerDTO as TimerNotificationDTO:
                baseFields = "Timer,\(timerDTO.id),\"\(timerDTO.title)\",\"\(timerDTO.subtitle ?? "")\","
                baseFields += "\(dateFormatter.string(from: timerDTO.date)),\(dateFormatter.string(from: timerDTO.completedDate ?? Date.distantPast)),"
                baseFields += "\"\(timerDTO.work ?? "")\",\"\(timerDTO.other ?? "")\",\"\(timerDTO.critical ?? "")\",\"\(timerDTO.highPriority ?? "")\",\"\(timerDTO.mediumPriority ?? "")\",\"\(timerDTO.lowPriority ?? "")\","
                baseFields += "\(timerDTO.seconds),,,,,,,"
                
            case let dateDTO as DateNotificationDTO:
                let components = formatDateComponents(from: dateDTO.targetDate)
                baseFields = "Date,\(dateDTO.id),\"\(dateDTO.title)\",\"\(dateDTO.subtitle ?? "")\","
                baseFields += "\(dateFormatter.string(from: dateDTO.date)),\(dateFormatter.string(from: dateDTO.completedDate ?? Date.distantPast)),"
                baseFields += "\"\(dateDTO.work ?? "")\",\"\(dateDTO.other ?? "")\",\"\(dateDTO.critical ?? "")\",\"\(dateDTO.highPriority ?? "")\",\"\(dateDTO.mediumPriority ?? "")\",\"\(dateDTO.lowPriority ?? "")\","
                baseFields += ",\(dateFormatter.string(from: dateDTO.targetDate)),\"\(components.full)\",\"\(components.day)\",\"\(components.month)\",,,"
                
            case let locationDTO as LocationNotificationDTO:
                baseFields = "Location,\(locationDTO.id),\"\(locationDTO.title)\",\"\(locationDTO.subtitle ?? "")\","
                baseFields += "\(dateFormatter.string(from: locationDTO.date)),\(dateFormatter.string(from: locationDTO.completedDate ?? Date.distantPast)),"
                baseFields += "\"\(locationDTO.work ?? "")\",\"\(locationDTO.other ?? "")\",\"\(locationDTO.critical ?? "")\",\"\(locationDTO.highPriority ?? "")\",\"\(locationDTO.mediumPriority ?? "")\",\"\(locationDTO.lowPriority ?? "")\","
                baseFields += ",,,,,\(locationDTO.url),\(locationDTO.x),\(locationDTO.y),\(locationDTO.radius)"
                
            default:
                continue
            }
            
            csvString += baseFields + "\n"
        }
        
        let fileName = "notifications_export_\(Date().timeIntervalSince1970).csv"
        let path = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        
        do {
            try csvString.write(to: path, atomically: true, encoding: .utf8)
            return path
        } catch {
            print("Failed to export CSV: \(error)")
            return nil
        }
    }
}
