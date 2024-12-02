
import Foundation
import UIKit
import SnapKit

class Reset: UIViewController {
    
    private lazy var logoImg: UIImageView =  {
        let view = UIImageView()
        view.image = UIImage(named: "Image" )
        return view
    }()
    
    private lazy var textWelcomeBack: UILabel = {
        let view = UILabel()
        view.text = "Reset Password"
        view.textAlignment = .center
        view.font = UIFont.boldSystemFont(ofSize: 25)
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
            return AppTextField(title: "We will send you a reset password link.", placeholder: "Enter E-mail")
        }()
        
    
    //bottom card and elements
    private lazy var bottomCard: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1.0)
        view.layer.cornerRadius = 5
        return view
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        
        button.layer.cornerRadius = 5
        button.backgroundColor = .yellow
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Reset", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        return button
    }()


    private lazy var newAccountLabel: UILabel = {
        let label = UILabel()
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.yellow,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .font: UIFont.boldSystemFont(ofSize: 17)
        ]
        
        let attributedText = NSAttributedString(string: "Cancel", attributes: attributes)
        label.attributedText = attributedText
        return label
    }()



    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    
    private func setupUI() {
        view.addSubview(logoImg)
        
        logoImg.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(116)
            make.centerX.equalToSuperview()
            make.height.equalTo(96)
            make.width.equalTo(96)
        }
        
        view.addSubview(textWelcomeBack)
        
        textWelcomeBack.snp.makeConstraints {make in
            make.top.equalTo(logoImg.snp.bottom).offset(122)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(97)
            make.height.equalTo(29)
        }
        
        //контейнер-карточка
        view.addSubview(cardView)
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
        
            
        view.addSubview(bottomCard)
        bottomCard.snp.makeConstraints {make in
            make.bottom.equalToSuperview().offset(-28)
            make.height.equalTo(73)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        bottomCard.addSubview(loginButton)
        bottomCard.addSubview(newAccountLabel)
        
        loginButton.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(0)
            make.height.equalTo(45)
            
        }
        
        newAccountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(loginButton.snp.bottom).offset(8)
        }
        
    }
}
