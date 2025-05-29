import UIKit

final class MainScreenAdapter: NSObject {
    
    weak var locationTaskDelegate: LocationTaskCellDelegate?
    weak var timerTaskDelegate: TimerTaskCellDelegate?
    weak var dateTaskDelegate: DateTaskCellDelegate?
    
    var models: [NotificationModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let tableView: UITableView
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(TimerTaskCell.self, forCellReuseIdentifier: "\(TimerTaskCell.self)")
        tableView.register(DateTaskCell.self, forCellReuseIdentifier: "\(DateTaskCell.self)")
        tableView.register(LocationTaskCell.self, forCellReuseIdentifier: "\(LocationTaskCell.self)")
    }
    
    func resetData() {
        models = []
    }
    
    func update(with models: [NotificationModel]) {
        self.models = models
    }
}

extension MainScreenAdapter: UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch models[indexPath.row] {
        case .timer(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(TimerTaskCell.self)", for: indexPath) as! TimerTaskCell
            cell.configure(with: model)
            cell.delegate = timerTaskDelegate
            cell.selectionStyle = .none
            return cell

        case .date(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(DateTaskCell.self)", for: indexPath) as! DateTaskCell
            cell.configure(with: model, day: model.day, month: model.month)
            cell.delegate = dateTaskDelegate
            cell.selectionStyle = .none
            return cell
            
        case .location(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(LocationTaskCell.self)", for: indexPath) as! LocationTaskCell
            cell.configure(with: model)
            cell.delegate = locationTaskDelegate
            cell.selectionStyle = .none
            return cell
        }
        
    }
}

extension MainScreenAdapter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
