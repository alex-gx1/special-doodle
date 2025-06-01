import Foundation
import Storage
import UIKit
import SnapKit

final class MainScreenVC: UIViewController, LocationTaskCellDelegate, TimerTaskCellDelegate, DateTaskCellDelegate {
    
    func dateTaskCellDidTapAction(_ cell: DateTaskCell) {
        guard let indexPath = tableView.indexPath(for: cell),
              let model = viewModel.model(at: indexPath.row),
              case .date(let dateModel) = model else {
            return
        }
        
        let rect = cell.actionButton.bounds
        viewModel.presentMenuPopover(
            from: cell.actionButton,
            sourceRect: rect,
            forItemId: dateModel.identifier,
            deleteHandler: { [weak self] in
                self?.confirmAndDeleteDate(withId: dateModel.identifier, at: indexPath)
            },
            completeHandler: { [weak self] in
                self?.completeDateTask(withId: dateModel.identifier, at: indexPath)
            }
        )
    }
    
    private func completeDateTask(withId id: String, at indexPath: IndexPath) {
        viewModel.completeDateNotification(withId: id) { [weak self] success in
            if !success {
                self?.showErrorAlert(message: "Не удалось отметить задачу как выполненную")
            }
        }
    }
    
    private func confirmAndDeleteDate(withId id: String, at indexPath: IndexPath) {
        let alert = UIAlertController(
            title: "Удаление",
            message: "Вы уверены, что хотите удалить эту задачу?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            self?.viewModel.deleteDateNotification(withId: id) { success in
                if !success {
                    self?.showErrorAlert(message: "Не удалось удалить задачу")
                }
            }
        })
        present(alert, animated: true)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func timerTaskCellDidTapAction(_ cell: TimerTaskCell) {
        guard let indexPath = tableView.indexPath(for: cell),
              let model = viewModel.model(at: indexPath.row),
              case .timer(let timerModel) = model else {
            return
        }
        
        let rect = cell.actionButton.bounds
        viewModel.presentMenuPopover(
            from: cell.actionButton,
            sourceRect: rect,
            forItemId: timerModel.identifier,
            deleteHandler: { [weak self] in
                self?.confirmAndDeleteTimer(withId: timerModel.identifier, at: indexPath)
            },
            completeHandler: { [weak self] in
                self?.completeTimerTask(withId: timerModel.identifier, at: indexPath)
            }
        )
    }
    
    private func completeTimerTask(withId id: String, at indexPath: IndexPath) {
        viewModel.completeTimerNotification(withId: id) { [weak self] success in
            if !success {
                self?.showErrorAlert(message: "Не удалось отметить таймер как выполненный")
            }
        }
    }
    
    func locationTaskCellDidTapAction(_ cell: LocationTaskCell) {
        guard let indexPath = tableView.indexPath(for: cell),
              let model = viewModel.model(at: indexPath.row),
              case .location(let locationModel) = model else {
            return
        }
        
        let rect = cell.actionButton.bounds
        viewModel.presentMenuPopover(
            from: cell.actionButton,
            sourceRect: rect,
            forItemId: locationModel.identifier,
            deleteHandler: { [weak self] in
                self?.confirmAndDeleteLocation(withId: locationModel.identifier, at: indexPath)
            },
            completeHandler: { [weak self] in
                self?.completeLocationTask(withId: locationModel.identifier, at: indexPath)
            }
            
        )
    }
    
    private func completeLocationTask(withId id: String, at indexPath: IndexPath) {
        viewModel.completeLocationNotification(withId: id) { [weak self] success in
            if !success {
                self?.showErrorAlert(message: "Не удалось отметить таймер как выполненный")
            }
        }
    }
    
    private func confirmAndDeleteTimer(withId id: String, at indexPath: IndexPath) {
        let alert = UIAlertController(
            title: "Удаление",
            message: "Вы уверены, что хотите удалить этот таймер?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            self?.viewModel.deleteTimerNotification(withId: id) { success in
                if !success {
                    self?.showErrorAlert(message: "Не удалось удалить таймер")
                }
            }
        })
        present(alert, animated: true)
    }
    
    private func confirmAndDeleteLocation(withId id: String, at indexPath: IndexPath) {
        let alert = UIAlertController(
            title: "Удаление",
            message: "Вы уверены, что хотите удалить эту локацию?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            self?.viewModel.deleteLocationNotification(withId: id) { success in
                if !success {
                    self?.showErrorAlert(message: "Не удалось удалить локацию")
                }
            }
        })
        present(alert, animated: true)
    }
    
    private var viewModel: MainScreenViewModelProtocol
    
    private let tableView = UITableView()
    private lazy var adapter = MainScreenAdapter(tableView: tableView)
    
    private var selectedIndex: Int = 0
    
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
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FilterCell.self, forCellWithReuseIdentifier: FilterCell.identifier)
        return collectionView
    }()
    
    private lazy var sortButton: UIButton = {
        let button = UIButton()
        button.setImage(Images.sortButton, for: .normal)
        return button
    }()
    
    private lazy var topStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [collectionView, sortButton])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.didSelectFilter(.all)
        adapter.locationTaskDelegate = self
        adapter.timerTaskDelegate = self
        adapter.dateTaskDelegate = self
    }
    
    private func bindViewModel() {
        viewModel.resetData = { [weak self] in
            self?.adapter.resetData()
        }
        
        viewModel.tasksDidUpdate = { [weak self] models in
            self?.adapter.update(with: models)
        }
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
        
        globalCardView.addSubview(topStackView)
        
        topStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview()
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        globalCardView.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topStackView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
}

extension MainScreenVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FilterItem.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCell.identifier, for: indexPath) as! FilterCell
        let item = FilterItem.allCases[indexPath.row]
        cell.setup(item, isSelected: indexPath.row == selectedIndex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        collectionView.reloadData()
        
        let selectedFilter = FilterItem.allCases[indexPath.row]
        viewModel.didSelectFilter(selectedFilter)
    }
}

extension MainScreenVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = FilterItem.allCases[indexPath.row]
        let width = item.rawValue.size(withAttributes: [.font: UIFont.systemFont(ofSize: 14, weight: .medium)]).width + 24
        return CGSize(width: width, height: 32)
    }
}

extension MainScreenVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
