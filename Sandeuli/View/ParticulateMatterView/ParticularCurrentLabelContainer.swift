//
//  ParticularCurrentLabelContainer.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/18.
//

import UIKit
import SnapKit

final class ParticularCurrentLabelContainer: UIView {
    
    // MARK: - UI Components
    let statusImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    // MARK: - StackView
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [statusImageView, statusLabel])
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

extension ParticularCurrentLabelContainer: ViewDrawable {
    func configureUI() {
        setAutolayout()
    }
    
    func setAutolayout() {
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
