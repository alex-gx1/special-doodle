import Foundation

protocol TimerServiceProtocol {
    func saveSelectedTime(_ time: TimerValue)
    func getSelectedTime() -> TimerValue
}

final class TimerService: TimerServiceProtocol {
    
    private var storedTime = TimerValue(hours: 0, minutes: 0, seconds: 0)
    
    func saveSelectedTime(_ time: TimerValue) {
        storedTime = time
    }
    
    func getSelectedTime() -> TimerValue {
        return storedTime
    }
}
