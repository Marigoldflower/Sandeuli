//
//  DailyForecastCell.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/11.
//

import UIKit
import SnapKit

class DailyForecastCell: UITableViewCell {
    
    static let identifier = "DailyForecastCell"
    
    // MARK: - UI Components
    let weekend: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.font = UIFont(name: "Poppins-Medium", size: 19)
        label.textColor = .white
        return label
    }()

    let weatherImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    let highestTemperature: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.font = UIFont(name: "Poppins-Medium", size: 19)
        label.textColor = .white
        return label
    }()

    let divider: UILabel = {
        let label = UILabel()
        label.text = "|"
        label.font = UIFont(name: "Poppins-Medium", size: 19)
        label.textColor = .white
        return label
    }()
   
    let lowestTemperature: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.font = UIFont(name: "Poppins-Medium", size: 19)
        label.textColor = .white
        return label
    }()
 
    // MARK: - StackView
    lazy var highestLowestTemperature: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [highestTemperature, divider, lowestTemperature])
        stack.axis = .horizontal
        stack.spacing = 15
        stack.distribution = .fill
        return stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension DailyForecastCell: ViewDrawable {
    func configureUI() {
        setAutolayout()
    }
    
    func setAutolayout() {
        [weekend, weatherImage, highestLowestTemperature].forEach { addSubview($0)}
        
        weekend.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(15)
            make.centerY.equalToSuperview()
        }
        
        weatherImage.snp.makeConstraints { make in
            make.leading.equalTo(weekend.snp.trailing).offset(45)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(45)
        }
        
        highestLowestTemperature.snp.makeConstraints { make in
            make.trailing.equalTo(self.snp.trailing).offset(-15)
            make.centerY.equalToSuperview()
        }
    }
}
