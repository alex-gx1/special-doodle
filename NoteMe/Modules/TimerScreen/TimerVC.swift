import UIKit
import SnapKit

protocol TimerViewModelProtocol {
    
}

final class TimerVC: UIViewController {
    
    private let viewModel: TimerViewModelProtocol
    
    init(viewModel: TimerViewModelProtocol) {
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
    
    private lazy var middleCardView: UIView = {
        let view = UIView()
        view.applyCardStyleShadow()
        view.applyCardStyleCorner()
        view.applyCardStyleBackgroundColor()
        return view
    }()
    
    private lazy var topLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.appBlackColor
        label.font = UIFont.appBoldFont17
        label.text = "Create Timer Notification"
        return label
    }()
    
    private func makeInputContainer(
        labelText: String,
        placeholder: String? = nil,
        keyboardType: UIKeyboardType = .default,
        customTextField: UITextField? = nil
    ) -> UIView {
        let container = UIView()

        let label = UILabel()
        label.text = labelText
        label.font = UIFont.appBoldFont15
        label.textColor = Colors.appBlackColor

        let textField = customTextField ?? {
            let tf = UITextField()
            tf.placeholder = placeholder
            tf.borderStyle = .none
            tf.font = UIFont.appFont15
            tf.keyboardType = keyboardType
            tf.autocorrectionType = .no
            tf.autocapitalizationType = .none
            return tf
        }()

        let separator = UIView()
        separator.backgroundColor = UIColor.separator

        container.addSubview(label)
        container.addSubview(textField)
        container.addSubview(separator)

        label.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }

        textField.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(4)
            make.left.right.equalToSuperview()
            make.height.equalTo(20)
        }

        separator.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(4)
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
        }

        return container
    }

    
    private lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.appBlackColor
        label.font = UIFont.appBoldFont15
        label.text = "Comment"
        return label
    }()

    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.textColor = Colors.appBlackColor
        textView.font = UIFont.appFont15
        textView.backgroundColor = .clear
        textView.layer.borderWidth = 1
        textView.layer.borderColor = Colors.appBlackColor.cgColor
        textView.layer.cornerRadius = 4
        return textView
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.backgroundColor = Colors.appYellowColor
        button.setTitleColor(Colors.appBlackColor, for: .normal)
        button.setTitle("Create", for: .normal)
        button.titleLabel?.font = UIFont.appBoldFont17
        button.setTitleColor(Colors.appBlackColor.withAlphaComponent(0.5), for: .highlighted)
        button.setBackgroundColor(Colors.appYellowColor?.withAlphaComponent(0.7), for: .highlighted)
        button.addTarget(self, action: #selector(createButtonTap), for: .touchUpInside)
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
        button.setTitleColor(Colors.appYellowColor?.withAlphaComponent(0.5), for: .highlighted)
        button.setBackgroundColor(Colors.appBlackColor.withAlphaComponent(0.7), for: .highlighted)
        button.addTarget(self, action: #selector(cancelButtonTap), for: .touchUpInside)
        return button
    }()
    
    private func setupUI() {
        
       let titleInput = makeInputContainer(
            labelText: "Title",
            placeholder: "Enter your Title",
            keyboardType: .default
        )
        
        let timerInput = makeInputContainer(
            labelText: "Timer",
            placeholder: "Enter your Time",
            keyboardType: .default
        )
        
        view.backgroundColor = Colors.appBlackColor
        view.addSubview(globalCardView)
        globalCardView.addSubview(middleCardView)
        globalCardView.addSubview(topLabel)
        middleCardView.addSubview(titleInput)
        middleCardView.addSubview(timerInput)
        middleCardView.addSubview(commentLabel)
        middleCardView.addSubview(textView)
        
        globalCardView.addSubview(createButton)
        globalCardView.addSubview(cancelButton)
        
        globalCardView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        topLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        
        middleCardView.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(250)
        }
        
        titleInput.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        timerInput.snp.makeConstraints { make in
            make.top.equalTo(titleInput.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(timerInput.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(16)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(commentLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(68)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(45)
        }
        
        createButton.snp.makeConstraints { make in
            make.bottom.equalTo(cancelButton.snp.top).offset(-8)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(45)
        }
    }
    
    @objc func createButtonTap() {
        print("createButtonTap")
    }
    @objc func cancelButtonTap() {
        print("cancelButtonTap")
    }
}

extension UIButton {
    func setBackgroundColor(_ color: UIColor?, for state: UIControl.State) {
        guard let color = color else { return }
        let image = UIImage(color: color)
        setBackgroundImage(image, for: state)
    }
}

extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        UIGraphicsBeginImageContext(size)
        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
