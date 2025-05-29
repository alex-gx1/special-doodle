import Foundation
import Storage
import UIKit
import SnapKit

protocol MainScreenViewModelProtocol {
    func loadTimerTasks()
    func loadDateTasks()
    var tasksDidUpdate: (([NotificationModel]) -> Void)? { get set }
    var resetData: (() -> Void)? { get set }
    func didSelectFilter(_ filter: FilterItem)
    func model(at index: Int) -> NotificationModel?
    func presentMenuPopover(from source: UIView, sourceRect: CGRect)
}

final class MainScreenVC: UIViewController, LocationTaskCellDelegate, TimerTaskCellDelegate, DateTaskCellDelegate {
    
    func dateTaskCellDidTapAction(_ cell: DateTaskCell) {
        guard let indexPath = tableView.indexPath(for: cell),
              let model = viewModel.model(at: indexPath.row),
              case .date(let dateModel) = model else {
            return
        }

        let rect = cell.actionButton.bounds
        viewModel.presentMenuPopover(from: cell.actionButton, sourceRect: rect)
    }
    
    func timerTaskCellDidTapAction(_ cell: TimerTaskCell) {
        guard let indexPath = tableView.indexPath(for: cell),
              let model = viewModel.model(at: indexPath.row),
              case .timer(let timerModel) = model else {
            return
        }

        let rect = cell.actionButton.bounds
        viewModel.presentMenuPopover(from: cell.actionButton, sourceRect: rect)
    }
    
    func locationTaskCellDidTapAction(_ cell: LocationTaskCell) {
        guard let indexPath = tableView.indexPath(for: cell),
              let model = viewModel.model(at: indexPath.row),
              case .location(let locationModel) = model else {
            return
        }

        let rect = cell.actionButton.bounds
        viewModel.presentMenuPopover(from: cell.actionButton, sourceRect: rect)
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
        return .none // чтобы popover не превращался в fullscreen на iPhone
    }
}
