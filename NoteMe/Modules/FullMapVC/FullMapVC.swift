import UIKit
import MapKit
import SnapKit

protocol FullMapViewModelProtocol {
    
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
    }
    
    private lazy var globalCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var searchView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        let bottomBorder = UIView()
        bottomBorder.backgroundColor = Colors.appBlackColor
        view.addSubview(bottomBorder)

        bottomBorder.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        return view
    }()
    
    private lazy var searchContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .green
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
        return textField
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        return button
    }()
    
    private func setupUI() {
        view.backgroundColor = Colors.appBlackColor
        view.addSubview(globalCardView)
        
        globalCardView.addSubview(searchView)
        globalCardView.addSubview(searchView)
        searchView.addSubview(searchContainer)
        searchView.addSubview(cancelButton)

        searchContainer.addSubview(searchIcon)
        searchContainer.addSubview(searchTextField)

        
        globalCardView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        searchView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(55)
        }

        searchContainer.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.right.equalTo(cancelButton.snp.left).offset(-12)
            make.height.equalTo(36)
        }

        cancelButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
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
    }
    
    @objc private func cancelTapped() {
        searchTextField.text = ""
        searchTextField.resignFirstResponder()
    }

}
