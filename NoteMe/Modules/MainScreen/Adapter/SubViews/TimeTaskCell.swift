import UIKit
import SnapKit

protocol TimerTaskCellDelegate: AnyObject {
    func timerTaskCellDidTapAction(_ cell: TimerTaskCell)
}

final class TimerTaskCell: UITableViewCell {
    
    private var timer: Timer?
    
    weak var delegate: TimerTaskCellDelegate?
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.cellTimer
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appBoldFont17
        label.textColor = .black
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .darkGray
        return label
    }()
    
    let actionButton: UIButton = {
        let button = UIButton()
        button.setImage(Images.cellOptions, for: .normal)
        return button
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appBoldFont25
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        cellSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func cellSetup() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 2
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.masksToBounds = false
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        actionButton.addTarget(self, action: #selector(didTouchDown), for: .touchDown)
        actionButton.addTarget(self, action: #selector(didTouchUp), for: [.touchUpInside, .touchCancel, .touchUpOutside])
    }
    
    @objc private func didTouchDown() {
        actionButton.alpha = 0.5
    }

    @objc private func didTouchUp() {
        UIView.animate(withDuration: 0.2) {
            self.actionButton.alpha = 1.0
        }
    }
    
    @objc private func actionButtonTapped() {
        delegate?.timerTaskCellDidTapAction(self)
    }
    
    private func setupUI() {
        
        
        [iconImageView, titleLabel, subtitleLabel, actionButton, timerLabel].forEach {
            contentView.addSubview($0)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(54)
            make.size.equalTo(50)
        }
        
        actionButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(16)
            make.size.equalTo(18)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView)
            make.left.equalTo(iconImageView.snp.right).offset(12)
            make.right.lessThanOrEqualTo(actionButton.snp.left).offset(-8)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.equalTo(titleLabel)
            make.right.equalToSuperview().inset(16)
        }
        
        timerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    func configure(with model: TimerTaskModel) {
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
        updateTimerLabel(seconds: model.seconds, createdAt: model.createdAt)
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateTimerLabel(seconds: model.seconds, createdAt: model.createdAt)
        }
    }
    
    private func updateTimerLabel(seconds: Double, createdAt: Date) {
        let elapsed = Date().timeIntervalSince(createdAt)
        let remaining = max(0, seconds - elapsed)
        timerLabel.text = formatSeconds(remaining)
    }

    private func formatSeconds(_ seconds: Double) -> String {
        let totalSeconds = Int(seconds)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let secs = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, secs)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        timer?.invalidate()
        timer = nil
    }

}
