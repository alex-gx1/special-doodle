import UIKit
import SnapKit

protocol MenuPopOverViewModelProtocol {
    func openTimerScreen()
    func openLocationScreen()
    func openCalenderScreen()
}

final class MenuPopoverVC: UIViewController {
    
    private let viewModel: MenuPopOverViewModelProtocol
    
    init(viewModel: MenuPopOverViewModelProtocol) {
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
        let timerBtn = makeStyledButton(title: "Timer", image: Images.timerButton, showSeparator: true) {
            self.viewModel.openTimerScreen()
        }
        let locationBtn = makeStyledButton(title: "Location", image: Images.locationButton, showSeparator: true) {
            self.viewModel.openLocationScreen()
        }
        let calendarBtn = makeStyledButton(title: "Calendar", image: Images.calendarButton, showSeparator: false) {
            self.viewModel.openCalenderScreen()
        }
        
        view.addSubview(timerBtn)
        view.addSubview(locationBtn)
        view.addSubview(calendarBtn)
        
        timerBtn.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(40)
        }
        
        locationBtn.snp.makeConstraints { make in
            make.top.equalTo(timerBtn.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(40)
        }
        
        calendarBtn.snp.makeConstraints { make in
            make.top.equalTo(locationBtn.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    private func makeStyledButton(title: String, image: UIImage?, showSeparator: Bool, action: @escaping () -> Void) -> UIView {
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

        imageView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }

        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        separator.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview()
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

extension UIControl {
    func addTargetClosure(down: (() -> Void)?, up: (() -> Void)?) {
        if let down = down {
            self.addAction(UIAction { _ in down() }, for: .touchDown)
        }
        if let up = up {
            self.addAction(UIAction { _ in up() }, for: [.touchUpInside, .touchUpOutside, .touchCancel, .touchDragExit])
        }
    }
}
