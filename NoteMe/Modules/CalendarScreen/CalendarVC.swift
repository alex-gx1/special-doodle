import UIKit
import SnapKit

protocol CalendarViewModelProtocol {
    func openCalendarKeyboard()
    var dateString: Observable<String> { get }
    func closeVC ()
}

final class CalendarVC: UIViewController {
    
    private let viewModel: CalendarViewModelProtocol
    
    init(viewModel: CalendarViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.dateString.bind { [weak self] newDate in
            self?.dateTextField.text = newDate
        }
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
        label.text = "Create Date Notification"
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
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date"
        label.font = UIFont.appBoldFont15
        label.textColor = Colors.appBlackColor
        return label
    }()
    
    private lazy var dateTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter your Date"
        tf.borderStyle = .none
        tf.font = UIFont.appFont15
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.isUserInteractionEnabled = false
        return tf
    }()
    
    private lazy var dateWrapperView: UIView = {
        let view = UIView()
        view.addSubview(dateTextField)
        dateTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dateTextFieldTapped))
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    @objc func dateTextFieldTapped() {
        viewModel.openCalendarKeyboard()
    }
    
    private lazy var dateSeparator: UIView = {
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
        globalCardView.addSubview(middleCardView)
        globalCardView.addSubview(topLabel)
        
        middleCardView.addSubview(titleLabel)
        middleCardView.addSubview(titleTextField)
        middleCardView.addSubview(titleSeparator)
        
        middleCardView.addSubview(dateLabel)
        middleCardView.addSubview(dateWrapperView)
        middleCardView.addSubview(dateSeparator)
        
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
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(16)
        }
        
        dateWrapperView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(20)
        }
        
        dateSeparator.snp.makeConstraints { make in
            make.top.equalTo(dateWrapperView.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(0.5)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(dateWrapperView.snp.bottom).offset(16)
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
        viewModel.closeVC ()
        print("createButtonTap")
    }
    
    @objc func cancelButtonTap() {
        viewModel.closeVC ()
        print("createButtonTap")
    }
}
