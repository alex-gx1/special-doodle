import UIKit
import MapKit
import SnapKit

protocol FullMapViewModelProtocol {
    func openSearchScreen()
    func closeVC()
    var screenshotImage: Observable<UIImage?> { get }
    func captureScreenshot(from mapView: MKMapView, image: UIImageView, in view: UIView)
    func createAndCloseVC()
}

final class FullMapVC: UIViewController {
    
    private let viewModel: FullMapViewModelProtocol
    
    private var locationManager = CLLocationManager()
    
    init(viewModel: FullMapViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        keyBoardDownTap()
    }
    
    private lazy var locationPointImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.locationPoint
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var globalCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private func keyBoardDownTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
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
        textField.placeholder = "Search"
        textField.borderStyle = .none
        textField.font = .systemFont(ofSize: 16)
        textField.clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(textFieldTapped), for: .editingChanged)
        return textField
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.isRotateEnabled = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        //        if #available(iOS 17.0, *) {
        //            mapView.showsUserTrackingButton = true
        //        } else {
        //            // Fallback on earlier versions
        //        }
        return mapView
    }()
    
    private lazy var searchStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.distribution = .fill
        stack.backgroundColor = .white
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    private lazy var selectButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.backgroundColor = Colors.appYellowColor
        button.setTitleColor(Colors.appBlackColor, for: .normal)
        button.setTitle("Select", for: .normal)
        button.titleLabel?.font = UIFont.appBoldFont17
        button.setTitleColor(Colors.appBlackColor.withAlphaComponent(0.5), for: .highlighted)
        button.setBackgroundColor(Colors.appYellowColor?.withAlphaComponent(0.7), for: .highlighted)
        button.addTarget(self, action: #selector(selectButtonTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButtonBottom: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.layer.borderColor = Colors.appYellowColor?.cgColor
        button.layer.borderWidth = 2.5
        button.backgroundColor = Colors.appBlackColor
        button.setTitleColor(Colors.appYellowColor, for: .normal)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.appBoldFont17
        button.setTitleColor(Colors.appYellowColor?.withAlphaComponent(0.5), for: .highlighted)
        button.setBackgroundColor(Colors.appBlackColor.withAlphaComponent(0.7), for: .highlighted)
        button.addTarget(self, action: #selector(cancelButtonTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var testImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private func setupUI() {
        view.backgroundColor = Colors.appBlackColor
        view.addSubview(globalCardView)
        
        globalCardView.addSubview(mapView)
        globalCardView.addSubview(searchStackView)
        globalCardView.addSubview(selectButton)
        globalCardView.addSubview(cancelButtonBottom)
        globalCardView.addSubview(locationPointImageView)
        
        globalCardView.addSubview(testImageView)
        
        testImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        searchStackView.addArrangedSubview(searchContainer)
        searchStackView.addArrangedSubview(cancelButton)
        
        searchContainer.addSubview(searchIcon)
        searchContainer.addSubview(searchTextField)
        
        globalCardView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        locationPointImageView.snp.makeConstraints { make in
            make.center.equalTo(mapView)
            make.height.equalTo(95)
            make.width.equalTo(95)
        }
        
        searchStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(55)
        }
        
        cancelButton.setContentHuggingPriority(.required, for: .horizontal)
        cancelButton.snp.makeConstraints { make in
            make.height.equalTo(36)
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
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(searchContainer.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        cancelButtonBottom.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(45)
        }
        
        selectButton.snp.makeConstraints { make in
            make.bottom.equalTo(cancelButtonBottom.snp.top).offset(-8)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(45)
        }
    }
    
    @objc private func cancelTapped() {
        dismissKeyboard()
        searchTextField.text = ""
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func textFieldTapped(_ textField: UITextField) {
        //        viewModel.openSearchScreen()
        guard let query = textField.text, !query.isEmpty else { return }
           guard let userLocation = locationManager.location else { return }

           let region = MKCoordinateRegion(center: userLocation.coordinate,
                                           latitudinalMeters: 5000,
                                           longitudinalMeters: 5000)

           let request = MKLocalSearch.Request()
           request.naturalLanguageQuery = query
           request.region = region

           let search = MKLocalSearch(request: request)
           search.start { [weak self] response, error in
               guard
                   let coordinate = response?.mapItems.first?.placemark.coordinate,
                   error == nil
               else { return }

               let resultRegion = MKCoordinateRegion(center: coordinate,
                                                     latitudinalMeters: 1000,
                                                     longitudinalMeters: 1000)
               self?.mapView.setRegion(resultRegion, animated: true)
           }
    }
    
    @objc private func selectButtonTap() {
        let mapRegion = mapView.convert(locationPointImageView.bounds, toRegionFrom: locationPointImageView)
        
        //        let center = CLLocation(latitude: mapRegion.center.latitude,
        //                                longitude: mapRegion.center.longitude)
        //
        //        let top = CLLocation(latitude: mapRegion.center.latitude - mapRegion.span.latitudeDelta / 2,
        //                             longitude: mapRegion.center.longitude)
        //
        //        let radius = center.distance(from: top)
        //
        //        let circleRegion = CLCircularRegion(center: mapRegion.center,
        //                                            radius: radius,
        //                                            identifier: UUID().uuidString)
        mapView.setRegion(mapRegion, animated: true)
        
        viewModel.captureScreenshot(from: mapView, image: locationPointImageView, in: view)
        
        viewModel.createAndCloseVC()
    }
    
    @objc private func cancelButtonTap() {
        viewModel.closeVC()
    }
}
