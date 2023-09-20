//
//  Colors.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/06.
//

import UIKit

extension UIColor {
    
    static let seaColor = UIColor(red: 0.18, green: 0.53, blue: 0.78, alpha: 1.00)
    
    // 데이터의 색깔 (밝은 날씨일 때에는 어두운 주황, 어두운 날씨일 때에는 밝은 주황)
    static let dayDataText = UIColor(red: 0.94, green: 0.67, blue: 0.51, alpha: 1.00)
    static let nightDataText = UIColor(red: 1.00, green: 0.80, blue: 0.67, alpha: 1.00)
    
    // MARK: - SearchController
    static let searchControllerWhite = UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.00)
    
    // MARK: - PageControl
    static let pageIndicatorGray = UIColor(red: 0.77, green: 0.77, blue: 0.77, alpha: 1.00)
    static let currentPageIndicatorDarkBlue = UIColor(red: 0.00, green: 0.12, blue: 0.44, alpha: 1.00)
    
    // MARK: - Day
    static let dayBackground = UIColor(red: 0.87, green: 0.93, blue: 0.95, alpha: 1.00)
    static let dayImage = UIColor(red: 0.94, green: 0.67, blue: 0.51, alpha: 1.00)
    static let dayMainLabel = UIColor(red: 0.94, green: 0.67, blue: 0.51, alpha: 1.00)
    static let daySideLabel = UIColor(red: 0.28, green: 0.29, blue: 0.51, alpha: 1.00)
 
    // MARK: - Night
    static let nightBackground = UIColor(red: 0.28, green: 0.29, blue: 0.51, alpha: 1.00)
    static let nightImage = UIColor(red: 0.91, green: 0.79, blue: 0.47, alpha: 1.00)
    static let nightMainLabel = UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.00)
    static let nightSideLabel = UIColor(red: 0.87, green: 0.93, blue: 0.95, alpha: 1.00)
   
    // MARK: - Cloudy
    static let cloudyBackground = UIColor(red: 0.87, green: 0.93, blue: 0.95, alpha: 1.00)
    static let cloudyImage = UIColor(red: 0.41, green: 0.81, blue: 0.90, alpha: 1.00)
//    static let cloudyImage = UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.00)
    static let cloudyMainLabel = UIColor(red: 0.28, green: 0.29, blue: 0.51, alpha: 1.00)
    static let cloudySideLabel = UIColor(red: 0.28, green: 0.29, blue: 0.51, alpha: 1.00)

    // MARK: - Snowy
    static let snowyBackground = UIColor(red: 0.65, green: 0.67, blue: 0.77, alpha: 1.00)
    static let snowyImage = UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.00)
    static let snowyMainLabel = UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.00)
    static let snowySideLabel = UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.00)

    // MARK: - Rainy
    static let rainyBackground = UIColor(red: 0.50, green: 0.52, blue: 0.59, alpha: 1.00)
    static let rainyImage = UIColor(red: 0.87, green: 0.93, blue: 0.95, alpha: 1.00)
    static let rainyMainLabel = UIColor(red: 0.87, green: 0.93, blue: 0.95, alpha: 1.00)
    static let rainySideLabel = UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.00)
   
    // MARK: - 흐린 날씨
    static let foggyBackground = UIColor(red: 0.61, green: 0.61, blue: 0.62, alpha: 1.00)
    static let foggyImage = UIColor(red: 0.87, green: 0.93, blue: 0.95, alpha: 1.00)
    static let foggyMainLabel = UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.00)
    static let foggySideLabel = UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.00)
    
    // MARK: - 미세먼지 농도에 따른 색깔
    
    // 밝은 배경화면일 때 사용할 색깔
    static let particulateGoodColorDay = UIColor(red: 0.18, green: 0.67, blue: 0.78, alpha: 1.00)
    static let particulateNormalColorDay = UIColor(red: 0.50, green: 0.67, blue: 0.53, alpha: 1.00)
    static let particulateBadColorDay = UIColor(red: 0.74, green: 0.64, blue: 0.38, alpha: 1.00)
    static let particulateVeryBadColorDay = UIColor(red: 0.78, green: 0.25, blue: 0.18, alpha: 1.00)
    
    // 어두운 배경화면일 때 사용할 색깔
    static let particulateGoodColorNight = UIColor(red: 0.06, green: 0.78, blue: 0.94, alpha: 1.00)
    static let particulateNormalColorNight = UIColor(red: 0.08, green: 0.84, blue: 0.19, alpha: 1.00)
    static let particulateBadColorNight = UIColor(red: 0.93, green: 0.76, blue: 0.33, alpha: 1.00)
    static let particulateVeryBadColorNight = UIColor(red: 0.92, green: 0.20, blue: 0.10, alpha: 1.00)

    // MARK: - Gradient Color
    static let gradientWhite = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
    static let gradientBlue = UIColor(red: 0.60, green: 0.72, blue: 0.80, alpha: 1.00)    
}
