import UIKit


final class MenuPopOverRouter: MenuPopOverRouterProtocol {
    weak var root: UIViewController?
    
    func openTimerScreen() {
        print("LocationScreen")
    }

    
    func openLocationScreen() {
        print("LocationScreen")
    }
    
    func openCalenderScreen() {
        print("CalendarScreen")
    }
}
