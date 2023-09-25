//
//  KoreaMap.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/20.
//

import UIKit
import SnapKit

final class KoreaMap: UIView {
    
    // MARK: - UI Components
    private let koreaMapImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "korea")?.withTintColor(.earthColor).resizeImage(targetSize: CGSizeMake(450, 450))
        return imageView
    }()
    
    let seoul: KoreaDetailWeatherReportContainer = {
        let view = KoreaDetailWeatherReportContainer()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray.cgColor
        return view
    }()
    
    let incheon: KoreaDetailWeatherReportContainer = {
        let view = KoreaDetailWeatherReportContainer()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray.cgColor
        return view
    }()
    
    let gyeonggi: KoreaDetailWeatherReportContainer = {
        let view = KoreaDetailWeatherReportContainer()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray.cgColor
        return view
    }()
    
    let gangwon: KoreaDetailWeatherReportContainer = {
        let view = KoreaDetailWeatherReportContainer()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray.cgColor
        return view
    }()
    
    let chungbuk: KoreaDetailWeatherReportContainer = {
        let view = KoreaDetailWeatherReportContainer()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray.cgColor
        return view
    }()
    
    let chungnam: KoreaDetailWeatherReportContainer = {
        let view = KoreaDetailWeatherReportContainer()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray.cgColor
        return view
    }()
    
    let jeonbuk: KoreaDetailWeatherReportContainer = {
        let view = KoreaDetailWeatherReportContainer()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray.cgColor
        return view
    }()
    
    let jeonnam: KoreaDetailWeatherReportContainer = {
        let view = KoreaDetailWeatherReportContainer()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray.cgColor
        return view
    }()
    
    let gyeongnam: KoreaDetailWeatherReportContainer = {
        let view = KoreaDetailWeatherReportContainer()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray.cgColor
        return view
    }()
    
    let gyeongbuk: KoreaDetailWeatherReportContainer = {
        let view = KoreaDetailWeatherReportContainer()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray.cgColor
        return view
    }()
    
    let jeju: KoreaDetailWeatherReportContainer = {
        let view = KoreaDetailWeatherReportContainer()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray.cgColor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension KoreaMap: ViewDrawable {
    func configureUI() {
        backgroundColor = .seaColor
        setAutolayout()
    }
    
    func setAutolayout() {
        [koreaMapImage].forEach { addSubview($0) }
        [seoul, incheon, gyeonggi, gangwon, chungbuk, chungnam, jeonbuk, jeonnam, gyeongbuk, gyeongnam, jeju].forEach { koreaMapImage.addSubview($0) }
        
        koreaMapImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        seoul.snp.makeConstraints { make in
            make.width.equalTo(45)
            make.height.equalTo(85)
            make.top.equalTo(koreaMapImage.snp.top).offset(5)
            make.leading.equalTo(koreaMapImage.snp.leading).offset(60)
        }
        
        jeju.snp.makeConstraints { make in
            make.width.equalTo(45)
            make.height.equalTo(85)
            make.bottom.equalTo(koreaMapImage.snp.bottom).offset(-5)
            make.leading.equalTo(koreaMapImage.snp.leading).offset(50)
        }
        
        gangwon.snp.makeConstraints { make in
            make.width.equalTo(45)
            make.height.equalTo(85)
            make.top.equalTo(koreaMapImage.snp.top).offset(13)
            make.leading.equalTo(koreaMapImage.snp.leading).offset(172)
        }
        
        incheon.snp.makeConstraints { make in
            make.width.equalTo(45)
            make.height.equalTo(85)
            make.top.equalTo(koreaMapImage.snp.top).offset(50)
            make.leading.equalTo(koreaMapImage.snp.leading).offset(15)
        }
        
        jeonbuk.snp.makeConstraints { make in
            make.width.equalTo(45)
            make.height.equalTo(85)
            make.bottom.equalTo(koreaMapImage.snp.bottom).offset(-157)
            make.leading.equalTo(koreaMapImage.snp.leading).offset(67)
        }
        
        jeonnam.snp.makeConstraints { make in
            make.width.equalTo(45)
            make.height.equalTo(85)
            make.bottom.equalTo(koreaMapImage.snp.bottom).offset(-88)
            make.leading.equalTo(koreaMapImage.snp.leading).offset(22)
        }
        
        chungbuk.snp.makeConstraints { make in
            make.width.equalTo(45)
            make.height.equalTo(85)
            make.top.equalTo(koreaMapImage.snp.top).offset(137)
            make.leading.equalTo(koreaMapImage.snp.leading).offset(115)
        }
        
        chungnam.snp.makeConstraints { make in
            make.width.equalTo(45)
            make.height.equalTo(85)
            make.top.equalTo(koreaMapImage.snp.top).offset(155)
            make.leading.equalTo(koreaMapImage.snp.leading).offset(22)
        }
        
        gyeonggi.snp.makeConstraints { make in
            make.width.equalTo(45)
            make.height.equalTo(85)
            make.top.equalTo(koreaMapImage.snp.top).offset(91)
            make.leading.equalTo(koreaMapImage.snp.leading).offset(64)
        }
        
        gyeongbuk.snp.makeConstraints { make in
            make.width.equalTo(45)
            make.height.equalTo(85)
            make.top.equalTo(koreaMapImage.snp.top).offset(144)
            make.trailing.equalTo(koreaMapImage.snp.trailing).offset(-60)
        }
        
        gyeongnam.snp.makeConstraints { make in
            make.width.equalTo(45)
            make.height.equalTo(85)
            make.bottom.equalTo(koreaMapImage.snp.bottom).offset(-131)
            make.trailing.equalTo(koreaMapImage.snp.trailing).offset(-73)
        }
    }
}
