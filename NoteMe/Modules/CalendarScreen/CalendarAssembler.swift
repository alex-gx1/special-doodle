import UIKit

final class CalendarAssembler {
    private init() {}
    
    static func make() -> UIViewController {
        let router = CalendarRouter()
        let vm = CalendarViewModel(
            router: router
        )
        let vc = CalendarVC(viewModel: vm)
        router.root = vc
        return vc
    }
}
