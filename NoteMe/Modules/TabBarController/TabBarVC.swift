import UIKit
import SnapKit

final class TabBarVC: UITabBarController {
    
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(Images.plusButton, for: .normal)
        return button
    }()
    
    private let action1 = UIAction(
        title: "Timer",
        image: Images.timerButton) { _ in
            print("Action 1 tapped")
        }
    
    private let action2 = UIAction(
        title: "Location",
        image: Images.locationButton) { _ in
            print("Action 2 tapped")
        }
    
    private let action3 = UIAction(
        title: "Calendar",
        image: Images.calendarButton) { _ in
            print("Action 3 tapped")
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        let menu = UIMenu(children: [action1, action2, action3])
        
        plusButton.menu = menu
        plusButton.showsMenuAsPrimaryAction = true
    }
    
    
    private func setupUI() {
        
        tabBar.tintColor = Colors.appYellowColor
        tabBar.unselectedItemTintColor = Colors.appTabBarIconsColor
        
        view.addSubview(plusButton) // добавил кнопку на view
        
        plusButton.layer.zPosition = 1 // сделал кнопку на слой выше элементов tabbar
        view.bringSubviewToFront(plusButton) // на всякий вывел кнопку выше дополнительно
        
        plusButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(tabBar.snp.top).offset(30)
            make.width.height.equalTo(50)
        }
        
    }
}

