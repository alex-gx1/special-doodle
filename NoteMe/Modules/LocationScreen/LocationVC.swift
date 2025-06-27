import UIKit
import SnapKit
import MapKit

protocol LocationViewModelProtocol {
    func closeVC()
    func askPermission()
    func openFullMap()
    var locationImage: Observable<UIImage?> { get }
    var x: Observable<Double> { get }
    var y: Observable<Double> { get }
    var radius: Observable<Double> { get }
    func showAlert(title: String, message: String?)
    func saveNotification(title: String, x: Double, y: Double, radius: Double , url: String, subtitle: String, category: String, priority: String)
    func saveImageToDocuments(_ image: UIImage, fileName: String) -> String?
}

final class LocationVC: UIViewController {
    
    private let viewModel: LocationViewModelProtocol
    private var selectedCategory: String = "Other"
    private var selectedPriority: String = "Medium"
    
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
        viewModel.askPermission()
        keyBoardDownTap()
        bindImage()
    }
    
    private func bindImage() {
        locationMapUIImage.image = Images.locationMap
        
        viewModel.locationImage.bind { [weak self] image in
            guard let image else { return }
            self?.locationMapUIImage.image = image
        }
    }
    
    private func keyBoardDownTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // MARK: - UI Components
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
        label.text = "Создание задачи с локацией"
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Название"
        label.font = UIFont.appBoldFont15
        label.textColor = Colors.appBlackColor
        return label
    }()
    
    private lazy var titleTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Введите название задачи"
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
        label.text = "Подзадача"
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
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.appBlackColor
        label.font = UIFont.appBoldFont15
        label.text = "Локация"
        return label
    }()
    
    private lazy var locationMapUIImage: UIImageView = {
        let mapView = UIImageView()
        mapView.image = Images.locationMap
        mapView.adjustsImageSizeForAccessibilityContentSizeCategory = true
        mapView.contentMode = .scaleAspectFit
        return mapView
    }()
    
    private lazy var mapTapView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleMapTap))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    // Category Section
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.font = UIFont.appBoldFont15
        label.textColor = Colors.appBlackColor
        return label
    }()
    
    private lazy var categoryStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 12
        return stack
    }()
    
    private lazy var otherButton: UIButton = {
        let button = UIButton()
        button.setTitle("Другое", for: .normal)
        button.titleLabel?.font = UIFont.appBoldFont15
        button.setTitleColor(Colors.appBlackColor, for: .normal)
        button.backgroundColor = Colors.appYellowColor
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var workButton: UIButton = {
        let button = UIButton()
        button.setTitle("Работа", for: .normal)
        button.titleLabel?.font = UIFont.appBoldFont15
        button.setTitleColor(Colors.appBlackColor, for: .normal)
        button.backgroundColor = Colors.appGreyColor
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    // Priority Section
    private lazy var priorityLabel: UILabel = {
        let label = UILabel()
        label.text = "Приоритет"
        label.font = UIFont.appBoldFont15
        label.textColor = Colors.appBlackColor
        return label
    }()
    
    private lazy var priorityStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()
    
    private lazy var criticalButton: UIButton = {
        let button = UIButton()
        button.setTitle("Критичный", for: .normal)
        button.titleLabel?.font = UIFont.appBoldFont13
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = Colors.appGreyColor
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(priorityButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var highPriorityButton: UIButton = {
        let button = UIButton()
        button.setTitle("Высокий", for: .normal)
        button.titleLabel?.font = UIFont.appBoldFont13
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = Colors.appGreyColor
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(priorityButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var mediumPriorityButton: UIButton = {
        let button = UIButton()
        button.setTitle("Средний", for: .normal)
        button.titleLabel?.font = UIFont.appBoldFont13
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = Colors.appYellowColor
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(priorityButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var lowPriorityButton: UIButton = {
        let button = UIButton()
        button.setTitle("Низкий", for: .normal)
        button.titleLabel?.font = UIFont.appBoldFont13
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = Colors.appGreyColor
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(priorityButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    // Action Buttons
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.backgroundColor = Colors.appYellowColor
        button.setTitleColor(Colors.appBlackColor, for: .normal)
        button.setTitle("Создать", for: .normal)
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
        button.setTitle("Отмена", for: .normal)
        button.titleLabel?.font = UIFont.appBoldFont17
        button.setTitleColor(Colors.appYellowColor?.withAlphaComponent(0.5), for: .highlighted)
        button.setBackgroundColor(Colors.appBlackColor.withAlphaComponent(0.7), for: .highlighted)
        button.addTarget(self, action: #selector(cancelButtonTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        view.backgroundColor = Colors.appBlackColor
        
        // Add subviews
        view.addSubview(globalCardView)
        globalCardView.addSubview(topLabel)
        globalCardView.addSubview(middleCardView)
        
        // Middle card content
        middleCardView.addSubview(titleLabel)
        middleCardView.addSubview(titleTextField)
        middleCardView.addSubview(titleSeparator)
        middleCardView.addSubview(commentLabel)
        middleCardView.addSubview(textView)
        middleCardView.addSubview(locationLabel)
        middleCardView.addSubview(locationMapUIImage)
        middleCardView.addSubview(mapTapView)
        
        // Category section
        middleCardView.addSubview(categoryLabel)
        categoryStackView.addArrangedSubview(otherButton)
        categoryStackView.addArrangedSubview(workButton)
        middleCardView.addSubview(categoryStackView)
        
        // Priority section
        middleCardView.addSubview(priorityLabel)
        priorityStackView.addArrangedSubview(criticalButton)
        priorityStackView.addArrangedSubview(highPriorityButton)
        priorityStackView.addArrangedSubview(mediumPriorityButton)
        priorityStackView.addArrangedSubview(lowPriorityButton)
        middleCardView.addSubview(priorityStackView)
        
        // Action buttons
        globalCardView.addSubview(createButton)
        globalCardView.addSubview(cancelButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        globalCardView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        topLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        
        middleCardView.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(500)
        }
        
        // Title section
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
        
        // Comment section
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleSeparator.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(commentLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(68)
        }
        
        // Location section
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        locationMapUIImage.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(120)
        }
        
        mapTapView.snp.makeConstraints { make in
            make.edges.equalTo(locationMapUIImage)
        }
        
        // Category section
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(locationMapUIImage.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(16)
        }
        
        categoryStackView.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        // Priority section
        priorityLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryStackView.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(16)
        }
        
        priorityStackView.snp.makeConstraints { make in
            make.top.equalTo(priorityLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(30)
        }
        
        // Action buttons
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
    
    // MARK: - Button Actions
    
    @objc private func createButtonTap() {
        let title = titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let subtitle = textView.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if title.isEmpty {
            viewModel.showAlert(title: "Ошибка", message: "Название не может быть пустым.")
            return
        }
        if subtitle.isEmpty {
            viewModel.showAlert(title: "Ошибка", message: "Подзадача не может быть пустой.")
            return
        }
        
        guard let image = locationMapUIImage.image else {
            viewModel.showAlert(title: "Ошибка", message: "Картинка не найдена.")
            return
        }
        
        let fileName = UUID().uuidString + ".png"
        guard let imagePath = viewModel.saveImageToDocuments(image, fileName: fileName) else {
            viewModel.showAlert(title: "Ошибка", message: "Не удалось сохранить фотокарточку.")
            return
        }
        
        viewModel.saveNotification(
            title: title,
            x: viewModel.x.value,
            y: viewModel.y.value,
            radius: viewModel.radius.value,
            url: imagePath,
            subtitle: subtitle,
            category: selectedCategory,
            priority: selectedPriority
        )
        
        viewModel.closeVC()
    }
    
    @objc private func cancelButtonTap() {
        viewModel.closeVC()
    }
    
    @objc private func handleMapTap() {
        viewModel.openFullMap()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func categoryButtonTapped(_ sender: UIButton) {
        [otherButton, workButton].forEach { button in
            button.backgroundColor = button == sender ? Colors.appYellowColor : Colors.appGreyColor
        }
        if let buttonTitle = sender.title(for: .normal) {
            switch buttonTitle {
            case "Другое":
                selectedCategory = "Other"
            case "Работа":
                selectedCategory = "Work"
            default:
                selectedCategory = "Other"
            }
        } else {
            selectedCategory = "Other"
        }
    }
    
    @objc private func priorityButtonTapped(_ sender: UIButton) {
        [criticalButton, highPriorityButton, mediumPriorityButton, lowPriorityButton].forEach { button in
            button.backgroundColor = button == sender ? Colors.appYellowColor : Colors.appGreyColor
        }
        if let buttonTitle = sender.title(for: .normal) {
            switch buttonTitle {
            case "Критичный":
                selectedPriority = "Critical"
            case "Высокий":
                selectedPriority = "High"
            case "Средний":
                selectedPriority = "Medium"
            case "Низкий":
                selectedPriority = "Low"
            default:
                selectedPriority = "Medium"
            }
        } else {
            selectedPriority = "Medium"
        }
    }
}
