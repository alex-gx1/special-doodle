import Foundation
import UIKit
import SnapKit

protocol MainScreenViewModelProtocol {}

final class MainScreenVC: UIViewController {
    
    private let viewModel: MainScreenViewModelProtocol
    
    init(viewModel: MainScreenViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var globalCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var tabBarVC: TabBarVC = {
        return TabBarAssembler.make() as! TabBarVC 
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(globalCardView)
        
        addChild(tabBarVC)
        view.addSubview(tabBarVC.view)
        tabBarVC.didMove(toParent: self)
    
        globalCardView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(tabBarVC.view.snp.top).offset(-10)
        }
        
        tabBarVC.view.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(80)
        }
        
    }
}
