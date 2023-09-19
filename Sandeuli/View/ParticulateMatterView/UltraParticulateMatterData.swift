//
//  UltraParticulateMatterData.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/18.
//

import UIKit
import SnapKit

final class UltraParticulateMatterData: UIView {
    
    // MARK: - WeatherController로부터 데이터를 받는 곳
    var ultraParticulateDataReceiver = String() {
        didSet {
            guard let data = Int(ultraParticulateDataReceiver) else { return }
            
            switch data {
            case ...15:
                ultraParticulateCalculator(color: .particulateGoodColorNight, symbolName: "good", status: "좋음 ", offSet: -128)
                
            case 16...35:
                ultraParticulateCalculator(color: .particulateNormalColorNight, symbolName: "normal", status: "보통 ", offSet: -45)
                
            case 36...75:
                ultraParticulateCalculator(color: .particulateBadColorNight, symbolName: "bad", status: "나쁨 ", offSet: 38)
                
            case 76...:
                ultraParticulateCalculator(color: .particulateBadColorNight, symbolName: "veryBad", status: "매우나쁨 ", offSet: 121)
                
            default: return
            }
        }
    }
    
    var dayOrNightDistributor: Bool = Bool() {
        didSet {
            print("지금 낮인지 밤인지는 \(dayOrNightDistributor)")
            if dayOrNightDistributor {
                goodLabel.textColor = .particulateGoodColorDay
                normalLabel.textColor = .particulateNormalColorDay
                badLabel.textColor = .particulateBadColorDay
                veryBadLabel.textColor = .particulateVeryBadColorDay
            } else {
                goodLabel.textColor = .particulateGoodColorNight
                normalLabel.textColor = .particulateNormalColorNight
                badLabel.textColor = .particulateBadColorNight
                veryBadLabel.textColor = .particulateVeryBadColorNight
            }
        }
    }

    // MARK: - UI Components
    private let goodStatus: UIView = {
        let view = UIView()
        view.backgroundColor = .particulateGoodColorNight
        return view
    }()
    
    private let normalStatus: UIView = {
        let view = UIView()
        view.backgroundColor = .particulateNormalColorNight
        return view
    }()
    
    private let badStatus: UIView = {
        let view = UIView()
        view.backgroundColor = .particulateBadColorNight
        return view
    }()
    
    private let veryBadStatus: UIView = {
        let view = UIView()
        view.backgroundColor = .particulateVeryBadColorNight
        return view
    }()
    
    private let goodLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Medium", size: 15)
        label.text = "좋음"
        label.textColor = .particulateGoodColorNight
        return label
    }()
    
    private let normalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Medium", size: 15)
        label.text = "보통"
        label.textColor = .particulateNormalColorNight
        return label
    }()
    
    private let badLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Medium", size: 15)
        label.text = "나쁨"
        label.textColor = .particulateBadColorNight
        return label
    }()
    
    private let veryBadLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Medium", size: 15)
        label.text = "매우나쁨"
        label.textColor = .particulateVeryBadColorNight
        return label
    }()
    
    // MARK: - 초미세 CurrentStatus
    private let ultraParticularCurrentStatusCircle: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10 / 2
        view.clipsToBounds = true
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.black.cgColor
        view.backgroundColor = .white
        return view
    }()
    
    private let ultraParticulateLine: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private let ultraParticularCurrentLabelContainer: ParticularCurrentLabelContainer = {
        let view = ParticularCurrentLabelContainer()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    // MARK: - StackView
    private lazy var goodStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [goodStatus, goodLabel])
        stack.axis = .vertical
        stack.spacing = 3
        stack.alignment = .center
        return stack
    }()
    
    private lazy var normalStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [normalStatus, normalLabel])
        stack.axis = .vertical
        stack.spacing = 3
        stack.alignment = .center
        return stack
    }()
    
    private lazy var badStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [badStatus, badLabel])
        stack.axis = .vertical
        stack.spacing = 3
        stack.alignment = .center
        return stack
    }()
    
    private lazy var veryBadStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [veryBadStatus, veryBadLabel])
        stack.axis = .vertical
        stack.spacing = 3
        stack.alignment = .center
        return stack
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [goodStack, normalStack, badStack, veryBadStack])
        stack.axis = .horizontal
        stack.spacing = 3
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

extension UltraParticulateMatterData: ViewDrawable {
    func configureUI() {
        setAutolayout()
    }
    
    func setAutolayout() {
        [stackView, ultraParticularCurrentStatusCircle, ultraParticulateLine, ultraParticularCurrentLabelContainer].forEach { addSubview($0) }
        
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        [goodStatus, normalStatus, badStatus, veryBadStatus].forEach { $0.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(4)
        } }
    }
    
    private func ultraParticulateCalculator(color: UIColor, symbolName: String, status: String, offSet: ConstraintOffsetTarget) {
        ultraParticularCurrentStatusCircle.layer.borderColor = color.cgColor
        ultraParticulateLine.backgroundColor = color
        ultraParticularCurrentLabelContainer.backgroundColor = color
        ultraParticularCurrentLabelContainer.statusImageView.image = UIImage(named: symbolName)?.withTintColor(.white).resizeImage(targetSize: CGSize(width: 20, height: 20))
        ultraParticularCurrentLabelContainer.statusLabel.text = status + ultraParticulateDataReceiver
        ultraParticularCurrentLabelContainer.statusLabel.textColor = .white
        
        ultraParticularCurrentStatusCircle.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(16.5)
            make.leading.equalTo(snp.leading).offset(offSet)
            make.width.equalTo(10)
            make.height.equalTo(10)
        }
        
        ultraParticulateLine.snp.makeConstraints { make in
            make.bottom.equalTo(ultraParticularCurrentStatusCircle.snp.top)
            make.leading.equalTo(ultraParticularCurrentStatusCircle.snp.leading).offset(4)
            make.width.equalTo(2)
            make.height.equalTo(10)
        }
        
        ultraParticularCurrentLabelContainer.snp.makeConstraints { make in
            make.bottom.equalTo(ultraParticulateLine.snp.top)
            make.leading.equalTo(ultraParticulateLine.snp.leading).offset(-50)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
    }
}

