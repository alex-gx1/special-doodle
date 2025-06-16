import UIKit
import SnapKit
import FirebaseAuth
import Firebase


protocol ProfileScreenViewModelProtocol {
    func showAlert(Title: String, Message: String?)
    func getUserMail() -> String
    func openStatsScreen()
    func exportData()
    func importData()
}

final class ProfileScreenVC: UIViewController {
    
    private let viewModel: ProfileScreenViewModelProtocol
    
    private let service = AuthService()
    
    init(viewModel: ProfileScreenViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        labelForUserMail.text = viewModel.getUserMail()
    }
    
    private lazy var globalCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var accountLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.appBlackColor
        label.font = UIFont.appBoldFont15
        label.textAlignment = .center
        label.text = "Аккаунт"
        return label
    }()
    
    private lazy var mailCardView: UIView = {
        let view = UIView()
        view.applyCardStyleShadow()
        view.applyCardStyleCorner()
        view.applyCardStyleBackgroundColor()
        return view
    }()
    
    private lazy var labelForMailCardView: UILabel = {
        let label = UILabel()
        label.textColor = Colors.appGreyColor
        label.font = UIFont.appFont15
        label.text = "Ваш e-mail:"
        return label
    }()
    
    private lazy var labelForUserMail: UILabel = {
        let label = UILabel()
        label.textColor = Colors.appBlackColor
        label.font = UIFont.appFont15
        return label
    }()
    
    private lazy var settingsLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.appBlackColor
        label.font = UIFont.appBoldFont15
        label.textAlignment = .center
        label.text = "Настройки"
        return label
    }()
    
    private lazy var bottomCardView: UIView = {
        let view = UIView()
        view.applyCardStyleShadow()
        view.applyCardStyleCorner()
        view.applyCardStyleBackgroundColor()
        return view
    }()
    
    private lazy var notificationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.notification
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        return imageView
    }()
    
    private lazy var switchLabel: UILabel = {
        let label = UILabel()
        label.text = "Нотификации"
        label.textColor = Colors.appBlackColor
        label.font = UIFont.appFont15
        return label
    }()
    
    private lazy var toggleSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = true
        toggle.onTintColor = Colors.appYellowColor
        return toggle
    }()
    
    private lazy var switchContainer: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [notificationImageView, switchLabel, toggleSwitch ])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var separator1: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.appGreyColor
        return view
    }()
    
    private lazy var separator2: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.appGreyColor
        return view
    }()
    
    private lazy var exportButton: UIButton = {
        let button = UIButton()
        button.setImage(Images.export, for: .normal)
        button.setTitle(" Экспорт в .csv", for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(Colors.appBlackColor, for: .normal)
        button.titleLabel?.font = UIFont.appFont15
        button.addTarget(self, action: #selector(handleExport), for: .touchUpInside)
        return button
    }()
    
    private lazy var importButton: UIButton = {
        let button = UIButton()
        button.setImage(Images.export, for: .normal)
        button.setTitle(" Импорт", for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(Colors.appBlackColor, for: .normal)
        button.titleLabel?.font = UIFont.appFont15
        button.addTarget(self, action: #selector(handleImport), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleExport() {
        viewModel.exportData()
    }
    
    @objc private func handleImport() {
        viewModel.importData()
    }
    
    private lazy var statsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.stats
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        return imageView
    }()
    
    private lazy var statsButton: UIButton = {
        let button = UIButton()
        button.setImage(Images.stats, for: .normal)
        button.setTitle(" Диаграммы", for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(Colors.appBlackColor, for: .normal)
        button.titleLabel?.font = UIFont.appFont15
        button.addTarget(self, action: #selector(handleStats), for: .touchUpInside)
        return button
    }()
    
    private lazy var separator3: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.appGreyColor
        return view
    }()
    
    private lazy var separator4: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.appGreyColor
        return view
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setImage(Images.logout, for: .normal)
        button.setTitle(" Выход", for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(Colors.appRedColor, for: .normal)
        button.titleLabel?.font = UIFont.appFont15
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()
    
    private func setupUI() {
        view.backgroundColor = Colors.appBlackColor
        
        view.addSubview(globalCardView)
        
        globalCardView.addSubview(accountLabel)
        
        globalCardView.addSubview(mailCardView)
        
        mailCardView.addSubview(labelForMailCardView)
        
        mailCardView.addSubview(labelForUserMail)
        
        globalCardView.addSubview(settingsLabel)
        
        globalCardView.addSubview(bottomCardView)
        
        bottomCardView.addSubview(switchContainer)
        
        bottomCardView.addSubview(exportButton)
        
        bottomCardView.addSubview(separator1)
        
        bottomCardView.addSubview(separator2)
        
        bottomCardView.addSubview(logoutButton)
        
        bottomCardView.addSubview(statsButton)
        
        bottomCardView.addSubview(separator3)
        
        bottomCardView.addSubview(separator4)
        
        bottomCardView.addSubview(importButton)
        
        globalCardView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        accountLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.equalToSuperview().inset(20)
            make.height.equalTo(17)
        }
        
        mailCardView.snp.makeConstraints { make in
            make.top.equalTo(accountLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(73)
        }
        
        labelForMailCardView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(17)
            
        }
        
        labelForUserMail.snp.makeConstraints { make in
            make.top.equalTo(labelForMailCardView.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(17)
        }
        
        settingsLabel.snp.makeConstraints { make in
            make.top.equalTo(mailCardView.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(20)
            make.height.equalTo(17)
        }
        
        bottomCardView.snp.makeConstraints { make in
            make.top.equalTo(settingsLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(226)
        }
        
        switchContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(30)
        }
        
        separator1.snp.makeConstraints { make in
            make.top.equalTo(switchContainer.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        exportButton.snp.makeConstraints { make in
            make.top.equalTo(separator1.snp.bottom).offset(6)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(30)
        }
        
        separator2.snp.makeConstraints { make in
            make.top.equalTo(exportButton.snp.bottom).offset(6)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        statsButton.snp.makeConstraints { make in
            make.top.equalTo(separator2.snp.bottom).offset(6)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(30)
        }
        
        separator3.snp.makeConstraints { make in
            make.top.equalTo(statsButton.snp.bottom).offset(6)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        importButton.snp.makeConstraints { make in
            make.top.equalTo(separator3.snp.bottom).offset(6)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(30)
        }
        
        separator4.snp.makeConstraints { make in
            make.top.equalTo(importButton.snp.bottom).offset(6)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(separator4.snp.bottom).offset(6)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(30)
        }
    }
    
    @objc func handleLogout() {
        viewModel.showAlert(Title: "Are you shure about that ?", Message: "You will be sent to the login page")
    }
    
    @objc func handleStats() {
        viewModel.openStatsScreen()
    }
}
