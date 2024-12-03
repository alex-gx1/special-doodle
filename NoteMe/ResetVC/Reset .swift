import Foundation
import UIKit
import SnapKit

final class ResetVC: UIViewController {
    private lazy var logoImg: UIImageView =  {
        let view = UIImageView()
        view.image = Images.logo
        return view
    }()
    
    private lazy var textWelcomeBack: UILabel = {
        let view = UILabel()
        view.text = "Reset Password"
        view.textAlignment = .center
        view.font = UIFont.appBoldFont25
        return view
    }()
    
    //middle card and elements
    private lazy var cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        return view
    }()
        
    private lazy var emailField: AppTextField = {
        return AppTextField(title: "We will send you a reset password link.", placeholder:"Enter E-mail")
    }()
        
    //bottom card and elements
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        
        button.layer.cornerRadius = 5
        button.backgroundColor = Colors.appYellowColor
        button.setTitleColor(Colors.appBlackColor, for: .normal)
        button.setTitle("Reset", for: .normal)
        button.titleLabel?.font = UIFont.appBoldFont17
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.layer.borderColor = Colors.appYellowColor?.cgColor
        button.layer.borderWidth = 2.5
        button.backgroundColor = Colors.appBlackColor
        button.setTitleColor(Colors.appYellowColor, for: .normal)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.appBoldFont17
        return button
    }()

    //white card
    private lazy var globalCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
        
        globalCardView.addSubview(textWelcomeBack)
        
        textWelcomeBack.snp.makeConstraints { make in
            make.top.equalTo(logoImg.snp.bottom).offset(122)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(97)
            make.height.equalTo(29)
        }
        
        //контейнер-карточка
        globalCardView.addSubview(cardView)
        
        cardView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(textWelcomeBack.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(87)
        }
        
        //элементы внутри карточки
        cardView.addSubview(emailField)
        
        emailField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        globalCardView.addSubview(loginButton)
        globalCardView.addSubview(cancelButton)
        
        loginButton.snp.makeConstraints{ make in
            make.top.equalTo(cardView.snp.bottom).offset(200)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(45)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(45)
        }
    }
}
