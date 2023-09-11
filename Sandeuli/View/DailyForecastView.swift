//
//  TenDaysForecastView.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/06.
//

import UIKit
import SnapKit

final class DailyForecastView: UIView {
    
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(DailyForecastCell.self, forCellReuseIdentifier: DailyForecastCell.identifier)
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = UIColor.gradientBlue.withAlphaComponent(0.75)
        return table
    }()
    
    // MARK: - Data Components
    var weekDayArray: [String] = [] {
        didSet {
            print("weekDayArray에 들어오는 값은 \(weekDayArray)")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var weatherImageArray: [UIImage] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var highestCelsiusArray: [String] = [] {
        didSet {
            print("highestArray 값이 들어왔습니다 \(highestCelsiusArray)")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var lowestCelsiusArray: [String] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension DailyForecastView: ViewDrawable {
    func configureUI() {
        setAutolayout()
        addGradientToTableView(self.tableView)
    }
    
    func setAutolayout() {
        addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading)
            make.top.equalTo(self.snp.top)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.snp.bottom)
        }
    }
    
    private func addGradientToTableView(_ tableView: UITableView) {

        let gradientContainerView = GradientContainerView(frame: tableView.bounds)
        gradientContainerView.setGradientLayer(colors: [UIColor.gradientBlue.cgColor, UIColor.gradientWhite.cgColor],
                                               startPoint: CGPoint(x: 0, y: 0),
                                               endPoint: CGPoint(x: 1, y: 1))

        tableView.backgroundView = gradientContainerView
    }
}

extension DailyForecastView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekDayArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DailyForecastCell.identifier, for: indexPath) as! DailyForecastCell
        // 셀을 클릭할 때 아무런 색깔의 변화도 없게 만드는 코드
        cell.selectionStyle = .none
        cell.weekend.text = weekDayArray[indexPath.row]
//        cell.weatherImage.image = weatherImageArray[indexPath.row]
//        cell.highestTemperature.text = highestCelsiusArray[indexPath.row]
//        cell.lowestTemperature.text = lowestCelsiusArray[indexPath.row]
        cell.backgroundColor = .clear

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

extension DailyForecastView: UITableViewDelegate {
    
}
