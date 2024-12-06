import Foundation
import UIKit
import SnapKit

class AppTextField: UIView {
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.textColor = .black
        textField.borderStyle = .none
        return textField
    }()
    
    // MARK: - Initializer
    init(title: String, placeholder: String, isSecure: Bool = false) {
        super.init(frame: .zero)
        setupUI(title: title, placeholder: placeholder, isSecure: isSecure)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // настройка ui Snapkit
    private func setupUI(title: String, placeholder: String, isSecure: Bool) {
        //заголовок
        titleLabel.text = title
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(15)
        }
        
        //ввод
        textField.placeholder = placeholder
        textField.isSecureTextEntry = isSecure
        textField.setPlaceholderColor(.lightGray)
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(17)
        }
        
        //разделитель
        addSubview(separator)
        separator.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}

private extension UITextField {
    func setPlaceholderColor(_ color: UIColor) {
        guard let placeholder = placeholder else { return }
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: color]
        )
    }
}

