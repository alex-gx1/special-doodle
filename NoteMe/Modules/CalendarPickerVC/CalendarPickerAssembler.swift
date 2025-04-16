import UIKit

final class CalendarPickerAssembler {
    private init() {}
    
    static func make(dateService: DateServiceProtocol, onDateUpdated: ((String) -> Void)? = nil) -> UIViewController {
        let router = CalendarPickerRouter()
        let viewModel = CalendarPickerViewModel(router: router, dateService: dateService)
        viewModel.onDateUpdated = onDateUpdated
        let vc = CalendarPickerVC(viewModel: viewModel)
        router.root = vc
        return vc
    }

}

