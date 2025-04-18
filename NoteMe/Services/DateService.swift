import Foundation

protocol DateServiceProtocol {
    func saveSelectedDate(_ date: DateValue)
    func getSelectedDate() -> DateValue
}

final class DateService: DateServiceProtocol {
    
    private var storedDate = DateValue(month: "", day: 0, year: 0)
    
    func saveSelectedDate(_ date: DateValue) {
        storedDate = date
    }
    
    func getSelectedDate() -> DateValue {
        return storedDate
    }
}
