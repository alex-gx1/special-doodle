import UIKit

final class MainScreenAdapter: NSObject {
    
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
            return cell

        case .date(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(DateTaskCell.self)", for: indexPath) as! DateTaskCell
            cell.configure(with: model, day: model.day, month: model.month)
            return cell
        }
    }
}

extension MainScreenAdapter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        return UITableView.automaticDimension
        return 120
    }
}
