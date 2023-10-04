//
//  SearchResultViewController.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/06.
//

import UIKit
import Combine
import SnapKit
import CombineCocoa
import CombineReactor
import CoreLocation
import WeatherKit

protocol CellTappedDelegate: AnyObject {
    func cellIsTapped(searchResultWeather: SearchResultWeather)
}

final class SearchResultViewController: UIViewController, View {
    // MARK: - Cancellables
    var cancellables: Set<AnyCancellable> = []
    
    // MARK: - ViewModel
    let searchResultViewModel = SearchResultViewModel()
    
    // MARK: - DidSetCallCount
    private var putDatasMethodDidSetCallCount = Int()
    
    // MARK: - 테이블 뷰에 쓰일 데이터
    var userLocation = String()
    var currentSkyStatus = String()
    var symbolName = String() {
        didSet {
            putDatasMethodDidSetCallCount += 1
           
            if putDatasMethodDidSetCallCount == 1 {
                putDatasIntoSearchResultArray(userLocation: userLocation, currentSky: currentSkyStatus, currentTemperature: currentTemperature, symbolName: symbolName, highestTemperature: highestTemperature, lowestTemperature: lowestTemperature)
            }
        }
    }
    var currentTemperature = String()
    var highestTemperature = String()
    var lowestTemperature = String()
    
    // MARK: - TableView에 들어갈 Array
    // 먼저, WeatherKit을 통해서 값을 먼저 받은 후에, 해당 값이 SearchResultViewController의 변수에 다 담긴 것이 확인되면, 이 변수를 사용해야 한다.
    lazy var searchResultWeatherArray: [SearchResultWeather] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - UI Components
    private lazy var searchController: UISearchController = {
        let searchResult = UISearchController(searchResultsController: CountryInformationController())
        searchResult.searchResultsUpdater = self
        searchResult.searchBar.autocapitalizationType = .none
        searchResult.searchBar.searchTextField.borderStyle = .none
        searchResult.searchBar.searchTextField.layer.cornerRadius = 10
        searchResult.searchBar.searchTextField.backgroundColor = .white
        searchResult.searchBar.placeholder = "지역을 입력해주세요"
        return searchResult
    }()
 
    private let backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "Back"
        button.tintColor = .white
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.identifier)
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = .searchControllerColor
        return table
    }()
    
    // MARK: - CoreLocation
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reactor = SearchResultViewModel()
        configureUI()
    }
    
    // MARK: - Objc
    @objc private func handleWeatherInfo(_ notification: NSNotification) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension SearchResultViewController: Bindable {
    func bind(reactor: SearchResultViewModel) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    func bindAction(_ reactor: Reactor) {
        backButton.tapPublisher
            .eraseToAnyPublisher()
            .map { SearchResultViewModel.Action.backButtonTapped }
            .subscribe(reactor.action)
            .store(in: &cancellables)
    }
    
    func bindState(_ reactor: Reactor) {
        reactor.state
            .map { $0.backButtonIsTapped }
            .removeDuplicates()
            .map { $0 }
            .sink { [weak self] value in
                if value {
                    self?.dismiss(animated: true)
                }
            }
            .store(in: &cancellables)
    }
}

extension SearchResultViewController: ViewDrawable {
    func configureUI() {
        view.backgroundColor = .searchControllerColor
        setLocationManager()
        setTableViewData()
        setAutolayout()
        setNavigationBar()
        // 1. 앱이 단 한 번 켜지자마자 테이블 뷰 데이터가 변수에 할당되게 된다.
    }
    
    func setAutolayout() {
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = backButton
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.top.equalTo(view.snp.top)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
    
    private func setNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground() 
        appearance.backgroundColor = .searchControllerColor
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.init(name: "Poppins-Semibold", size: 17)!, NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        title = "지역 검색"
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
    }
    
