import UIKit

final class MainScreenAdapter: NSObject {
    
    var sections: [MainScreenSections] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var timerTasks: [TimerTaskModel] = []
    var dateTasks: [DateTaskModel] = []
    
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
        sections = []
        timerTasks = []
        dateTasks = []
    }
    
    func update(with input: MainScreenInput) {
        switch input {
        case .timer(let timerTasks):
            self.timerTasks = timerTasks
            if !sections.contains(.Timer) {
                sections.append(.Timer)
            }
        case .date(let dateTasks):
            self.dateTasks = dateTasks
            if !sections.contains(.Date) {
                sections.append(.Date)
            }
        }
        tableView.reloadData()
    }
}

extension MainScreenAdapter: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .Timer:
            return timerTasks.count
        case .Date:
            return dateTasks.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .Timer:
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(TimerTaskCell.self)", for: indexPath) as! TimerTaskCell
            cell.configure(with: timerTasks[indexPath.row])
            return cell
            
        case .Date:
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(DateTaskCell.self)", for: indexPath) as! DateTaskCell
            cell.configure(with: dateTasks[indexPath.row])
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
