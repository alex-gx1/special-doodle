import Foundation
import Storage
import UIKit
import SnapKit

final class MainScreenVC: UIViewController, LocationTaskCellDelegate, TimerTaskCellDelegate, DateTaskCellDelegate, UITextFieldDelegate {
    
    private var viewModel: MainScreenViewModelProtocol
    
    private let tableView = UITableView()
    private lazy var adapter = MainScreenAdapter(tableView: tableView)
    
    private var selectedIndex: Int = 0
    
    private var isSearchVisible = true
    
    private let feedbackGenerator = UISelectionFeedbackGenerator()
    private let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
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
    
    private lazy var searchContainer: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 18
        return view
    }()
    
    private lazy var searchIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.search
        return imageView
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Поиск задач"
        textField.borderStyle = .none
        textField.font = .systemFont(ofSize: 16)
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private func setupSearchTextField() {
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(searchTextChanged(_:)), for: .editingChanged)
        cancelSearchButton.addTarget(self, action: #selector(cancelSearchTapped), for: .touchUpInside)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
        
    private lazy var cancelSearchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отмена", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.isHidden = true
        return button
    }()
    
    private lazy var searchStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.distribution = .fill
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
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
        button.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc private func sortButtonTapped() {
        impactFeedbackGenerator.impactOccurred()
        viewModel.toggleSortOrder()
    }
    
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
        setupNotifications()
        
        searchStackView.isHidden = false
        searchStackView.alpha = 1
        setupKeyboardHidingOnTap()
        setupSearchTextField()
    }
    
    private func setupKeyboardHidingOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func searchTextChanged(_ textField: UITextField) {
        guard let searchText = textField.text?.lowercased(), !searchText.isEmpty else {
            viewModel.clearSearch()
            return
        }
        viewModel.searchTasks(with: searchText)
    }

    @objc private func cancelSearchTapped() {
        searchTextField.text = ""
        searchTextField.resignFirstResponder()
        viewModel.clearSearch()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleTaskCreatedNotification),
            name: .taskCreatedNotification,
            object: nil
        )
    }
    
    @objc private func handleTaskCreatedNotification() {
        selectedIndex = FilterItem.allCases.firstIndex(of: .all) ?? 0
        collectionView.reloadData()
        
        searchStackView.isHidden = false
        searchStackView.alpha = 1
        isSearchVisible = true
        
        tableView.snp.remakeConstraints { make in
            make.top.equalTo(searchStackView.snp.bottom).offset(0)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        
        viewModel.didSelectFilter(.all)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func bindViewModel() {
        viewModel.resetData = { [weak self] in
            self?.adapter.resetData()
        }
        
        viewModel.tasksDidUpdate = { [weak self] models in
            self?.adapter.update(with: models)
        }
    }
    
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
        
        searchStackView.addArrangedSubview(searchContainer)
        searchStackView.addArrangedSubview(cancelSearchButton)
        searchContainer.addSubview(searchIcon)
        searchContainer.addSubview(searchTextField)
        
        globalCardView.addSubview(searchStackView)
        searchStackView.snp.makeConstraints { make in
            make.top.equalTo(topStackView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(55)
        }
        
        searchContainer.snp.makeConstraints { make in
            make.height.equalTo(36)
        }
        
        searchIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.left.equalTo(searchIcon.snp.right).offset(8)
            make.right.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview()
        }
        
        cancelSearchButton.setContentHuggingPriority(.required, for: .horizontal)
        cancelSearchButton.snp.makeConstraints { make in
            make.height.equalTo(36)
        }
        
        globalCardView.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchStackView.snp.bottom).offset(0)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
}

extension MainScreenVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FilterItem.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCell.identifier, for: indexPath) as! FilterCell
        let item = FilterItem.allCases[indexPath.row]
        cell.setup(with: item)
        cell.isSelected = indexPath.row == selectedIndex
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        feedbackGenerator.selectionChanged()
        
        guard selectedIndex != indexPath.row else { return }
        
        let prevIndexPath = IndexPath(item: selectedIndex, section: 0)
        if let prevCell = collectionView.cellForItem(at: prevIndexPath) as? FilterCell {
            prevCell.isSelected = false
        }
        
        if let newCell = collectionView.cellForItem(at: indexPath) as? FilterCell {
            newCell.isSelected = true
        }
        
        selectedIndex = indexPath.row
        
        let selectedFilter = FilterItem.allCases[indexPath.row]
        viewModel.didSelectFilter(selectedFilter)
        
        let shouldShowSearch = selectedFilter == .all
        
        guard shouldShowSearch != isSearchVisible else { return }
        
        UIView.performWithoutAnimation {
            self.searchStackView.isHidden = !shouldShowSearch
            self.searchStackView.alpha = shouldShowSearch ? 1 : 0
            self.view.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: 0.3) {
            if shouldShowSearch {
                self.tableView.snp.remakeConstraints { make in
                    make.top.equalTo(self.searchStackView.snp.bottom).offset(0)
                    make.leading.trailing.equalToSuperview().inset(16)
                    make.bottom.equalToSuperview()
                }
            } else {
                self.tableView.snp.remakeConstraints { make in
                    make.top.equalTo(self.topStackView.snp.bottom).offset(8)
                    make.leading.trailing.equalToSuperview().inset(16)
                    make.bottom.equalToSuperview()
                }
            }
            self.view.layoutIfNeeded()
        }
        
        isSearchVisible = shouldShowSearch
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
