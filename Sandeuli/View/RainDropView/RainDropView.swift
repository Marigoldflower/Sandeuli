//
//  RainDropView.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/10/04.
//

import UIKit
import SnapKit

final class RainDropView: UIView {
    // MARK: - Header 영역
    private let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "drop.fill")?.applyingSymbolConfiguration(.init(paletteColors: [.white]))
        return imageView
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Medium", size: 15)
        label.text = "강우"
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
    let precipitationAmount: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Medium", size: 25)
        label.textColor = .white
        return label
    }()
    
    let precipitaionDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Medium", size: 18)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Data Receiver
    var rainDropDataReceiver = String() {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            
            let startDateString = dateFormatter.string(from: Date())
            let endDateString = rainDropDataReceiver

            guard let startDate = dateFormatter.date(from: startDateString) else { return }
            guard let endDate = dateFormatter.date(from: endDateString) else { return }
            
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: startDate, to: endDate)
            
            guard let dayBetweenDate = components.day else { return }
            
            self.precipitaionDescription.text = "이후 \(dayBetweenDate + 1)일 이내 강우가 예상되지 않습니다."
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

extension RainDropView: ViewDrawable {
    func configureUI() {
        setAutolayout()
        setupGradient()
        backgroundColor = UIColor.gradientBlue.withAlphaComponent(0.9)
    }
    
    func setAutolayout() {
        [headerStackView, precipitationAmount, precipitaionDescription].forEach { addSubview($0) }
        
        headerStackView.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading).offset(15)
            make.top.equalTo(snp.top).offset(12)
        }
        
        precipitationAmount.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading).offset(15)
            make.top.equalTo(headerStackView.snp.bottom).offset(15)
        }
        
        precipitaionDescription.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading).offset(15)
            make.trailing.equalTo(snp.trailing).offset(-10)
            make.top.equalTo(precipitationAmount.snp.bottom).offset(20)
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
