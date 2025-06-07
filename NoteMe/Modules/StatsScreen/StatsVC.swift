import UIKit
import DGCharts
import SnapKit

protocol StatsViewModelProtocol {
    func getFirstPieChartData() -> [PieChartDataEntry]
    func getSecondPieChartData() -> [PieChartDataEntry]
}

final class PieChartViewController: UIViewController {
    private let pieChartView = PieChartView()
    private let titleLabel = UILabel()
    private let entries: [PieChartDataEntry]
    
    init(entries: [PieChartDataEntry], title: String) {
        self.entries = entries
        super.init(nibName: nil, bundle: nil)
        self.titleLabel.text = title
        self.titleLabel.font = .appBoldFont17
        self.titleLabel.textColor = Colors.appBlackColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPieChart()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(pieChartView)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        pieChartView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    private func setupPieChart() {
        let dataSet = PieChartDataSet(entries: entries)
        dataSet.colors = [
            Colors.appYellowColor ?? .systemYellow,
            Colors.appGreyColor ?? .systemGray,
            Colors.appRedColor ?? .systemRed
        ]
        dataSet.valueTextColor = Colors.appBlackColor
        dataSet.valueFont = .appFont13
        
        let data = PieChartData(dataSet: dataSet)
        pieChartView.data = data
        pieChartView.animate(yAxisDuration: 1.4)
        pieChartView.rotationEnabled = false
        
        pieChartView.legend.textColor = Colors.appBlackColor
        pieChartView.legend.font = .appFont13
        
        dataSet.label = nil
        let legend = pieChartView.legend
        legend.textColor = Colors.appBlackColor
        legend.font = .appFont13
        legend.horizontalAlignment = .center
        legend.verticalAlignment = .bottom
        legend.orientation = .horizontal
        legend.drawInside = false
        legend.xEntrySpace = 10
        legend.yEntrySpace = 5
        legend.yOffset = 10
        
    }
}

final class StatsVC: UIPageViewController {
    private let viewModel: StatsViewModelProtocol
    private var pages = [UIViewController]()
    
    init(viewModel: StatsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPages()
        configurePageControl()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = Colors.appBlackColor
        navigationItem.title = "Статистика"
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.appBoldFont17,
            .foregroundColor: Colors.appBlackColor
        ]
    }
    
    private func setupPages() {
        let firstChart = PieChartViewController(
            entries: viewModel.getFirstPieChartData(),
            title: "Количество основных задач"
        )
        
        let secondChart = PieChartViewController(
            entries: viewModel.getSecondPieChartData(),
            title: "Продуктивность выполнения"
        )
        
        pages = [firstChart, secondChart]
        
        setViewControllers([pages[0]], direction: .forward, animated: true)
        dataSource = self
    }
    
    private func configurePageControl() {
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = Colors.appGreyColor
        pageControl.currentPageIndicatorTintColor = Colors.appYellowColor
        pageControl.backgroundColor = .clear
    }
}

extension StatsVC: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        return pages[index - 1]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index < pages.count - 1 else {
            return nil
        }
        return pages[index + 1]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
