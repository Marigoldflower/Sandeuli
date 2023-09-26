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

protocol CellTappedDelegate: AnyObject {
    func sendWeatherData(locationName: String, latitude: String, longitude: String)
}

final class SearchResultViewController: UIViewController, View {
    
    var cancellables: Set<AnyCancellable> = []
    
    // MARK: - WeatherController로부터 받아야 할 데이터
    var userLocation = String()
    var currentTemperature = String()
    var highestTemperature = String()
    var lowestTemperature = String()
    var currentSky = String()
    
    
    // MARK: - TableView에 들어갈 Array
    var searchResultWeatherArray: [SearchResultWeather] = [
        SearchResultWeather(locationName: <#T##String#>, image: <#T##UIImage#>, currentTemperature: <#T##String#>, currentSkyStatus: <#T##String#>, highestTemperature: <#T##String#>, lowestTemperature: <#T##String#>)
    ]
    
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
        return table
    }()
    
    // MARK: - CoreLocation
    let locationManger = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reactor = SearchResultViewModel()
        configureUI()
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
        setAutolayout()
        setNavigationBar()
        setLocationManger()
    }
    
    func setAutolayout() {
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = backButton
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
    
    private func setLocationManger() {
        locationManger.delegate = self
        locationManger.startUpdatingLocation()
    }
}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultWeatherArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.identifier, for: indexPath) as! SearchResultCell
        
        cell.backgroundColor = .searchControllerColor
        
        return cell
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

extension SearchResultViewController: CellTappedDelegate {
    func sendWeatherData(locationName: String, latitude: String, longitude: String) {
        
    }
}

extension SearchResultViewController: CLLocationManagerDelegate {
    
    // 위도, 경도 정보를 얻는 메소드
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // 가장 최근 업데이트 된 위치를 설정
        let currentLoaction = locations.first
        
        guard let currentLoaction = currentLoaction else { return }
        
        // 최근 업데이트 된 위치의 위도와 경도를 설정
        let latitude = currentLoaction.coordinate.latitude
        let longtitude = currentLoaction.coordinate.longitude
        print("위도: \(latitude) | 경도: \(longtitude)")
    }
}
