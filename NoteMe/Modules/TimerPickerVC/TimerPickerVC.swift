import UIKit
import SnapKit

protocol TimerPickerViewModelProtocol: AnyObject {
    func didTapCancel()
    func didTapDone()
    var hours: Int { get set }
    var minutes: Int { get set }
    var seconds: Int { get set }
    var onTimeUpdated: ((String) -> Void)? { get set }
    func updateTime(hours: Int, minutes: Int, seconds: Int)
}



final class TimerPickerVC: UIViewController {
    
    private let viewModel: TimerPickerViewModelProtocol
    
    init(viewModel: TimerPickerViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addDismissGesture()
    }
    
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
        viewModel.didTapCancel()
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

extension TimerPickerVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 3 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? 24 : 60
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0: return "\(row) hours"
        case 1: return "\(row) min"
        case 2: return "\(row) sec"
        default: return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            viewModel.hours = row
            viewModel.updateTime(hours: row, minutes: viewModel.minutes, seconds: viewModel.seconds)
        case 1:
            viewModel.minutes = row
            viewModel.updateTime(hours: viewModel.hours, minutes: row, seconds: viewModel.seconds)
        case 2:
            viewModel.seconds = row
            viewModel.updateTime(hours: viewModel.hours, minutes: viewModel.minutes, seconds: row)
        default: break
        }
    }
}
