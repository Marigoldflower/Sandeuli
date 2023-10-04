//
//  ParticulateMatterView.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/18.
//

import UIKit
import SnapKit

final class ParticulateMatterView: UIView {
    
    // MARK: - Header 영역
    private let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "aqi.medium")?.applyingSymbolConfiguration(.init(paletteColors: [.white]))
        return imageView
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Medium", size: 15)
        label.text = "미세먼지 & 초미세먼지"
        label.textColor = .white
        return label
    }()
    
    // MARK: - UI Components of ParticulateMatter
    private let particulateMatterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Semibold", size: 20)
        label.text = "미세먼지"
        label.textColor = .white
        return label
    }()
    
    let particulateMatterData: ParticulateMatterData = {
        let view = ParticulateMatterData()
        return view
    }()
    
    // MARK: - UI Components of UltraParticulateMatter
    private let ultraParticulateMatterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Semibold", size: 20)
        label.text = "초미세먼지"
        label.textColor = .white
        return label
    }()
    
    let ultraParticulateMatterData: UltraParticulateMatterData = {
        let view = UltraParticulateMatterData()
        return view
    }()
    
    // MARK: - StackView
    private lazy var headerStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [headerImageView, headerLabel])
        stack.axis = .horizontal
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
    
    // View 자체에 그라디언트 효과를 적용하기 위해 필요한 변수
    override public class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
}

extension ParticulateMatterView: ViewDrawable {
    func configureUI() {
        setAutolayout()
        setupGradient()
        backgroundColor = UIColor.gradientBlue.withAlphaComponent(0.9)
        
    }
    
    func setAutolayout() {
        [headerStackView, particulateMatterLabel, particulateMatterData, ultraParticulateMatterLabel, ultraParticulateMatterData].forEach { addSubview($0) }
        
        headerStackView.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading).offset(15)
            make.top.equalTo(snp.top).offset(12)
        }
        
        particulateMatterLabel.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading).offset(25)
            make.top.equalTo(headerStackView.snp.bottom).offset(30)
        }
        
        // width가 329임 ⭐️
        particulateMatterData.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(particulateMatterLabel.snp.bottom).offset(50)
            make.height.equalTo(70)
        }
        
        ultraParticulateMatterLabel.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading).offset(25)
            make.top.equalTo(particulateMatterData.snp.bottom).offset(30)
        }
        
        ultraParticulateMatterData.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(ultraParticulateMatterLabel.snp.bottom).offset(50)
            make.height.equalTo(70)
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