    private func setLocationManager() {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    private func setTableViewData() {
        Publishers.Zip(searchResultViewModel.$currentWeather,
                       searchResultViewModel.$dailyForecast)
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
        searchResultWeatherArray.append(SearchResultWeather(locationName: "현재 위치: \(userLocation)", currentSkyStatus: currentSky, currentTemperature: currentTemperature, image: UIImage(systemName: "\(symbolName).fill") ?? UIImage(), highestTemperature: highestTemperature, lowestTemperature: lowestTemperature))
    }
    
    private func coloringCell(image: UIImage, cell: SearchResultCell, indexPath: IndexPath, currentWeather: CurrentWeather) {
        // 낮이라면
        if currentWeather.isDaylight {
            switch image {
            case UIImage(systemName: "sun.max.fill") ?? UIImage():
                cell.backgroundColor = .dayBackground
                cell.userLocation.textColor = .dayMainLabel
                cell.currentSkyStatus.textColor = .daySideLabel
                cell.currentTemperature.textColor = .dayMainLabel
                cell.highestTemperature.textColor = .daySideLabel
                cell.lowestTemperature.textColor = .daySideLabel
                searchResultWeatherArray[indexPath.row].image = UIImage(systemName: "sun.max.fill")?.withRenderingMode(.alwaysOriginal) ?? UIImage()
                
            case UIImage(systemName: "sun.min.fill") ?? UIImage():
                cell.backgroundColor = .dayBackground
                cell.userLocation.textColor = .dayMainLabel
                cell.currentSkyStatus.textColor = .daySideLabel
                cell.currentTemperature.textColor = .dayMainLabel
                cell.highestTemperature.textColor = .daySideLabel
                cell.lowestTemperature.textColor = .daySideLabel
                searchResultWeatherArray[indexPath.row].image = UIImage(systemName: "sun.min.fill")?.withRenderingMode(.alwaysOriginal) ?? UIImage()
                
            case UIImage(systemName: "cloud.fill") ?? UIImage():
                cell.backgroundColor = .cloudyBackground
                cell.userLocation.textColor = .cloudyMainLabel
                cell.currentSkyStatus.textColor = .cloudySideLabel
                cell.currentTemperature.textColor = .cloudyMainLabel
                cell.highestTemperature.textColor = .cloudySideLabel
                cell.lowestTemperature.textColor = .cloudySideLabel
                searchResultWeatherArray[indexPath.row].image = UIImage(systemName: "cloud.fill")?.applyingSymbolConfiguration(.init(paletteColors: [.cloudyImage])) ?? UIImage()
                
            case UIImage(systemName: "cloud.sun.fill") ?? UIImage():
                cell.backgroundColor = .cloudyBackground
                cell.userLocation.textColor = .cloudyMainLabel
                cell.currentSkyStatus.textColor = .cloudySideLabel
                cell.currentTemperature.textColor = .cloudyMainLabel
                cell.highestTemperature.textColor = .cloudySideLabel
                cell.lowestTemperature.textColor = .cloudySideLabel
                searchResultWeatherArray[indexPath.row].image = UIImage(systemName: "cloud.sun.fill")?.applyingSymbolConfiguration(.init(paletteColors: [.cloudyImage, .dayImage])) ?? UIImage()
                
            case UIImage(systemName: "cloud.drizzle.fill")?.withRenderingMode(.alwaysOriginal) ?? UIImage():
                cell.backgroundColor = .rainyBackground
                cell.userLocation.textColor = .rainyMainLabel
                cell.currentSkyStatus.textColor = .rainySideLabel
                cell.currentTemperature.textColor = .rainyMainLabel
                cell.highestTemperature.textColor = .rainySideLabel
                cell.lowestTemperature.textColor = .rainySideLabel
                searchResultWeatherArray[indexPath.row].image = UIImage(systemName: "cloud.drizzle.fill")?.applyingSymbolConfiguration(.init(paletteColors: [.rainyImage, .systemCyan])) ?? UIImage()
                
            case UIImage(systemName: "cloud.rain.fill")?.withRenderingMode(.alwaysOriginal) ?? UIImage():
                cell.backgroundColor = .rainyBackground
                cell.userLocation.textColor = .rainyMainLabel
                cell.currentSkyStatus.textColor = .rainySideLabel
                cell.currentTemperature.textColor = .rainyMainLabel
                cell.highestTemperature.textColor = .rainySideLabel
                cell.lowestTemperature.textColor = .rainySideLabel
                searchResultWeatherArray[indexPath.row].image = UIImage(systemName: "cloud.rain.fill")?.applyingSymbolConfiguration(.init(paletteColors: [.rainyImage, .systemCyan])) ?? UIImage()
                
            case UIImage(systemName: "cloud.bolt.rain.fill")?.withRenderingMode(.alwaysOriginal) ?? UIImage():
                cell.backgroundColor = .rainyBackground
                cell.userLocation.textColor = .rainyMainLabel
                cell.currentSkyStatus.textColor = .rainySideLabel
                cell.currentTemperature.textColor = .rainyMainLabel
                cell.highestTemperature.textColor = .rainySideLabel
                cell.lowestTemperature.textColor = .rainySideLabel
                searchResultWeatherArray[indexPath.row].image = UIImage(systemName: "cloud.bolt.rain.fill")?.applyingSymbolConfiguration(.init(paletteColors: [.rainyImage, .systemCyan] )) ?? UIImage()
                
            case UIImage(systemName: "cloud.heavyrain.fill")?.withRenderingMode(.alwaysOriginal) ?? UIImage():
                cell.backgroundColor = .rainyBackground
                cell.userLocation.textColor = .rainyMainLabel
                cell.currentSkyStatus.textColor = .rainySideLabel
                cell.currentTemperature.textColor = .rainyMainLabel
                cell.highestTemperature.textColor = .rainySideLabel
                cell.lowestTemperature.textColor = .rainySideLabel
                searchResultWeatherArray[indexPath.row].image = UIImage(systemName: "cloud.heavyrain.fill")?.applyingSymbolConfiguration(.init(paletteColors: [.rainyImage, .systemCyan])) ?? UIImage()
                
            case UIImage(systemName: "cloud.fog.fill")?.withRenderingMode(.alwaysOriginal) ?? UIImage():
                cell.backgroundColor = .foggyBackground
                cell.userLocation.textColor = .foggyMainLabel
                cell.currentSkyStatus.textColor = .foggyMainLabel
                cell.currentTemperature.textColor = .foggyMainLabel
                cell.highestTemperature.textColor = .foggyMainLabel
                cell.lowestTemperature.textColor = .foggyMainLabel
                searchResultWeatherArray[indexPath.row].image = UIImage(systemName: "cloud.fog.fill")?.applyingSymbolConfiguration(.init(paletteColors: [.rainyImage, .systemCyan])) ?? UIImage()
                
            case UIImage(systemName: "snowflake")?.withRenderingMode(.alwaysOriginal) ?? UIImage():
                cell.backgroundColor = .snowyBackground
                cell.userLocation.textColor = .snowyMainLabel
                cell.currentSkyStatus.textColor = .snowySideLabel
                cell.currentTemperature.textColor = .snowyMainLabel
                cell.highestTemperature.textColor = .snowySideLabel
                cell.lowestTemperature.textColor = .snowySideLabel
                searchResultWeatherArray[indexPath.row].image = UIImage(systemName: "snowflake")?.applyingSymbolConfiguration(.init(paletteColors: [.snowyImage])) ?? UIImage()
                
            case UIImage(systemName: "cloud.moon.fill") ?? UIImage():
                cell.backgroundColor = .nightBackground
                cell.userLocation.textColor = .nightMainLabel
                cell.currentSkyStatus.textColor = .nightSideLabel
                cell.currentTemperature.textColor = .nightMainLabel
                cell.highestTemperature.textColor = .nightSideLabel
                cell.lowestTemperature.textColor = .nightSideLabel
                searchResultWeatherArray[indexPath.row].image = UIImage(systemName: "cloud.moon.fill")?.applyingSymbolConfiguration(.init(paletteColors: [.cloudyImage, .nightImage])) ?? UIImage()
                
            case UIImage(systemName: "moon.stars.fill") ?? UIImage():
                cell.backgroundColor = .nightBackground
                cell.userLocation.textColor = .nightMainLabel
                cell.currentSkyStatus.textColor = .nightSideLabel
                cell.currentTemperature.textColor = .nightMainLabel
                cell.highestTemperature.textColor = .nightSideLabel
                cell.lowestTemperature.textColor = .nightSideLabel
                searchResultWeatherArray[indexPath.row].image = UIImage(systemName: "moon.stars.fill")?.applyingSymbolConfiguration(.init(paletteColors: [.nightImage, .white])) ?? UIImage()
                
            case UIImage(systemName: "moon.fill") ?? UIImage():
                cell.backgroundColor = .nightBackground
                cell.userLocation.textColor = .nightMainLabel
                cell.currentSkyStatus.textColor = .nightSideLabel
                cell.currentTemperature.textColor = .nightMainLabel
                cell.highestTemperature.textColor = .nightSideLabel
                cell.lowestTemperature.textColor = .nightSideLabel
                searchResultWeatherArray[indexPath.row].image = UIImage(systemName: "moon.fill")?.applyingSymbolConfiguration(.init(paletteColors: [.nightImage])) ?? UIImage()
                
            default: break
            }
        } else {
        // 밤이라면
            switch image {
            case UIImage(systemName: "sun.max.fill") ?? UIImage():
                cell.backgroundColor = .nightBackground
                cell.userLocation.textColor = .nightMainLabel
                cell.currentSkyStatus.textColor = .nightSideLabel
                cell.currentTemperature.textColor = .nightMainLabel
                cell.highestTemperature.textColor = .nightSideLabel
                cell.lowestTemperature.textColor = .nightSideLabel
                searchResultWeatherArray[indexPath.row].image = UIImage(systemName: "moon.stars.fill")?.applyingSymbolConfiguration(.init(paletteColors: [.nightImage, .white])) ?? UIImage()
                
            case UIImage(systemName: "sun.min.fill") ?? UIImage():
                cell.backgroundColor = .nightBackground
                cell.userLocation.textColor = .nightMainLabel
                cell.currentSkyStatus.textColor = .nightSideLabel
                cell.currentTemperature.textColor = .nightMainLabel
                cell.highestTemperature.textColor = .nightSideLabel
                cell.lowestTemperature.textColor = .nightSideLabel
                searchResultWeatherArray[indexPath.row].image = UIImage(systemName: "moon.stars.fill")?.applyingSymbolConfiguration(.init(paletteColors: [.nightImage, .white])) ?? UIImage()
                
            case UIImage(systemName: "cloud.fill") ?? UIImage():
                cell.backgroundColor = .nightBackground
                cell.userLocation.textColor = .nightMainLabel
                cell.currentSkyStatus.textColor = .nightSideLabel
                cell.currentTemperature.textColor = .nightMainLabel
                cell.highestTemperature.textColor = .nightSideLabel
                cell.lowestTemperature.textColor = .nightSideLabel
                searchResultWeatherArray[indexPath.row].image = UIImage(systemName: "cloud.moon.fill")?.applyingSymbolConfiguration(.init(paletteColors: [.cloudyImage, .nightImage])) ?? UIImage()
                
            case UIImage(systemName: "cloud.sun.fill") ?? UIImage():
                cell.backgroundColor = .nightBackground
                cell.userLocation.textColor = .nightMainLabel
                cell.currentSkyStatus.textColor = .nightSideLabel
                cell.currentTemperature.textColor = .nightMainLabel
                cell.highestTemperature.textColor = .nightSideLabel
                cell.lowestTemperature.textColor = .nightSideLabel
                searchResultWeatherArray[indexPath.row].image = UIImage(systemName: "cloud.moon.fill")?.applyingSymbolConfiguration(.init(paletteColors: [.cloudyImage, .nightImage])) ?? UIImage()
                
            case UIImage(systemName: "cloud.drizzle.fill") ?? UIImage():
                cell.backgroundColor = .nightBackground
                cell.userLocation.textColor = .nightMainLabel
                cell.currentSkyStatus.textColor = .nightSideLabel
                cell.currentTemperature.textColor = .nightMainLabel
                cell.highestTemperature.textColor = .nightSideLabel
                cell.lowestTemperature.textColor = .nightSideLabel
                searchResultWeatherArray[indexPath.row].image = UIImage(systemName: "cloud.moon.rain.fill")?.applyingSymbolConfiguration(.init(paletteColors: [.cloudyImage, .nightImage, .systemCyan])) ?? UIImage()
                
            case UIImage(systemName: "cloud.rain.fill") ?? UIImage():
                cell.backgroundColor = .nightBackground
                cell.userLocation.textColor = .nightMainLabel
                cell.currentSkyStatus.textColor = .nightSideLabel
                cell.currentTemperature.textColor = .nightMainLabel
                cell.highestTemperature.textColor = .nightSideLabel
                cell.lowestTemperature.textColor = .nightSideLabel
                searchResultWeatherArray[indexPath.row].image = UIImage(systemName: "cloud.moon.rain.fill")?.applyingSymbolConfiguration(.init(paletteColors: [.cloudyImage, .nightImage, .systemCyan])) ?? UIImage()
                
            case UIImage(systemName: "cloud.bolt.rain.fill") ?? UIImage():
                cell.backgroundColor = .nightBackground
                cell.userLocation.textColor = .nightMainLabel
                cell.currentSkyStatus.textColor = .nightSideLabel
                cell.currentTemperature.textColor = .nightMainLabel
                cell.highestTemperature.textColor = .nightSideLabel
                cell.lowestTemperature.textColor = .nightSideLabel
                searchResultWeatherArray[indexPath.row].image = UIImage(systemName: "cloud.moon.bolt.fill")?.applyingSymbolConfiguration(.init(paletteColors: [.cloudyImage, .nightImage])) ?? UIImage()
                
            case UIImage(systemName: "cloud.heavyrain.fill") ?? UIImage():
                cell.backgroundColor = .nightBackground
                cell.userLocation.textColor = .nightMainLabel
                cell.currentSkyStatus.textColor = .nightSideLabel
                cell.currentTemperature.textColor = .nightMainLabel
                cell.highestTemperature.textColor = .nightSideLabel
                cell.lowestTemperature.textColor = .nightSideLabel
                searchResultWeatherArray[indexPath.row].image = UIImage(systemName: "cloud.moon.rain.fill")?.applyingSymbolConfiguration(.init(paletteColors: [.cloudyImage, .nightImage, .systemCyan])) ?? UIImage()
                
            case UIImage(systemName: "cloud.fog.fill") ?? UIImage():
                cell.backgroundColor = .nightBackground
                cell.userLocation.textColor = .nightMainLabel
                cell.currentSkyStatus.textColor = .nightSideLabel
                cell.currentTemperature.textColor = .nightMainLabel
                cell.highestTemperature.textColor = .nightSideLabel
                cell.lowestTemperature.textColor = .nightSideLabel
                searchResultWeatherArray[indexPath.row].image = UIImage(systemName: "cloud.moon.fill")?.applyingSymbolConfiguration(.init(paletteColors: [.cloudyImage, .nightImage])) ?? UIImage()
                
            case UIImage(systemName: "snowflake") ?? UIImage():
                cell.backgroundColor = .nightBackground
                cell.userLocation.textColor = .nightMainLabel
                cell.currentSkyStatus.textColor = .nightSideLabel
                cell.currentTemperature.textColor = .nightMainLabel
                cell.highestTemperature.textColor = .nightSideLabel
                cell.lowestTemperature.textColor = .nightSideLabel
                searchResultWeatherArray[indexPath.row].image = UIImage(systemName: "snowflake")?.applyingSymbolConfiguration(.init(paletteColors: [.white])) ?? UIImage()
                
            case UIImage(systemName: "cloud.moon.fill") ?? UIImage():
                cell.backgroundColor = .nightBackground
                cell.userLocation.textColor = .nightMainLabel
                cell.currentSkyStatus.textColor = .nightSideLabel
                cell.currentTemperature.textColor = .nightMainLabel
                cell.highestTemperature.textColor = .nightSideLabel
                cell.lowestTemperature.textColor = .nightSideLabel
                searchResultWeatherArray[indexPath.row].image = UIImage(systemName: "cloud.moon.fill")?.applyingSymbolConfiguration(.init(paletteColors: [.cloudyImage, .nightImage])) ?? UIImage()
                
            case UIImage(systemName: "moon.stars.fill") ?? UIImage():
                cell.backgroundColor = .nightBackground
                cell.userLocation.textColor = .nightMainLabel
                cell.currentSkyStatus.textColor = .nightSideLabel
                cell.currentTemperature.textColor = .nightMainLabel
                cell.highestTemperature.textColor = .nightSideLabel
                cell.lowestTemperature.textColor = .nightSideLabel
                searchResultWeatherArray[indexPath.row].image = UIImage(systemName: "moon.stars.fill")?.applyingSymbolConfiguration(.init(paletteColors: [.nightImage, .white])) ?? UIImage()
                
            case UIImage(systemName: "moon.fill") ?? UIImage():
                cell.backgroundColor = .nightBackground
                cell.userLocation.textColor = .nightMainLabel
                cell.currentSkyStatus.textColor = .nightSideLabel
                cell.currentTemperature.textColor = .nightMainLabel
                cell.highestTemperature.textColor = .nightSideLabel
                cell.lowestTemperature.textColor = .nightSideLabel
                searchResultWeatherArray[indexPath.row].image = UIImage(systemName: "moon.fill")?.applyingSymbolConfiguration(.init(paletteColors: [.nightImage])) ?? UIImage()
                
            default: break
            }
        }
    }
}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("SearchResultController의 테이블 뷰 개수는 \(searchResultWeatherArray.count)")
        return searchResultWeatherArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.identifier, for: indexPath) as! SearchResultCell
        
        cell.userLocation.text = searchResultWeatherArray[indexPath.row].locationName
        cell.currentSkyStatus.text = searchResultWeatherArray[indexPath.row].currentSkyStatus
        cell.weatherImage.image = searchResultWeatherArray[indexPath.row].image
        cell.currentTemperature.text = searchResultWeatherArray[indexPath.row].currentTemperature
        cell.highestTemperature.text = searchResultWeatherArray[indexPath.row].highestTemperature
        cell.lowestTemperature.text = searchResultWeatherArray[indexPath.row].lowestTemperature
        
        coloringCell(image: searchResultWeatherArray[indexPath.row].image, cell: cell, indexPath: indexPath, currentWeather: searchResultViewModel.currentWeather)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension SearchResultViewController: UISearchResultsUpdating {
    // 유저가 글자를 입력하는 순간마다 호출되는 메서드 ===> 일반적으로 다른 화면을 보여줄때 구현
    func updateSearchResults(for searchController: UISearchController) {
        print("서치바에 입력되는 단어", searchController.searchBar.text ?? "")
        let vc = searchController.searchResultsController as! CountryInformationController
        vc.delegate = self
        vc.searchTerm = searchController.searchBar.text ?? ""
    }
}

extension SearchResultViewController: CLLocationManagerDelegate {
    
    // 위도, 경도 정보를 얻는 메소드
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 가장 최근의 위치를 업데이트
        guard let location = locations.first else { return }
        
        // 최근 업데이트 된 위치의 위도와 경도를 설정
        let latitude = location.coordinate.latitude
        let longtitude = location.coordinate.longitude
        
        let myLocation = CLLocation(latitude: latitude, longitude: longtitude)
        myLocation.placemark { placemark, error in
            guard let placemark = placemark else {
                print("Error:", error ?? "nil")
                return
            }
            self.userLocation = placemark.city ?? String()
        }
        locationManager.stopUpdatingLocation()
        // MARK: - WeatherKit 실행
        searchResultViewModel.fetchWeather(location: location)
    }
}

extension SearchResultViewController: CellTappedDelegate {
    func cellIsTapped(searchResultWeather: SearchResultWeather) {
        searchResultWeatherArray.append(searchResultWeather)
    }
}
