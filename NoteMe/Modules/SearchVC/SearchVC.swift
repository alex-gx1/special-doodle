import UIKit
import SnapKit

protocol SearchViewModelProtocol {
    
}

final class SearchVC: UIViewController {
    
    private let viewModel: SearchViewModelProtocol
    
    init(viewModel: SearchViewModelProtocol) {
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
    
    private func setupUI() {
        
    }
}
