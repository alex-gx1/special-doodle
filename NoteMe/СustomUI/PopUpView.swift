import UIKit
import SnapKit

final class PopUpView: UIView {

    var onCalendarTap: (() -> Void)?
        var onLocationTap: (() -> Void)?
        var onTimerTap: (() -> Void)?
        
        private lazy var calendarButton: UIButton = {
            let button = UIButton()
            button.setImage(Images.calendarButton, for: .normal)
            button.addTarget(self, action: #selector(calendarTapped), for: .touchUpInside)
            return button
        }()
        
        private lazy var locationButton: UIButton = {
            let button = UIButton()
            button.setImage(Images.locationButton, for: .normal)
            button.addTarget(self, action: #selector(locationTapped), for: .touchUpInside)
            return button
        }()
        
        private lazy var timerButton: UIButton = {
            let button = UIButton()
            button.setImage(Images.timerButton, for: .normal)
            button.addTarget(self, action: #selector(timerTapped), for: .touchUpInside)
            return button
        }()
        
        private lazy var stackView: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [calendarButton, locationButton, timerButton])
            stack.axis = .vertical
            stack.alignment = .center
            stack.spacing = 16
            stack.backgroundColor = .white
            stack.layer.cornerRadius = 10
            stack.layer.shadowColor = UIColor.black.cgColor
            stack.layer.shadowOpacity = 0.1
            stack.layer.shadowRadius = 5
            stack.layer.shadowOffset = CGSize(width: 0, height: 3)
            return stack
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupUI() {
            backgroundColor = UIColor.black.withAlphaComponent(0.5)
            addSubview(stackView)
            stackView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.equalTo(180)
                make.height.equalTo(132)
            }
        }
        
        @objc private func calendarTapped() {
            onCalendarTap?()
        }
        
        @objc private func locationTapped() {
            onLocationTap?()
        }
        
        @objc private func timerTapped() {
            onTimerTap?()
        }
}
