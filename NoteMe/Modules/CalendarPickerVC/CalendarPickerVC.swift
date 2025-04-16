import UIKit
import SnapKit

protocol CalendarPickerViewModelProtocol {
    func dismiss()
    var month: String { get set }
    var day: Int { get set }
    var year: Int { get set }
    var onDateUpdated: ((String) -> Void)? { get set }
    func updateDate(month: String, day: Int, year: Int)
    func didTapDone()
}

final class CalendarPickerVC: UIViewController {
    
    private let viewModel: CalendarPickerViewModelProtocol
    
    init(viewModel: CalendarPickerViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addDismissGesture()
    }
    
    private lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(Colors.appYellowColor, for: .normal)
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Select", for: .normal)
        button.setTitleColor(Colors.appYellowColor, for: .normal)
        button.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var topBar: UIView = {
        let topBar = UIView()
        topBar.backgroundColor = Colors.appBlackColor
        return topBar
    }()
    
    private func addDismissGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(topBar)
        topBar.addSubview(cancelButton)
        topBar.addSubview(doneButton)
        view.addSubview(pickerView)
        
        topBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        doneButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        pickerView.snp.makeConstraints { make in
            make.top.equalTo(topBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    @objc private func cancelTapped() {
        viewModel.dismiss()
    }
    
    @objc private func doneTapped() {
        viewModel.didTapDone()
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        if translation.y > 100 {
            dismiss(animated: true)
        }
    }
}

// MARK: - PickerView Logic

extension CalendarPickerVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    var months: [String] {
        return Calendar.current.monthSymbols
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int { 3 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return months.count          // Months
        case 1: return 31                    // Days
        case 2: return 201                   // Years from 1900 to 2100
        default: return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0: return months[row]               // Month name
        case 1: return "\(row + 1)"              // Day
        case 2: return "\(1900 + row)"           // Year
        default: return nil
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedMonth = months[pickerView.selectedRow(inComponent: 0)]
        let selectedDay = pickerView.selectedRow(inComponent: 1) + 1
        let selectedYear = 1900 + pickerView.selectedRow(inComponent: 2)

        viewModel.updateDate(month: selectedMonth, day: selectedDay, year: selectedYear)
    }
}
