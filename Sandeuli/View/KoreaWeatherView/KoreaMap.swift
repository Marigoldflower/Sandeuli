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
        imageView.image = UIImage(named: "korea")?.withTintColor(.gradientWhite).resizeImage(targetSize: CGSizeMake(450, 450))
        return imageView
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
        
        koreaMapImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
