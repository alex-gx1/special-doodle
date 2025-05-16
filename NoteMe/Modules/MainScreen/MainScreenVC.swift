import Foundation
import Storage
import UIKit
import SnapKit

protocol MainScreenViewModelProtocol {}

final class MainScreenVC: UIViewController {
    
    private let viewModel: MainScreenViewModelProtocol
    
    init(viewModel: MainScreenViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var globalCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()
    
    private var selectedButton: UIButton?
    
    private lazy var filterButtons: [UIButton] = [allButton, dateButton, timeButton, locationButton]
    
    private func setupButtonTagsAndActions() {
        for (index, button) in filterButtons.enumerated() {
            button.tag = index
            button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        }
    }
    
    private lazy var allButton: UIButton = {
        let button = UIButton()
        button.setTitle("All", for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    private lazy var dateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Date", for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    private lazy var timeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Time", for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    private lazy var locationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Location", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.appBoldFont17
        return button
    }()
    
    private let tableView = UITableView()
    
    private var timerTasks: [TimerTaskModel] = []
    private var dateTasks: [DateTaskModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupButtonTagsAndActions()
        filterButtonTapped(allButton)
    }
    
    private func setupUI() {
        view.backgroundColor = Colors.appBlackColor
        view.addSubview(globalCardView)
        
        globalCardView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        globalCardView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(allButton)
        buttonStackView.addArrangedSubview(dateButton)
        buttonStackView.addArrangedSubview(timeButton)
        buttonStackView.addArrangedSubview(locationButton)
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(globalCardView.snp.top).inset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(32)
        }
        
        globalCardView.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(16)
            make.left.right.bottom.equalToSuperview().inset(20)
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TimerTaskCell.self, forCellReuseIdentifier: "TimerTaskCell")
        tableView.register(DateTaskCell.self, forCellReuseIdentifier: "DateTaskCell")
        tableView.separatorStyle = .none
    }
    
    
    @objc private func filterButtonTapped(_ sender: UIButton) {
        
        filterButtons.forEach {
            $0.backgroundColor = Colors.appGreyColor
            $0.setTitleColor(Colors.appBlackColor, for: .normal)
        }
        
        sender.backgroundColor = Colors.appYellowColor
        sender.setTitleColor(Colors.appBlackColor, for: .normal)
        
        selectedButton = sender
        
        switch sender.tag {
        case 0:
            print("tapped 1")
            dateTasks = []
            timerTasks = []
            loadDateTasks()
            loadTimerTasks()
            //        viewModel.showAll()
        case 1:
            print("tapped 2")
            dateTasks = []
            loadDateTasks()
            //        viewModel.showDate()
        case 2:
            print("tapped 3")
            timerTasks = []
            loadTimerTasks()
            //        viewModel.showTime()
        case 3:
            print("tapped 4")
            //        viewModel.showLocation()
        default:
            break
        }
        tableView.reloadData()
    }
}

extension MainScreenVC: UITableViewDataSource, UITableViewDelegate {
    
    // убрать в viewModel
    private func loadTimerTasks() {
        let storage = TimerNotificationStorage()
        let dtos = storage.fetch()
        timerTasks = dtos.map {
            TimerTaskModel(
                title: $0.title,
                subtitle: $0.subtitle ?? "",
                timeString: formatSeconds($0.seconds)
            )
        }
        tableView.reloadData()
    }
    // убрать в viewModel
    private func loadDateTasks() {
        let storage = DateNotificationStorage()
        let dtos = storage.fetch()
        dateTasks = dtos.map {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return DateTaskModel(
                title: $0.title,
                subtitle: $0.subtitle ?? "",
                dateString: formatter.string(from: $0.targetDate)
            )
        }
        tableView.reloadData()
    }
    // убрать в viewModel
    private func formatSeconds(_ seconds: Double) -> String {
        let totalSeconds = Int(seconds)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let secs = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, secs)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedButton?.tag {
        case 0:
            return dateTasks.count + timerTasks.count
        case 1:
            return dateTasks.count
        case 2:
            return timerTasks.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch selectedButton?.tag {
        case 0:
            if indexPath.row < dateTasks.count {
                let cell = DateTaskCell()
                let model = dateTasks[indexPath.row]
                cell.configure(with: model)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TimerTaskCell", for: indexPath) as! TimerTaskCell
                let model = timerTasks[indexPath.row - dateTasks.count]
                cell.configure(with: model)
                return cell
            }
        case 1:
            let cell = DateTaskCell()
            let model = dateTasks[indexPath.row]
            cell.configure(with: model)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimerTaskCell", for: indexPath) as! TimerTaskCell
            let model = timerTasks[indexPath.row]
            cell.configure(with: model)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
