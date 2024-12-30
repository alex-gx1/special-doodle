import UIKit
import SnapKit

protocol OnboardingSecondViewModelProtocol {
    func openMainScreenModule()
}

final class OnboardingSecondVC: UIViewController {
    
    private let viewModel: OnboardingSecondViewModelProtocol
    
    init(viewModel: OnboardingSecondViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private lazy var globalCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var logoImg: UIImageView =  {
        let view = UIImageView()
        view.image = Images.logo
        return view
    }()
    
    private lazy var textDifTypes: UILabel = {
        let view = UILabel()
        view.text = "Different types!"
        view.textAlignment = .center
        view.font = .appBoldFont25
        return view
    }()
    
    
    //middle card and elements
    private lazy var cardView: UIView = {
        let view = UIView()
        view.applyCardStyleShadow()
        view.applyCardStyleCorner()
        view.applyCardStyleBackgroundColor()
        return view
    }()
    
    private lazy var textInCardView: UILabel = {
        let view = UILabel()
        view.text = """
        NoteMe is an application, which notify you about everything!
        
        You can use 3 types of notifications:
        • Calendar - choose the date, when you want to receive notification.
        • Location - choose the region and notification will come after you enter it.
        • Timer - set timer and after selected period you will receive the notification.
        """
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.font = .appFont13
        return view
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(Images.plusButton, for: .normal)
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.backgroundColor = Colors.appYellowColor
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = .appBoldFont17
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var popUpView: PopUpView = {
        let popUpView = PopUpView()
        popUpView.alpha = 0
        popUpView.onCalendarTap = { [weak self] in
            self?.handleCalendarTap()
        }
        popUpView.onLocationTap = { [weak self] in
            self?.handleLocationTap()
        }
        popUpView.onTimerTap = { [weak self] in
            self?.handleTimerTap()
        }
        return popUpView
    }()
    
    private func handleCalendarTap() {
        print("Calendar tapped")
        hidePopupView()
    }

    private func handleLocationTap() {
        print("Location tapped")
        hidePopupView()
    }

    private func handleTimerTap() {
        print("Timer tapped")
        hidePopupView()
    }

    private func hidePopupView() {
        UIView.animate(withDuration: 0.3) {
            self.popUpView.alpha = 0
        }
    }

    
    private func setupUI() {
        view.backgroundColor = Colors.appBlackColor
        view.addSubview(globalCardView)
        
        globalCardView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(60)
            make.horizontalEdges.equalToSuperview().inset(0)
            make.bottom.equalToSuperview().inset(60)
        }
        
        globalCardView.addSubview(logoImg)
        
        logoImg.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(72)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 96, height: 96))
        }
        
        globalCardView.addSubview(textDifTypes)
        
        textDifTypes.snp.makeConstraints {make in
            make.top.equalTo(logoImg.snp.bottom).offset(72)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(97)
        }
        
        globalCardView.addSubview(cardView)
        
        cardView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(textDifTypes.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(174)
        }
        
        cardView.addSubview(textInCardView)
        
        textInCardView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        globalCardView.addSubview(plusButton)
        
        plusButton.snp.makeConstraints{ make in
            make.top.equalTo(cardView.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(162)
        }
        
        globalCardView.addSubview(popUpView)
        
        popUpView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        globalCardView.addSubview(doneButton)
        
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(plusButton.snp.bottom).offset(50)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(45)
        }
        
    }
    
    @objc private func doneButtonTapped(sender: Any) {
        viewModel.openMainScreenModule()
    }
    
    @objc private func plusButtonTapped(sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.popUpView.alpha = 1
        }
    }
}
