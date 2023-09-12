//
//  MainInformationView.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/06.
//

import UIKit
import SnapKit

class MainInformationView: UIView {
    // MARK: - Page Control
    let pageControl: UIPageControl = {
        let page = UIPageControl()
        page.numberOfPages = 3
        page.backgroundColor = .searchControllerWhite
        page.pageIndicatorTintColor = .pageIndicatorGray
        page.currentPageIndicatorTintColor = .currentPageIndicatorDarkBlue
        page.layer.cornerRadius = 5
        return page
    }()
 
    // MARK: - 현재 날씨 이미지
    let todayWeatherImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    // MARK: - 현재 온도
    let todayWeatherTemperature: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Medium", size: 60.0)
        label.text = "--"
        label.textColor = .dayImage
        return label
    }()
    
    let celsiusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Medium", size: 35)
        label.text = "°"
        label.textColor = .dayImage
        return label
    }()

    // MARK: - 현재 지역과 날씨 상태
    lazy var currentLocation: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Semibold", size: 24)
        label.text = "--, "
        label.textColor = .dayImage
        return label
    }()
    
    let currentSky: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.font = UIFont(name: "Poppins-Semibold", size: 24)
        label.textColor = .dayImage
        return label
    }()
    
    // MARK: - 미세 & 초미세
    let particulateMatter: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Semibold", size: 18)
        label.text = "미세: --"
        label.textColor = .daySideLabel
        return label
    }()

    let ultraParticulateMatter: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Semibold", size: 18)
        label.text = "초미세: --"
        label.textColor = .daySideLabel
        return label
    }()
    
    // MARK: - 최고 온도 & 최저 온도
    lazy var highestCelsius: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Semibold", size: 18)
        label.text = "최고: --"
        label.textColor = .daySideLabel
        return label
    }()
    
    lazy var lowestCelsius: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Semibold", size: 18)
        label.text = "최저: --"
        label.textColor = .daySideLabel
        return label
    }()
 
    // MARK: - 일출, 일몰 시간
    let sunrise: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Semibold", size: 18)
        label.text = "일출: --"
        label.textColor = .daySideLabel
        return label
    }()

    let sunset: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Semibold", size: 18)
        label.text = "일몰: --"
        label.textColor = .daySideLabel
        return label
    }()

    // MARK: - StackView
    // 현재 위치와 현재 날씨 상태를
    lazy var currentStatus: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [currentLocation, currentSky])
        stack.axis = .horizontal
        stack.spacing = 4
        return stack
    }()
   
    // 최고 & 최저 기온 스택 뷰
    lazy var highLowCelciusStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [highestCelsius, lowestCelsius])
        stack.axis = .horizontal
        stack.spacing = 20
        stack.distribution = .fillEqually
        return stack
    }()

    // 일출 & 일몰을 알려주는 스택 뷰
    lazy var sunriseAndSunsetStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [sunrise, sunset])
        stack.axis = .horizontal
        stack.spacing = 20
        stack.distribution = .fillEqually
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

extension MainInformationView: ViewDrawable {
    func configureUI() {
        setAutolayout()
    }
    
    func setAutolayout() {
        [pageControl, todayWeatherImage, todayWeatherTemperature, celsiusLabel, currentStatus, highLowCelciusStackView, sunriseAndSunsetStackView].forEach { addSubview($0) }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.snp.top).offset(20)
        }
        
        todayWeatherImage.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(50)
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(118)
            make.width.equalTo(125)
        }
       
        todayWeatherTemperature.snp.makeConstraints { make in
            make.top.equalTo(todayWeatherImage.snp.bottom).offset(20)
            make.centerX.equalTo(self.snp.centerX)
        }
     
        celsiusLabel.snp.makeConstraints { make in
            make.leading.equalTo(todayWeatherTemperature.snp.trailing)
            make.top.equalTo(todayWeatherImage.snp.bottom).offset(15)
        }
    
        currentStatus.snp.makeConstraints { make in
            make.top.equalTo(todayWeatherTemperature.snp.bottom).offset(5)
            make.centerX.equalTo(self.snp.centerX)
        }
   
        highLowCelciusStackView.snp.makeConstraints { make in
            make.top.equalTo(currentStatus.snp.bottom).offset(40)
            make.centerX.equalTo(self.snp.centerX)
        }
  
        sunriseAndSunsetStackView.snp.makeConstraints { make in
            make.top.equalTo(highLowCelciusStackView.snp.bottom).offset(5)
            make.centerX.equalTo(self.snp.centerX)
        }
    }
}
