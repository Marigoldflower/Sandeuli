//
//  SearchResultViewController.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/06.
//

import UIKit
import Combine
import SnapKit

final class SearchResultViewController: UIViewController {

    // MARK: - Cancellables
    var cancellables: Set<AnyCancellable> = []
    
    // MARK: - ViewModel
    private let countryInformationViewModel = CountryInformationViewModel()
    
    // MARK: - 검색 결과 처리할 코드
    var searchTerm = String() {
        didSet {
            setCountryInformationData(regionName: searchTerm)
        }
    }
    
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(CountryInformationCell.self, forCellReuseIdentifier: CountryInformationCell.identifier)
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    // MARK: - ViewModel로부터 받은 데이터를 저장할 변수
    private var countryInformation: CountryInformation = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
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

extension SearchResultViewController: ViewDrawable {
    func configureUI() {
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

extension SearchResultViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("현재 SearchResult의 테이블뷰 개수는 \(countryInformation.count)")
        return countryInformation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CountryInformationCell.identifier, for: indexPath) as! CountryInformationCell
        
        cell.regionName.text = countryInformation[indexPath.row].displayName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
