import UIKit
import SnapKit

final class CustomTimePickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let selectedTime = Observable("0 hours : 0 min : 0 sec")
    
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
    
    var hours = [Int]()
    var minutes = [Int]()
    var seconds = [Int]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupData()
        setupUI()
    }
    
    required init?(coder: NSCoder) { nil }
    
    private func setupData() {
        hours = Array(0...23)
        minutes = Array(0...59)
        seconds = Array(0...59)
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
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return hours.count
        case 1:
            return minutes.count
        case 2:
            return seconds.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return String(format: "%2d", hours[row]) + " hours"
        case 1:
            return String(format: "%2d", minutes[row]) + " min"
        case 2:
            return String(format: "%2d", seconds[row]) + " sec"
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let hour = hours[pickerView.selectedRow(inComponent: 0)]
        let minute = minutes[pickerView.selectedRow(inComponent: 1)]
        let second = seconds[pickerView.selectedRow(inComponent: 2)]
        selectedTime.value = "\(hour) hours : \(minute) min : \(second) sec"
         
    }
}
