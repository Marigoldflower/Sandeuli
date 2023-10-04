//
//  SearchResultCollectionCell.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/26.
//

import UIKit
import SnapKit

final class SearchResultCell: UITableViewCell {
    static let identifier = "SearchResultCell"
    
    // MARK: - UI Components
    let userLocation: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-SemiBold", size: 25)
        return label
    }()
    
    let currentSkyStatus: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Medium", size: 16)
        return label
    }()
    
    let weatherImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    let currentTemperature: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-SemiBold", size: 40)
        return label
    }()
    
    let highestTemperature: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Medium", size: 16)
        return label
    }()
    
    let lowestTemperature: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Medium", size: 16)
        return label
    }()
    
    // MARK: - StackView
    private lazy var highAndLowStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [highestTemperature, lowestTemperature])
        stack.axis = .horizontal
        stack.spacing = 5
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

extension SearchResultCell: ViewDrawable {
    func configureUI() {
        setAutolayout()
    }
    
    func setAutolayout() {
        [userLocation, currentSkyStatus, weatherImage, currentTemperature, highAndLowStackView].forEach { addSubview($0) }
        
        userLocation.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading).offset(20)
            make.top.equalTo(snp.top).offset(15)
        }
        
        currentSkyStatus.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading).offset(20)
            make.bottom.equalTo(snp.bottom).offset(-15)
        }
        
        currentTemperature.snp.makeConstraints { make in
            make.trailing.equalTo(snp.trailing).offset(-20)
            make.top.equalTo(snp.top).offset(5)
        }
        
        weatherImage.snp.makeConstraints { make in
            make.width.height.equalTo(45)
            make.trailing.equalTo(currentTemperature.snp.leading).offset(-8)
            make.top.equalTo(snp.top).offset(10)
        }
        
        highAndLowStackView.snp.makeConstraints { make in
            make.trailing.equalTo(snp.trailing).offset(-20)
            make.bottom.equalTo(snp.bottom).offset(-15)
        }
    }
}
