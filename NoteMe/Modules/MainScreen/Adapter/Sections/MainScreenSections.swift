import UIKit

enum NotificationModel {
    case timer(TimerTaskModel)
    case date(DateTaskModel)
    case location(LocationTaskModel)
}
