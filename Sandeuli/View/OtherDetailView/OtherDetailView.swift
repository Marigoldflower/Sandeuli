//
//  OtherDetailView.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/10/05.
//

import UIKit
import SnapKit

final class OtherDetailView: UIView {
    // MARK: - UI Components
    private let appImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        return imageView
    }()
    
    private let appName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-SemiBold", size: 30)
        label.text = "산들이"
        label.textColor = .black
        return label
    }()
    
    private let appSource: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Medium", size: 15)
        label.text = "자료: WeatherKit(애플), 기상청(공공데이터)"
        label.textColor = .black
        return label
    }()
    
    private let caution: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Medium", size: 15)
        label.text = "이 날씨 자료는 애플의 자산인 WeatherKit과 기상청으로부터 나온 것입니다.\n자료 오류 및 표출방식에 따라 값이 다를 수 있음을 양해 부탁드립니다."
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - StackView
    private lazy var appImageAndName: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [appImage, appName])
        stack.axis = .horizontal
        stack.spacing = 7
        return stack
    }()
    
    private lazy var totalStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [appImageAndName, appSource, caution])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 20
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

extension OtherDetailView: ViewDrawable {
    func configureUI() {
        setAutolayout()
    }
    
    func setAutolayout() {
        [totalStackView].forEach { addSubview($0) }
        
        appImage.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        
        totalStackView.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading).offset(15)
            make.trailing.equalTo(snp.trailing).offset(-15)
            make.centerY.equalToSuperview()
        }
    }
}
