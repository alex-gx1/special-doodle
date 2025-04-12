import UIKit

protocol TimerPickerRouterProtocol {
    func dismiss()
}

final class TimerPickerViewModel: TimerPickerViewModelProtocol {
    private let router: TimerPickerRouterProtocol
    private let timerService: TimerServiceProtocol
    var onTimeUpdated: ((String) -> Void)?
    
    var hours: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0
    
    init(router: TimerPickerRouterProtocol, timerService: TimerServiceProtocol, onTimeUpdated: ((String) -> Void)? = nil) {
        self.router = router
        self.timerService = timerService
        self.onTimeUpdated = onTimeUpdated
    }
    
    func didTapCancel() {
        router.dismiss()
    }
    
    func didTapDone() {
        let selectedTime = timerService.getSelectedTime()
        let timeString = String(format: "%02dh %02dm %02ds", selectedTime.hours, selectedTime.minutes, selectedTime.seconds)
        
        onTimeUpdated?(timeString)
        
        router.dismiss()
    }
    
    func updateTime(hours: Int, minutes: Int, seconds: Int) {
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
        
        let newTime = TimerValue(hours: hours, minutes: minutes, seconds: seconds)
        timerService.saveSelectedTime(newTime)
        
        let timeString = String(format: "%02dh %02dm %02ds", hours, minutes, seconds)
        onTimeUpdated?(timeString)
    }
}

