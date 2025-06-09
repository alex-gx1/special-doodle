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
    func openLoginScreen()
    func openStatsScreen()
}

final class ProfileScreenViewModel: ProfileScreenViewModelProtocol{
    
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

    func showAlert(Title: String, Message: String?) {
        router.showAlert(
            title: Title,
            message: Message,
            onConfirm: { [weak self] in
                self?.authService.signOut()
                self?.parametersService.set(value: false, for: .isUserLogin)
                self?.router.openLoginScreen()
            }
        )
    }

    func openStatsScreen() {
        router.openStatsScreen()
    }
    
    func exportData(completion: @escaping (URL?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let url = self?.exportDataToCSV()
            DispatchQueue.main.async {
                completion(url)
            }
        }
    }
}

extension ProfileScreenViewModel {
    func exportDataToCSV() -> URL? {
        let storage = AllNotficationStorage()
        let dtos = storage.fetch()
        
        var csvString = "Type,ID,Title,Subtitle,CreatedAt,CompletedDate,Work,Other,Critical,HighPriority,MediumPriority,LowPriority,"
        
        csvString += "Seconds,TargetDate,DateString,Day,Month,URL,X,Y,Radius\n"
        
        for dto in dtos {
            var baseFields = ""
            
            switch dto {
            case let timerDTO as TimerNotificationDTO:
                baseFields = "Timer,\(timerDTO.id),\(timerDTO.title),\(timerDTO.subtitle ?? ""),\(timerDTO.date),\(timerDTO.completedDate ?? Date.distantPast),"
                baseFields += "\(timerDTO.work ?? ""),\(timerDTO.other ?? ""),\(timerDTO.critical ?? ""),\(timerDTO.highPriority ?? ""),\(timerDTO.mediumPriority ?? ""),\(timerDTO.lowPriority ?? ""),"
                baseFields += "\(timerDTO.seconds),,,,,,,,"
                
            case let dateDTO as DateNotificationDTO:
                let components = formatDateComponents(from: dateDTO.targetDate)
                baseFields = "Date,\(dateDTO.id),\(dateDTO.title),\(dateDTO.subtitle ?? ""),\(dateDTO.date),\(dateDTO.completedDate ?? Date.distantPast),"
                baseFields += "\(dateDTO.work ?? ""),\(dateDTO.other ?? ""),\(dateDTO.critical ?? ""),\(dateDTO.highPriority ?? ""),\(dateDTO.mediumPriority ?? ""),\(dateDTO.lowPriority ?? ""),"
                baseFields += ",\(dateDTO.targetDate),\(components.full),\(components.day),\(components.month),,,,"
                
            case let locationDTO as LocationNotificationDTO:
                baseFields = "Location,\(locationDTO.id),\(locationDTO.title),\(locationDTO.subtitle ?? ""),\(locationDTO.date),\(locationDTO.completedDate ?? Date.distantPast),"
                baseFields += "\(locationDTO.work ?? ""),\(locationDTO.other ?? ""),\(locationDTO.critical ?? ""),\(locationDTO.highPriority ?? ""),\(locationDTO.mediumPriority ?? ""),\(locationDTO.lowPriority ?? ""),"
                baseFields += ",,,,,\(locationDTO.url ?? ""),\(locationDTO.x),\(locationDTO.y),\(locationDTO.radius)"
                
            default:
                continue
            }
            
            let escapedFields = baseFields
                .replacingOccurrences(of: "\"", with: "\"\"")
                .replacingOccurrences(of: "\n", with: " ")
            
            csvString += escapedFields + "\n"
        }
        
        let fileName = "notifications_export_\(Date().timeIntervalSince1970).csv"
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
        
        do {
            try csvString.write(to: path, atomically: true, encoding: .utf8)
            return path
        } catch {
            print("Failed to export CSV: \(error)")
            return nil
        }
    }
    
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
}
