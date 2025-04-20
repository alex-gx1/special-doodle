import UIKit
import SnapKit

final class CustomDateKeyboard: UIView {
    
    let selectedDate = Observable("Month : Day : Year")
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "en_US")
        return picker
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(Colors.appYellowColor, for: .normal)
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(Colors.appYellowColor, for: .normal)
        return button
    }()
    
    private lazy var topBar: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.appBlackColor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }
        
    required init?(coder: NSCoder) { nil }
    
    private func setupUI() {
        addSubview(topBar)
        topBar.addSubview(doneButton)
        topBar.addSubview(cancelButton)
        addSubview(datePicker)
        
        topBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(45)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        doneButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(topBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupActions() {
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }
    
    @objc private func dateChanged() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM : dd : yyyy"
        selectedDate.value = formatter.string(from: datePicker.date)
    }
}
