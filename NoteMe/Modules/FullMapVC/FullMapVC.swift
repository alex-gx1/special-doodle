import UIKit
import MapKit
import SnapKit

protocol FullMapViewModelProtocol {
    func openSearchScreen()
}

final class FullMapVC: UIViewController {
    
    private let viewModel: FullMapViewModelProtocol
    
    init(viewModel: FullMapViewModelProtocol) {
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
    
    private lazy var globalCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private func keyBoardDownTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    private lazy var searchContainer: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 18
        return view
    }()
    
    private lazy var searchIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.search
        return imageView
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search"
        textField.borderStyle = .none
        textField.font = .systemFont(ofSize: 16)
        textField.clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(textFieldTapped), for: .editingDidBegin)
        return textField
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.isRotateEnabled = true
        return mapView
    }()
    
    private lazy var searchStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.distribution = .fill
        stack.backgroundColor = .white
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    private func setupUI() {
        view.backgroundColor = Colors.appBlackColor
        view.addSubview(globalCardView)
        
        globalCardView.addSubview(mapView)
        globalCardView.addSubview(searchStackView)
        
        searchStackView.addArrangedSubview(searchContainer)
        searchStackView.addArrangedSubview(cancelButton)
        
        searchContainer.addSubview(searchIcon)
        searchContainer.addSubview(searchTextField)
        
        globalCardView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        searchStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(55)
        }
        
        cancelButton.setContentHuggingPriority(.required, for: .horizontal)
        cancelButton.snp.makeConstraints { make in
            make.height.equalTo(36)
        }
        
        searchContainer.snp.makeConstraints { make in
            make.height.equalTo(36)
        }
        
        searchIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.left.equalTo(searchIcon.snp.right).offset(8)
            make.right.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview()
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(searchContainer.snp.bottom).offset(1)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    @objc private func cancelTapped() {
        dismissKeyboard()
        searchTextField.text = ""
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func textFieldTapped() {
        viewModel.openSearchScreen()
    }
}
