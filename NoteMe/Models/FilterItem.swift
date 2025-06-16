import UIKit

enum FilterItem: String, CaseIterable {
    case all = "Все"
    case active = "Активные"
    case completed = "Завершенные"
    case date = "Дата"
    case location = "Локация"
    case timer = "Таймер"
    case work = "Работа"
    case other = "Другое"
    case critical = "Критичный"
    case high = "Высокий"
    case medium = "Средний"
    case low = "Низкий"
}
