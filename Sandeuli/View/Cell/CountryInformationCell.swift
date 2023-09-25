//
//  CountryInformationCell.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/25.
//

import UIKit
import SnapKit

final class CountryInformationCell: UITableViewCell {
    
    static let identifier = "CountryInformationCell"
    
    // MARK: - UI Components
    let regionName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Medium", size: 15)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension CountryInformationCell: ViewDrawable {
    func configureUI() {
        setAutolayout()
    }
    
    func setAutolayout() {
        addSubview(regionName)
        
        regionName.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading).offset(20)
            make.centerY.equalToSuperview()
        }
    }
}

