import UIKit
import SnapKit

final class TabBarVC: UITabBarController {
    
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(Images.plusButton, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        
        tabBar.tintColor = Colors.appYellowColor
        tabBar.unselectedItemTintColor = Colors.appTabBarIconsColor
        
        tabBar.addSubview(plusButton)
        
        plusButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-40)
            make.width.height.equalTo(50)
        }
        
    }
}
