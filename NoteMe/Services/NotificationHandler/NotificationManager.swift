import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()
    private let handler = NotificationHandler()
    private var observers = [NSObjectProtocol]()
    
    private init() {
        setupObservers()
    }
    
    private func setupObservers() {
        let center = NotificationCenter.default
        let observer = center.addObserver(
            forName: .taskDidChange,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self = self else { return }
            
            if let type = notification.userInfo?["type"] as? String {
                if type == "date" {
                    self.handler.checkAndScheduleDateNotifications()
                } else if type == "timer" {
                    self.handler.checkAndScheduleTimerNotifications()
                }
            } else {
                self.handler.checkAllNotifications()
            }
        }
        observers.append(observer)
    }
    
    func checkNotificationsImmediately() {
        handler.checkAllNotifications()
    }
}

extension Notification.Name {
    static let taskDidChange = Notification.Name("TaskDidChangeNotification")
}
