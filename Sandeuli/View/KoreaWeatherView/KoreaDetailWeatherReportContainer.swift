//
//  KoreaDetailWeatherReportContainer.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/25.
//

import UIKit
import SnapKit

final class KoreaDetailWeatherReportContainer: UIView {

    // MARK: - UI Components
    let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Medium", size: 15)
        return label
    }()
    
    let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Medium", size: 15)
        return label
    }()
    
    // MARK: - StackView
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [locationLabel, weatherImageView, temperatureLabel])
        stack.axis = .vertical
        stack.spacing = 4
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

extension KoreaDetailWeatherReportContainer: ViewDrawable {
    func configureUI() {
        setAutolayout()
    }
    
    func setAutolayout() {
        [stackView].forEach { addSubview($0) }
        
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
