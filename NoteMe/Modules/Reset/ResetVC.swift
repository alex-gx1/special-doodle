import Foundation
import UIKit
import SnapKit


protocol ResetViewModelProtocol: AnyObject {
    func reset(email: String)
    var shouldShowAlert: Closure<String>? {get set}
    
    //navigation
    func back()
}

final class ResetVC: UIViewController, AuthScreen {
    private let viewModel: ResetViewModelProtocol
    
    
    private lazy var logoImg: UIImageView =  {
        let view = UIImageView()
        view.image = Images.logo
        return view
    }()
    
    private lazy var textWelcomeBack: UILabel = {
        let view = UILabel()
        view.text = "Смена пароля"
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
        return AppTextField(title: "Мы отправим вам ссылку для сброса пароля.", placeholder:"Введите E-mail")
    }()
    
    //bottom card and elements
    private lazy var resetButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.backgroundColor = Colors.appYellowColor
        button.setTitleColor(Colors.appBlackColor, for: .normal)
        button.setTitle("Сбросить", for: .normal)
        button.titleLabel?.font = UIFont.appBoldFont17
        button.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.layer.borderColor = Colors.appYellowColor?.cgColor
        button.layer.borderWidth = 2.5
        button.backgroundColor = Colors.appBlackColor
        button.setTitleColor(Colors.appYellowColor, for: .normal)
        button.setTitle("Отмена", for: .normal)
        button.titleLabel?.font = UIFont.appBoldFont17
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //white card
    private lazy var globalCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    init(viewModel: ResetViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        keyBoardDownTap()
    }
    
    private func bind(){
        viewModel.shouldShowAlert = { [weak self] message in
            self?.showAlert(title: "Ошибка", message: message)
        }
    }
    
    private func keyBoardDownTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    private func setupUI() {
        view.backgroundColor = Colors.appBlackColor
        
        view.addSubview(globalCardView)
        
        globalCardView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
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
        
        globalCardView.addSubview(resetButton)
        globalCardView.addSubview(cancelButton)
        
        resetButton.snp.makeConstraints{ make in
            make.bottom.equalTo(cancelButton.snp.top).offset(-8)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(45)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(45)
        }
    }
    
    @objc private func resetButtonTapped() {
        guard
            let email = emailField.text
        else { return }
        
        viewModel.reset(email: email)
    }
    
    @objc private func cancelButtonTapped() {
        viewModel.back()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
