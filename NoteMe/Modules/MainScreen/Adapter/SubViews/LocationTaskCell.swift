import UIKit
import SnapKit

protocol LocationTaskCellDelegate: AnyObject {
    func locationTaskCellDidTapAction(_ cell: LocationTaskCell)
}

final class LocationTaskCell: UITableViewCell {
    
    weak var delegate: LocationTaskCellDelegate?
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.cellLocation
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
    
    private lazy var locationMapUIImage: UIImageView = {
        let mapView = UIImageView()
        mapView.contentMode = .scaleAspectFill
        mapView.clipsToBounds = true
        mapView.layer.cornerRadius = 8
        return mapView
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
        delegate?.locationTaskCellDidTapAction(self)
    }
    
    private func setupUI() {
        
        [iconImageView, titleLabel, subtitleLabel, actionButton, locationMapUIImage].forEach {
            contentView.addSubview($0)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(16)
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
        
        locationMapUIImage.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo(140)
        }
    }
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        return CGSize(width: targetSize.width, height: 220)
    }
    
    func configure(with model: LocationTaskModel) {
        resetCellAppearance()
        
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
        
        if let imagePath = model.url.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
           let imageUrl = URL(string: imagePath),
           let image = UIImage(contentsOfFile: imageUrl.path) {
            
            let targetSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 160)
            let scaledImage = image.scaledToSize(targetSize)
            locationMapUIImage.image = scaledImage
        } else {
            locationMapUIImage.image = Images.locationMap
        }
        
        
        if model.completedDate != Date.distantPast {
            applyCompletedStyle()
        }
    }
    
    private func resetCellAppearance() {
        contentView.backgroundColor = .white
        titleLabel.textColor = .black
        subtitleLabel.textColor = .darkGray
        locationMapUIImage.alpha = 1.0
        
        locationMapUIImage.subviews.forEach {
            if $0.tag == 100 {
                $0.removeFromSuperview()
            }
        }
    }
    
    private func applyCompletedStyle() {
        contentView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        titleLabel.textColor = .lightGray
        subtitleLabel.textColor = .lightGray
        
        let overlayView = UIView(frame: locationMapUIImage.bounds)
        overlayView.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        overlayView.tag = 100
        overlayView.isUserInteractionEnabled = false
        locationMapUIImage.addSubview(overlayView)
    }
}

extension UIImage {
    func scaledToSize(_ size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
