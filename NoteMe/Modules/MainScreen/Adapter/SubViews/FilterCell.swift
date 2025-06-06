import UIKit
import SnapKit

final class FilterCell: UICollectionViewCell {
    
    static let identifier = "filterCell"
    
    private let titleLabel = UILabel()
    
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        additionalSetupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func additionalSetupUI() {
        titleLabel.textAlignment = .center
        contentView.layer.cornerRadius = 5
    }
    
    private func updateAppearance() {
        contentView.backgroundColor = isSelected ? Colors.appYellowColor : Colors.appGreyColor
        titleLabel.font = isSelected ? UIFont.appBoldFont17 : UIFont.appFont17
    }
    
    func setup(with item: FilterItem) {
        titleLabel.text = item.rawValue
        titleLabel.textColor = Colors.appBlackColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        isSelected = false
    }
}
