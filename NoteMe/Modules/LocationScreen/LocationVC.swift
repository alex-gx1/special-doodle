import UIKit
import SnapKit

protocol LocationViewModelProtocol {
    func closeVC()
}

final class LocationVC: UIViewController {
    
    private let viewModel: LocationViewModelProtocol
    
    init(viewModel: LocationViewModelProtocol) {
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
        label.text = "Create Location Notification"
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont.appBoldFont15
        label.textColor = Colors.appBlackColor
        return label
    }()
    
    private lazy var titleTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter your Title"
        tf.borderStyle = .none
        tf.font = UIFont.appFont15
        tf.keyboardType = .default
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        return tf
    }()
    
    private lazy var titleSeparator: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor.separator
        return separator
    }()
    
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
        view.backgroundColor = Colors.appBlackColor
        view.addSubview(globalCardView)
        globalCardView.addSubview(topLabel)
        globalCardView.addSubview(middleCardView)
        
        middleCardView.addSubview(titleTextField)
        middleCardView.addSubview(titleSeparator)
        middleCardView.addSubview(titleLabel)
        middleCardView.addSubview(textView)
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
            make.height.equalTo(360)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(20)
        }
        
        titleSeparator.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(0.5)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleSeparator.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
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
        viewModel.closeVC()
    }
    
    @objc func cancelButtonTap() {
        print("createButtonTap")
        viewModel.closeVC()
    }
}
