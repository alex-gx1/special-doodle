import UIKit
import SnapKit
import FirebaseAuth

protocol LoginViewModelProtocol: AnyObject {
    var shouldShowAlert: Closure<String>? {get set}
    func login(email: String, password: String)
    
    //navigation
    func openResetModule()
    func openRegisterModule()
}

final class LoginVC: UIViewController {
    
    private let viewModel: LoginViewModelProtocol
    
    //logo img
    private lazy var logoImg: UIImageView =  {
        let view = UIImageView()
        view.image = Images.logo
        return view
    }()
    
    //label welcome back
    private lazy var textWelcomeBack: UILabel = {
        let view = UILabel()
        view.text = "Welcome back!"
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
    
    private lazy var emailField: AppTextField = {
        return AppTextField(title: "E-mail", placeholder: "Enter E-mail")
    }()
    
    private lazy var passwordField: AppTextField = {
        return AppTextField(title: "Password", placeholder: "Enter Password", isSecure: true)
    }()
    
    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.appBoldFont15,
            .foregroundColor: Colors.appGreyColor!,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributedTitle = NSAttributedString(string: "Forgot Password", attributes: attributes)
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(forgotTapped(sender:)), for: .touchUpInside)
        return button
    }()
    
    //bottom card and elements
    private lazy var bottomCard: UIView = {
        let view = UIView()
        view.applyBottomCardStyleCorner()
        view.applyBottomCardStyleBackgroundColor()
        return view
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.backgroundColor = Colors.appYellowColor
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = .appBoldFont17
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var newAccountButton: UIButton = {
        let button = UIButton()
        let title = "New Account"
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
        button.addTarget(self, action: #selector(newAccountTapped(sender:)), for: .touchUpInside)
        return button
    }()
    
    //white card
    private lazy var globalCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    init(viewModel: LoginViewModelProtocol) {
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
    
    private func bind(){
        viewModel.shouldShowAlert = { [weak self] message in
            self?.showAlert(title: "Error", message: message)
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
        
        globalCardView.addSubview(textWelcomeBack)
        
        textWelcomeBack.snp.makeConstraints {make in
            make.top.equalTo(logoImg.snp.bottom).offset(72)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(97)
        }
        
        //контейнер-карточка
        globalCardView.addSubview(cardView)
        
        cardView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(textWelcomeBack.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(165)
        }
        
        //элементы внутри карточки
        cardView.addSubview(emailField)
        cardView.addSubview(passwordField)
        cardView.addSubview(forgotPasswordButton)
        
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
        
        forgotPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(20)
            make.leading.equalTo(passwordField)
            make.height.equalTo(17)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        globalCardView.addSubview(bottomCard)
        
        bottomCard.snp.makeConstraints {make in
            make.top.equalTo(cardView.snp.bottom).offset(180)
            make.height.equalTo(90)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        bottomCard.addSubview(loginButton)
        bottomCard.addSubview(newAccountButton)
        
        loginButton.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(0)
            make.height.equalTo(45)
        }
        
        newAccountButton.snp.makeConstraints{ make in
            make.horizontalEdges.equalToSuperview().inset(0)
            make.top.equalTo(loginButton.snp.bottom).offset(0)
            make.height.equalTo(45)
        }
    }
    
    @objc private func newAccountTapped(sender: Any) {
        viewModel.openRegisterModule()
    }
    
    @objc private func forgotTapped(sender: Any) {
        viewModel.openResetModule()
    }
    
    @objc private func loginButtonTapped(sender: Any) {
        guard
            let email = emailField.text,
            let password = passwordField.text
        else { return }
        
        viewModel.login(email: email, password: password)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
