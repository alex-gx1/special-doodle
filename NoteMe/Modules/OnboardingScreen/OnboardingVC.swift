import UIKit
import SnapKit
import Foundation

protocol OnboardingViewModelProtocol {
    
    func viewDidAppear()
    
    func openOnboardingSecondModule()
}

final class OnboardingVC: UIViewController, OnboardingScreens {
    
    private let viewModel: OnboardingViewModelProtocol
    
    init(viewModel: OnboardingViewModelProtocol){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    private lazy var textWelcome: UILabel = {
        let view = UILabel()
        view.text = "Welcome!"
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
        view.text = "NoteMe is an application, which notify you about everything!"
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.font = .appFont13
        return view
    } ()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.backgroundColor = Colors.appYellowColor
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = .appBoldFont17
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
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
        
        globalCardView.addSubview(textWelcome)
        
        textWelcome.snp.makeConstraints {make in
            make.top.equalTo(logoImg.snp.bottom).offset(72)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(97)
        }
        
        globalCardView.addSubview(cardView)
        
        cardView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(textWelcome.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(64)
        }
        
        cardView.addSubview(textInCardView)
        
        textInCardView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        globalCardView.addSubview(nextButton)
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(cardView.snp.bottom).offset(330)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(45)
        }
        
    }
    
    @objc private func nextButtonTapped(sender: Any) {
        viewModel.openOnboardingSecondModule()
    }
    
}
