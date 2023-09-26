//
//  LocationResultController.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/26.
//

import UIKit
import SnapKit
import Combine

final class CountryInformationController: UIViewController {
    // MARK: - Cancellables
    var cancellables: Set<AnyCancellable> = []
    
    // MARK: - ViewModel
    private let countryInformationViewModel = CountryInformationViewModel()
    
    // MARK: - Delegate
    weak var delegate: CellTappedDelegate?
    
    // MARK: - 검색결과를 처리할 코드
    var searchTerm = String() {
        didSet {
            setCountryInformationData(regionName: searchTerm)
        }
    }
    
    // MARK: - ViewModel로부터 받은 데이터를 저장할 변수
    private var countryInformation: CountryInformation = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
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
        
        guard let locationName = countryInformation[indexPath.row].displayName else { return }
        guard let latitude = countryInformation[indexPath.row].lat else { return }
        guard let longitude = countryInformation[indexPath.row].lon else { return }
        
        delegate?.sendWeatherData(locationName: locationName, latitude: latitude, longitude: longitude)
    }
}
