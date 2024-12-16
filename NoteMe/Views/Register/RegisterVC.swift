import Foundation
import UIKit
import SnapKit
import FirebaseAuth
import Firebase

final class RegisterVC: UIViewController {
    
    private let viewModel = RegisterViewModel()
    
    private lazy var logoImg: UIImageView =  {
        let view = UIImageView()
        view.image = Images.logo
        return view
    }()
    
    private lazy var textWelcomeBack: UILabel = {
        let view = UILabel()
        view.text = "Nice to meet you!"
        view.textAlignment = .center
        view.font = UIFont.appBoldFont25
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
    
    private lazy var emailField: AppTextField = {
        return AppTextField(title: "E-mail", placeholder: "Enter E-mail")
    }()    
    
    private lazy var passwordField: AppTextField = {
        return AppTextField(title: "Password", placeholder: "Enter Password", isSecure: true)
    }()
    
    private lazy var repeatPassword: AppTextField = {
        return AppTextField(title: "Repeat Password", placeholder: "Enter Password",isSecure: true)
    }()
    
    //bottom card and elements
    private lazy var bottomCard: UIView = {
        let view = UIView()
        view.applyBottomCardStyleCorner()
        view.applyBottomCardStyleBackgroundColor()
        return view
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.backgroundColor = Colors.appYellowColor
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = UIFont.appBoldFont17
        button.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var haveAccountButton: UIButton = {
        let button = UIButton()
        let title = "I have an Account"
        let attributedString = NSAttributedString(
            string: title,
            attributes: [
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: Colors.appYellowColor!
            ]
        )
        button.setAttributedTitle(attributedString, for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = Colors.appBlackColor
        button.titleLabel?.font = .appBoldFont17
        return button
    }()
    
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
            make.top.equalToSuperview().offset(72)
            make.centerX.equalToSuperview()
            make.height.equalTo(96)
            make.width.equalTo(96)
        }
        
        globalCardView.addSubview(textWelcomeBack)
        
        textWelcomeBack.snp.makeConstraints {make in
            make.top.equalTo(logoImg.snp.bottom).offset(72)
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
            make.height.equalTo(188)
        }
        
        //элементы внутри карточки
        cardView.addSubview(emailField)
        cardView.addSubview(passwordField)
        cardView.addSubview(repeatPassword)
        
        emailField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        repeatPassword.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(16)
        }
        
        globalCardView.addSubview(bottomCard)
        bottomCard.snp.makeConstraints { make in
            make.top.equalTo(cardView.snp.bottom).offset(160)
            make.height.equalTo(90)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        bottomCard.addSubview(registerButton)
        bottomCard.addSubview(haveAccountButton)
        
        registerButton.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(0)
            make.height.equalTo(45)
            
        }
        haveAccountButton.snp.makeConstraints{ make in
            make.horizontalEdges.equalToSuperview().inset(0)
            make.top.equalTo(registerButton.snp.bottom).offset(0)
            make.height.equalTo(45)
        }
    }
    
    @objc private func registerButtonTapped() {
        let email = emailField.text
        let password = passwordField.text
        let repeatPassword = repeatPassword.text
        
        guard viewModel.validateEmail(email) else {
            showAlert(title: "Error", message: "Invalid email format.")
            return
        }
        
        guard viewModel.validatePasswords(password: password, repeatPassword: repeatPassword) else {
            showAlert(title: "Error", message: "Passwords do not match.")
            return
        }
        
        guard viewModel.validatePasswordStrength(password) else {
            showAlert(title: "Error", message: "Password must be at least 8 characters long and include uppercase, lowercase, a number, and a special character.")
            return
        }
        
        viewModel.registerUser(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let successMessage):
                    self?.showAlert(title: "Success", message: successMessage)
                case .failure(let error):
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
