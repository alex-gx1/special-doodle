import UIKit

protocol CalendarPickerRouterProtocol {
    func dismiss()
}

final class CalendarPickerViewModel: CalendarPickerViewModelProtocol {
    
    private let router: CalendarPickerRouterProtocol
    private let dateService: DateServiceProtocol
    
    var month: String = ""
    var day: Int = 1
    var year: Int = 2000
    var onDateUpdated: ((String) -> Void)?
     
    init(router: CalendarPickerRouterProtocol, dateService: DateServiceProtocol) {
        self.router = router
        self.dateService = dateService
    }
    
    func dismiss() {
        router.dismiss()
    }
    
    func didTapDone() {
        let selectedDate = dateService.getSelectedDate()
        let formatted = "\(selectedDate.month) \(selectedDate.day), \(selectedDate.year)"
        onDateUpdated?(formatted)
        router.dismiss()
    }

    func updateDate(month: String, day: Int, year: Int) {
        self.month = month
        self.day = day
        self.year = year
        let newDate = DateValue(month: month, day: day, year: year)
        dateService.saveSelectedDate(newDate)

        let formatted = "\(month) \(day), \(year)"
        onDateUpdated?(formatted)
    }

}
