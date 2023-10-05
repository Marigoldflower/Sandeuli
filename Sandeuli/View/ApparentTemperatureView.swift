//
//  ApparentTemperatureView.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/10/05.
//

import UIKit
import SnapKit

final class ApparentTemperatureView: UIView {
    // MARK: - Header 영역
    private let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "thermometer.medium")?.applyingSymbolConfiguration(.init(paletteColors: [.white]))
        return imageView
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Medium", size: 15)
        label.text = "체감 온도"
        label.textColor = .white
        return label
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [headerImageView, headerLabel])
        stack.axis = .horizontal
        stack.spacing = 4
        return stack
    }()
    
    // MARK: - UI Components
    let apparentTemperature: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Medium", size: 25)
        label.textColor = .white
        return label
    }()
    
    let apparentDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Medium", size: 18)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Data Receiver
    var apparentTemperatureDataReceiver = Double() {
        didSet {
            
            self.apparentTemperature.text = String(round(apparentTemperatureDataReceiver * 10) / 10 ) + "°"
            
            switch apparentTemperatureDataReceiver {
            case apparentTemperatureDataReceiver - 1 ... apparentTemperatureDataReceiver + 1:
                self.apparentDescription.text = "실제 온도와 비슷합니다"
            case apparentTemperatureDataReceiver - Double(Int.random(in: Int(apparentTemperatureDataReceiver) + 2 ... 100)) ... apparentTemperatureDataReceiver:
                self.apparentDescription.text = "실제 온도보다 따뜻합니다"
            case apparentTemperatureDataReceiver ... apparentTemperatureDataReceiver + Double(Int.random(in: Int(apparentTemperatureDataReceiver) + 2 ... 100)):
                self.apparentDescription.text = "실제 온도보다 춥습니다"
            default: break
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
    
    // View 자체에 그라디언트 효과를 적용하기 위해 필요한 변수
    override public class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
}

extension ApparentTemperatureView: ViewDrawable {
    func configureUI() {
        setAutolayout()
        setupGradient()
        backgroundColor = UIColor.gradientBlue.withAlphaComponent(0.9)
    }
    
    func setAutolayout() {
        [headerStackView, apparentTemperature, apparentDescription].forEach { addSubview($0) }
        
        headerStackView.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading).offset(15)
            make.top.equalTo(snp.top).offset(12)
        }
        
        apparentTemperature.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading).offset(15)
            make.top.equalTo(headerStackView.snp.bottom).offset(15)
        }
        
        apparentDescription.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading).offset(15)
            make.trailing.equalTo(snp.trailing).offset(-10)
            make.top.equalTo(apparentTemperature.snp.bottom).offset(20)
        }
    }
    
    // MARK: - Gradient 적용 메소드
    private func setupGradient() {
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors = [UIColor.gradientBlue.cgColor.withAdjustedAlpha(0.7), UIColor.gradientWhite.cgColor.withAdjustedAlpha(0.3)]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
    }
}
