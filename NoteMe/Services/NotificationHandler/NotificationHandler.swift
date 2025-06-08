import Foundation
import Storage
import UserNotifications
import CoreLocation

final class NotificationHandler {
    private let timerNotificationStorage = TimerNotificationStorage()
    private let dateNotificationStorage = DateNotificationStorage()
    private let notificationCenter = UNUserNotificationCenter.current()
    
    func checkAllNotifications() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.checkAndScheduleTimerNotifications()
            self?.checkAndScheduleDateNotifications()
            self?.checkAndScheduleLocationNotifications()
        }
    }
    
    func checkAndScheduleLocationNotifications() {
        let predicate = NSPredicate(format: "completedDate == nil")
        let locationTasks = LocationNotificationStorage().fetch(predicate: predicate)
        print("Найдено активных location-задач: \(locationTasks.count)")
        
        for task in locationTasks {
            scheduleLocationNotification(for: task)
        }
    }
    
    private func scheduleLocationNotification(for task: LocationNotificationDTO) {
        guard task.completedDate == nil else {
            print("Location-задача \(task.id) уже завершена")
            return
        }
        
        let center = CLLocationCoordinate2D(latitude: task.x, longitude: task.y)
        let region = CLCircularRegion(
            center: center,
            radius: task.radius,
            identifier: task.id
        )
        region.notifyOnEntry = true
        region.notifyOnExit = false
        
        let content = UNMutableNotificationContent()
        content.title = task.title
        content.body = task.subtitle ?? "Вы вошли в заданную область"
        content.sound = .default
        
        let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "location-\(task.id)",
            content: content,
            trigger: trigger
        )
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("❌ Ошибка location-уведомления для \(task.id): \(error.localizedDescription)")
            } else {
                print("✅ Location-уведомление для \(task.id) запланировано")
            }
        }
    }
    
    func checkAndScheduleDateNotifications() {
        let now = Date()
        let predicate = NSPredicate(format: "completedDate == nil AND targetDate > %@", now as NSDate)
        
        let dateTasks = dateNotificationStorage.fetch(predicate: predicate)
        print("Найдено активных дата-задач: \(dateTasks.count)")
        
        for task in dateTasks {
            scheduleDateNotification(for: task)
        }
    }
    
    private func scheduleDateNotification(for task: DateNotificationDTO) {
        guard task.completedDate == nil else {
            print("Дата-задача \(task.id) уже завершена")
            return
        }
        
        let timeInterval = task.targetDate.timeIntervalSinceNow
        
        guard timeInterval > 0 else {
            print("Дата для задачи \(task.id) уже прошла")
            return
        }
        
        print("⏳ Планируем уведомление для дата-задачи \(task.id) через \(timeInterval) сек")
        
        let content = UNMutableNotificationContent()
        content.title = task.title
        content.body = task.subtitle ?? "Срок выполнения задачи приближается"
        content.sound = .default
        
        let mainTrigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let mainRequest = UNNotificationRequest(
            identifier: "date-\(task.id)-main",
            content: content,
            trigger: mainTrigger
        )
        
        notificationCenter.add(mainRequest) { error in
            if let error = error {
                print("❌ Ошибка основного уведомления для \(task.id): \(error.localizedDescription)")
            } else {
                print("✅ Основное уведомление для \(task.id) запланировано на \(mainTrigger.nextTriggerDate()?.description ?? "nil")")
            }
        }
        
        if timeInterval > 3600 {
            let reminderTrigger = UNTimeIntervalNotificationTrigger(
                timeInterval: timeInterval - 3600,
                repeats: false
            )
            let reminderRequest = UNNotificationRequest(
                identifier: "date-\(task.id)-reminder",
                content: content,
                trigger: reminderTrigger
            )
            
            notificationCenter.add(reminderRequest) { error in
                if let error = error {
                    print("❌ Ошибка напоминания для \(task.id): \(error.localizedDescription)")
                } else {
                    print("✅ Напоминание для \(task.id) запланировано на \(reminderTrigger.nextTriggerDate()?.description ?? "nil")")
                }
            }
        } else {
            print("⚠️ До события \(task.id) осталось меньше часа, напоминание не создано")
        }
    }
    
    func checkAndScheduleTimerNotifications() {
        let predicate = NSPredicate(format: "completedDate == nil AND date != nil AND seconds > 0")
        
        let timerTasks = timerNotificationStorage.fetch(predicate: predicate)
        print("Найдено активных задач: \(timerTasks.count)")
        
        for task in timerTasks {
            print("Обрабатываем задачу: \(task.id)")
            scheduleTimerNotification(for: task)
        }
    }
    
    private func scheduleTimerNotification(for task: TimerNotificationDTO) {
        let elapsed = Date().timeIntervalSince(task.date)
        let remaining = max(0, task.seconds - elapsed)
        
        guard remaining > 0 else {
            print("⏰ Задача \(task.id) уже истекла")
            return
        }
        
        print("🔔 Планируем уведомление для \(task.id) через \(remaining) сек")
        
        let content = UNMutableNotificationContent()
        content.title = task.title
        content.body = task.subtitle ?? "Таймер завершен"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: remaining,
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: "timer-\(task.id)",
            content: content,
            trigger: trigger
        )
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: ["timer-\(task.id)"])
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("❌ Ошибка для \(task.id): \(error.localizedDescription)")
            } else {
                print("✅ Успешно: уведомление для \(task.id) через \(remaining) сек")
            }
        }
    }
}

extension Notification.Name {
    static let taskCreatedNotification = Notification.Name("TaskCreatedNotification")
}
