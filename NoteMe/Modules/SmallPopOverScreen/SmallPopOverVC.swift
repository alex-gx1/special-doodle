import UIKit
import SnapKit

final class SmallPopOverVC: UIViewController {
    
    private let viewModel: SmallPopOverViewModelProtocol
    
    init(viewModel: SmallPopOverViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        preferredContentSize = CGSize(width: 200, height: 120)
        setupButtons()
    }
    
    private func setupButtons() {
        let editBtn = makeStyledButton(title: "Редактировать", image: Images.editIcon, showSeparator: true) {
            self.viewModel.editAction()
        }
        let doneBtn = makeStyledButton(title: "Выполнено", image: Images.doneIcon, showSeparator: true) {
            self.viewModel.doneAction()
        }
        let deleteBtn = makeStyledButton(title: "Удалить", image: Images.deleteIcon, showSeparator: false) {
            self.viewModel.deleteAction()
        }
        
        [editBtn, doneBtn, deleteBtn].forEach { view.addSubview($0) }
        
        editBtn.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(40)
        }
        
        doneBtn.snp.makeConstraints { make in
            make.top.equalTo(editBtn.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(40)
        }
        
        deleteBtn.snp.makeConstraints { make in
            make.top.equalTo(doneBtn.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    func makeStyledButton(title: String, image: UIImage?, showSeparator: Bool, action: @escaping () -> Void) -> UIView {
        let container = UIView()
        container.layer.cornerRadius = 0
        
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        
        let imageView = UIImageView(image: image)
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        
        let highlightView = UIView()
        highlightView.backgroundColor = UIColor.systemGray5
        highlightView.alpha = 0
        container.addSubview(highlightView)
        highlightView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let separator = UIView()
        separator.backgroundColor = UIColor.separator
        separator.isHidden = !showSeparator
        
        container.addSubview(label)
        container.addSubview(imageView)
        container.addSubview(button)
        container.addSubview(separator)
        
        label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        
        imageView.snp.remakeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        separator.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(12)
            make.height.equalTo(0.5)
        }
        
        button.addAction(UIAction { _ in
            highlightView.alpha = 0.0
            action()
        }, for: .touchUpInside)
        
        button.addTargetClosure(
            down: { highlightView.alpha = 1.0 },
            up: { highlightView.alpha = 0.0 }
        )
        
        return container
    }
}

//extension UIControl {
//    func addTargetClosure(down: (() -> Void)?, up: (() -> Void)?) {
//        if let down = down {
//            self.addAction(UIAction { _ in down() }, for: .touchDown)
//        }
//        if let up = up {
//            self.addAction(UIAction { _ in up() }, for: [.touchUpInside, .touchUpOutside, .touchCancel, .touchDragExit])
//        }
//    }
//}
