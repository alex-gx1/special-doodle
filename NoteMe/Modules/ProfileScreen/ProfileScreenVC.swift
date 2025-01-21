import UIKit
import SnapKit

protocol ProfileScreenViewModelProtocol {}

final class ProfileScreenVC: UIViewController {
    
    private let viewModel: ProfileScreenViewModelProtocol
    
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
    }
    
    private lazy var globalCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private func setupUI() {
        view.backgroundColor = Colors.appBlackColor

        view.addSubview(globalCardView)
        globalCardView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview() 
        }

    }
}
