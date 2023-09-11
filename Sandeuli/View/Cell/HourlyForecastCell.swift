//
//  TodayForecastCell.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/07.
//

import UIKit
import SnapKit

final class HourlyForecastCell: UICollectionViewCell {
    
    static let identifier = "TodayForecastCell"
    
    // MARK: - UI Components
    let time: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Medium", size: 17)
        label.textColor = .white
        return label
    }()
    
    let weatherImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let temperature: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Medium", size: 19)
        label.textColor = .white
        return label
    }()
    
    // MARK: - StackView
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [time, weatherImage, temperature])
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .fillEqually
        stack.alignment = .center
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension HourlyForecastCell: ViewDrawable {
    func configureUI() {
        setAutolayout()
    }
    
    func setAutolayout() {
        self.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(20)
            make.trailing.equalTo(self.snp.trailing).offset(-20)
            make.top.equalTo(self.snp.top).offset(10)
            make.bottom.equalTo(self.snp.bottom).offset(-10)
        }
  
        weatherImage.snp.makeConstraints { make in
            make.width.height.equalTo(90)
        }
    }
}

