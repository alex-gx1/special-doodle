import UIKit
import SnapKit

final class CustomDateVC: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let selectedDate = Observable("Month : Day : Year")
    
    let pickerView = UIPickerView()
    
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
        let topBar = UIView()
        topBar.backgroundColor = Colors.appBlackColor
        return topBar
    }()
    
    var month = [String]()
    var day = [Int]()
    var year = [Int]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupData()
        setupUI()
    }
    
    required init?(coder: NSCoder) { nil }
    
    private func setupData() {
        let dateFormatter = DateFormatter()
        month = dateFormatter.monthSymbols
        day = Array(1...31)
        year = Array(2025...2050)
    }
    
    private func setupUI() {
        addSubview(pickerView)
        addSubview(topBar)
        topBar.addSubview(doneButton)
        topBar.addSubview(cancelButton)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
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
        
        pickerView.snp.makeConstraints { make in
            make.top.equalTo(topBar.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(30)
            make.bottom.equalToSuperview()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return month.count
        case 1:
            return day.count
        case 2:
            return year.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return String(month[row])
        case 1:
            return String(format: "%2d", day[row])
        case 2:
            return String(year[row])
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let month = month[pickerView.selectedRow(inComponent: 0)]
        let day = day[pickerView.selectedRow(inComponent: 1)]
        let year = year[pickerView.selectedRow(inComponent: 2)]
        selectedDate.value = "\(month) : \(day) : \(year)"
        
    }
    
    
    
}
