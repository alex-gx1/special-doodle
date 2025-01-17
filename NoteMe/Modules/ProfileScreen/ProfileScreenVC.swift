import UIKit

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
    }
    
}
