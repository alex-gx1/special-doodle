import Foundation
import Storage
import UserNotifications

final class NotificationHandler {
    private let timerNotificationStorage = TimerNotificationStorage()
    private let dateNotificationStorage = DateNotificationStorage()
    private let notificationCenter = UNUserNotificationCenter.current()
    
    func checkAllNotifications() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.checkAndScheduleTimerNotifications()
            self?.checkAndScheduleDateNotifications()
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
        
        // Разница между текущей датой и targetDate
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
        
        // Можно добавить разные триггеры (например, за 1 день и за 1 час до targetDate)
        let triggers = [
            UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false),
            // За 1 час до дедлайна
            UNTimeIntervalNotificationTrigger(
                timeInterval: max(0, timeInterval - 3600),
                repeats: false
            )
        ]
        
        for (index, trigger) in triggers.enumerated() {
            let request = UNNotificationRequest(
                identifier: "date-\(task.id)-\(index)",
                content: content,
                trigger: trigger
            )
            
            notificationCenter.add(request) { error in
                if let error = error {
                    print("❌ Ошибка уведомления для \(task.id): \(error.localizedDescription)")
                } else {
                    print("✅ Уведомление для \(task.id) запланировано на \(trigger.nextTriggerDate()?.description ?? "nil")")
                }
            }
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
