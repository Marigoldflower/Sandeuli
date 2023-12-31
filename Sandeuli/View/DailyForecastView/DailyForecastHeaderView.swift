//
//  DailyForecastHeaderView.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/18.
//

import UIKit
import SnapKit

final class DailyForecastHeaderView: UIView {

    // MARK: - UI Components
    private let headerViewImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar")?.applyingSymbolConfiguration(.init(paletteColors: [.white]))
        return imageView
    }()

    private let headerViewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Medium", size: 15)
        label.text = "10일 간의 일기예보"
        label.textColor = .white
        return label
    }()
    
    // MARK: - StackView
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [headerViewImage, headerViewLabel])
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
}

extension DailyForecastHeaderView: ViewDrawable {
    func configureUI() {
        setAutolayout()
    }
    
    func setAutolayout() {
        [stackView].forEach { addSubview($0) }
        
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading).offset(15)
            make.top.equalTo(snp.top).offset(-8)
        }
    }
}
