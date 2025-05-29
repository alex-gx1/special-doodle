import UIKit
import SnapKit

protocol TabBarViewModelProtocol {
    func plusButtonTapped(from source: UIView, sourceRect: CGRect)
    func viewDidAppear()
}

final class TabBarVC: UITabBarController {
    
    private let viewModel: TabBarViewModelProtocol
    
    init(viewModel: TabBarViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(Images.plusButton, for: .normal)
        button.addTarget(self, action: #selector(PlusButtonTap), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewDidAppear()
    }
    
    private func provideHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        provideHapticFeedback()
    }
    
    private func setupUI() {
        
        tabBar.tintColor = Colors.appYellowColor
        tabBar.unselectedItemTintColor = Colors.appTabBarIconsColor
        
        view.addSubview(plusButton)
        
        plusButton.layer.zPosition = 1
        view.bringSubviewToFront(plusButton)
        
        plusButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(tabBar.snp.top).offset(30)
            make.width.height.equalTo(50)
        }
    }
    
    @objc private func PlusButtonTap(sender: UIButton) {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
        viewModel.plusButtonTapped(from: sender, sourceRect: sender.bounds)
    }
}

extension TabBarVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none // чтобы popover не превращался в fullscreen на iPhone
    }
}
