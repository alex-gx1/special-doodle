import UIKit
import SnapKit

final class FilterCell: UICollectionViewCell {
    
    static let identifier = "filterCell"
    
    private let titleLabel = UILabel()
    
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

    func setup(_ item: FilterItem, isSelected: Bool) {
        titleLabel.text = item.rawValue
        contentView.backgroundColor = isSelected ? Colors.appYellowColor : Colors.appGreyColor
        titleLabel.textColor = Colors.appBlackColor
        titleLabel.font = isSelected ? UIFont.appBoldFont17 : UIFont.appFont17
    }
}
