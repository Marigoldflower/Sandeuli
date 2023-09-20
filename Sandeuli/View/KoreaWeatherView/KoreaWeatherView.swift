//
//  KoreaWeatherView.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/20.
//

import UIKit
import SnapKit

final class KoreaWeatherView: UIView {

    // MARK: - Header 영역
    private let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "globe")?.applyingSymbolConfiguration(.init(paletteColors: [.white]))
        return imageView
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Medium", size: 15)
        label.text = "전국날씨"
        label.textColor = .white
        return label
    }()
    
    // MARK: - UI Components
    private let koreaMap: KoreaMap = {
        let map = KoreaMap()
        return map
    }()
    
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
    
    override public class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
}

extension KoreaWeatherView: ViewDrawable {
    func configureUI() {
        setAutolayout()
        setupGradient()
        backgroundColor = UIColor.gradientBlue.withAlphaComponent(0.9)
    }
    
    func setAutolayout() {
        [headerStackView, koreaMap].forEach { addSubview($0) }
        
        headerStackView.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading).offset(15)
            make.top.equalTo(snp.top).offset(12)
        }
        
        koreaMap.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading)
            make.trailing.equalTo(snp.trailing)
            make.top.equalTo(headerStackView.snp.bottom).offset(15)
            make.bottom.equalTo(snp.bottom)
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
