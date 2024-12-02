//
//  Register.swift
//  NoteMe
//
//  Created by LifeTech on 2.12.24.
//

import Foundation
import UIKit
import SnapKit

class Register: UIViewController {
    
    private lazy var logoImg: UIImageView =  {
        let view = UIImageView()
        view.image = UIImage(named: "Image" )
        return view
    }()
    
    private lazy var textWelcomeBack: UILabel = {
        let view = UILabel()
        view.text = "Nice to meet you!"
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
            return AppTextField(title: "E-mail", placeholder: "Enter E-mail")
        }()
        
        private lazy var passwordField: AppTextField = {
            return AppTextField(title: "Password", placeholder: "Enter Password", isSecure: true)
        }()
        
        private lazy var repeatPassword: AppTextField = {
            return AppTextField(title: "Repeat Password", placeholder: "Enter Password", isSecure: true)
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
        button.setTitle("Register", for: .normal)
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
        
        let attributedText = NSAttributedString(string: "I have an Account", attributes: attributes)
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
            make.top.equalTo(logoImg.snp.bottom).offset(72)
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
            make.top.equalTo(emailField.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(16)
        }
        
        view.addSubview(bottomCard)
        bottomCard.snp.makeConstraints {make in
            make.top.equalTo(cardView.snp.bottom).offset(206)
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
