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
    private let label: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let df: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        return label
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

extension RainDropView: ViewDrawable {
    func configureUI() {
        setAutolayout()
        setupGradient()
        backgroundColor = UIColor.gradientBlue.withAlphaComponent(0.9)
    }
    
    func setAutolayout() {
        [headerStackView].forEach { addSubview($0) }
        
        headerStackView.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading).offset(15)
            make.top.equalTo(snp.top).offset(12)
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
