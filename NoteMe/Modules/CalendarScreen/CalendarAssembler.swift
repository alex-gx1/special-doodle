import UIKit

final class CalendarAssembler {
    private init() {}
    
    static func make() -> UIViewController {
        let router = CalendarRouter()
        let dateService = DateService()
        let vm = CalendarViewModel(
            router: router,
            dateService: dateService
        )
        let vc = CalendarVC(viewModel: vm)
        router.root = vc
        return vc
    }
}
