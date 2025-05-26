import UIKit
import SnapKit

final class DateTaskCell: UITableViewCell {
    
    private let dateBoxView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
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
    
    private let actionButton: UIButton = {
        let button = UIButton()
        button.setImage(Images.cellOptions, for: .normal)
        return button
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        
        [dateBoxView, titleLabel, subtitleLabel, actionButton].forEach {
            contentView.addSubview($0)
        }
        dateBoxView.addSubview(dateLabel)

        
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 2
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.masksToBounds = false
        
        dateBoxView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(16)
            make.size.equalTo(50)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.centerX.centerY.equalToSuperview()
        }
        
        actionButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(16)
            make.size.equalTo(18)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(dateBoxView)
            make.left.equalTo(dateBoxView.snp.right).offset(12)
            make.right.lessThanOrEqualTo(actionButton.snp.left).offset(-8)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.equalTo(titleLabel)
            make.right.equalToSuperview().inset(16)
        }
        
//        dateLabel.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.bottom.equalToSuperview().inset(12)
//        }
    }
    
    func configure(with model: DateTaskModel, day: String, month: String) {
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle

        let attrStr = NSMutableAttributedString(string: "\(day)\n\(month)")
        attrStr.addAttributes([
            .foregroundColor: Colors.appYellowColor!,
            .font: UIFont.appBoldFont25
        ], range: NSRange(location: 0, length: day.count))

        attrStr.addAttributes([
            .foregroundColor: Colors.appGreyColor!,
            .font: UIFont.appBoldFont15
        ], range: NSRange(location: day.count + 1, length: month.count))

        dateLabel.attributedText = attrStr
    }

}
