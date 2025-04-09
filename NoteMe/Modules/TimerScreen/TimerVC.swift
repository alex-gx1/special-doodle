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
        view.backgroundColor = .white
    }
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "00:00:00"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
    private lazy var cardView: UIView = {
        let view = UIView()
        view.applyCardStyleShadow()
        view.applyCardStyleCorner()
        view.applyCardStyleBackgroundColor()
        return view
    }()
    
    private func setupUI() {
        
        view.addSubview(cardView)
        
        cardView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.horizontalEdges.equalToSuperview().offset(20)
            make.height.equalTo(100)
        }
        
        cardView.addSubview(timerLabel)
        
        timerLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
        }
    }
}
