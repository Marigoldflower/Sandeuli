//
//  LocationResultController.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/26.
//

import UIKit
import SnapKit
import Combine
import CoreLocation
import WeatherKit

final class CountryInformationController: UIViewController {
    // MARK: - Cancellables
    var cancellables: Set<AnyCancellable> = []
    
    // MARK: - ViewModel
    private let countryInformationViewModel = CountryInformationViewModel()
    
    // MARK: - Delegate
    weak var delegate: CellTappedDelegate?
    
    // MARK: - DidSetCallCount
    private var putDatasMethodDidSetCallCount = Int()
    
    // MARK: - 사용자의 검색 지역을 네트워크 처리할 코드
    var searchTerm = String() {
        didSet {
            setCountryInformationData(regionName: searchTerm)
        }
    }
    
    // MARK: - Notification Name
    let newLocation: Notification.Name = Notification.Name("newLocation")
    
    // MARK: - ViewModel로부터 받은 데이터를 저장할 변수 (테이블 뷰를 그릴 때 사용됨)
    private var countryInformation: CountryInformation = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - CoreLocation
    let locationManager = CLLocationManager()
    
    // MARK: - 이전 화면
    var searchResultViewController: SearchResultViewController! = nil
    
    // MARK: - GeoCoder
    let geoCoder = CLGeocoder()
    private var selectedCellLocation = CLLocation(latitude: Double(), longitude: Double()) {
        didSet {
            
            countryInformationViewModel.fetchWeather(location: selectedCellLocation)
            geoCoder.reverseGeocodeLocation(selectedCellLocation) { [weak self] placemark, error in
                if let error = error {
                    print("Error fetching address: \(error)")
                    return
                }
                
                if let placemark = placemark?.first {
                    guard let userLocation = placemark.locality else { return }
                    self?.userLocation = userLocation
                }
            }
            setTableViewData()
        }
    }
    
    // MARK: - 테이블 뷰에 사용될 변수값들
    var userLocation = String() {
        didSet {
            print("Country의 userLocation값은 \(userLocation)")
        }
    }
    var currentSkyStatus = String() {
        didSet {
            print("Country의 currentSkyStatus값은 \(currentSkyStatus)")
        }
    }
    var symbolName = String() {
        didSet {
            print("Country의 symbolName값은 \(symbolName)")
            
            putDatasMethodDidSetCallCount += 1
            
            if putDatasMethodDidSetCallCount == 1 {
                putDatasIntoSearchResultArray(userLocation: userLocation, currentSky: currentSkyStatus, currentTemperature: currentTemperature, symbolName: symbolName, highestTemperature: highestTemperature, lowestTemperature: lowestTemperature)
            }
        }
    }
    var currentTemperature = String() {
        didSet {
            print("Country의 currentTemperature값은 \(currentTemperature)")
        }
    }
    var highestTemperature = String() {
        didSet {
            print("Country의 highestTemperature값은 \(highestTemperature)")
        }
    }
    var lowestTemperature = String() {
        didSet {
            print("Country의 lowestTemperature값은 \(lowestTemperature)")
        }
    }
    
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(CountryInformationCell.self, forCellReuseIdentifier: CountryInformationCell.identifier)
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = .searchControllerColor
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func setCountryInformationData(regionName: String) {
        countryInformationViewModel.fetchCountryInformationNetwork(regionName: regionName)
        countryInformationViewModel.$countryInformation
            .receive(on: DispatchQueue.main)
            .sink { [weak self] countryInformation in
                self?.countryInformation = countryInformation
            }
            .store(in: &self.cancellables)
    }
}

extension CountryInformationController: ViewDrawable {
    func configureUI() {
        view.backgroundColor = .searchControllerColor
        setAutolayout()
    }
    
    func setAutolayout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.top.equalTo(view.snp.top)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
    
    private func setTableViewData() {
        Publishers.Zip(countryInformationViewModel.$currentWeather,
                       countryInformationViewModel.$dailyForecast)
        .receive(on: DispatchQueue.main)
        .sink { [weak self] currentWeather, dailyForecast in
            guard let currentWeather = currentWeather else { return }
            
            self?.currentTemperature = String(round(currentWeather.temperature.value * 10) / 10) + "°"
            self?.currentSkyStatus = currentWeather.condition.description
            self?.symbolName = currentWeather.symbolName
            self?.highestTemperature = String(round(dailyForecast[0].highTemperature.value * 10) / 10 ) + "°"
            self?.lowestTemperature = String(round(dailyForecast[0].lowTemperature.value * 10) / 10 ) + "°"
        }
        .store(in: &cancellables)
    }
    
    private func putDatasIntoSearchResultArray(userLocation: String, currentSky: String, currentTemperature: String, symbolName: String, highestTemperature: String, lowestTemperature: String) {
        let newLocation = SearchResultWeather(locationName: userLocation, currentSkyStatus: currentSky, currentTemperature: currentTemperature, image: UIImage(systemName: "\(symbolName).fill") ?? UIImage(), highestTemperature: highestTemperature, lowestTemperature: lowestTemperature)
        delegate?.cellIsTapped(searchResultWeather: newLocation)
        putDatasMethodDidSetCallCount = 0
        self.dismiss(animated: true)
    }
}

extension CountryInformationController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryInformation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CountryInformationCell.identifier, for: indexPath) as! CountryInformationCell
        
        cell.regionName.text = countryInformation[indexPath.row].displayName
        cell.backgroundColor = .searchControllerColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let lat = countryInformation[indexPath.row].lat else { return }
        guard let long = countryInformation[indexPath.row].lon else { return }
        
        guard let latitude = Double(lat) else { return }
        guard let longitude = Double(long) else { return }
        
        // 일단 latitude와 longitude는 한 개씩 가므로 여기서 발생하는 문제는 아닌 듯하다.
        print("탭한 셀의 latitude는 \(latitude)")
        print("탭한 셀의 longitude는 \(longitude)")
        
        self.selectedCellLocation = CLLocation(latitude: latitude, longitude: longitude)
    }
}

