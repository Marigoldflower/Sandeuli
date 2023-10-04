//
//  UVIndexView.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/10/04.
//

import UIKit
import SnapKit

final class UVIndexView: UIView {
    // MARK: - Header 영역
    private let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "sun.min.fill")?.applyingSymbolConfiguration(.init(paletteColors: [.white]))
        return imageView
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Medium", size: 15)
        label.text = "자외선 지수"
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
    let uvIndexNumber: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Medium", size: 25)
        label.textColor = .white
        return label
    }()
    
    let uvIndexStatus: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Medium", size: 22)
        label.textColor = .white
        return label
    }()
    
    let uvIndexImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let uvIndexDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Medium", size: 18)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Data를 받아서 처리하는 변수
    var uvIndexDataReceiver = Int() {
        didSet {
            switch uvIndexDataReceiver {
            case 0...2:
                uvIndexNumber.text = String(uvIndexDataReceiver)
                uvIndexImage.image = UIImage(named: "good")?.resizeImage(targetSize: CGSize(width: 35, height: 35)).withTintColor(.white)
                uvIndexImage.backgroundColor = .particulateGoodColorNight
                uvIndexDescription.text = "● 햇볕 노출에 대한 보호조치가 필요하지 않음\n● 그러나 햇볕에 민감한 피부를 가진 분은 자외선 차단제를 발라야 함"
            case 3...5:
                uvIndexNumber.text = String(uvIndexDataReceiver)
                uvIndexImage.image = UIImage(named: "normal")?.resizeImage(targetSize: CGSize(width: 35, height: 35)).withTintColor(.white)
                uvIndexImage.backgroundColor = .particulateNormalColorNight
                uvIndexDescription.text = "● 2～3시간 내에도 햇볕에 노출 시에 피부 화상을 입을 수 있음\n● 모자, 선글라스 이용\n● 자외선 차단제를 발라야 함"
            case 6...7:
                uvIndexNumber.text = String(uvIndexDataReceiver)
                uvIndexImage.image = UIImage(named: "bad")?.resizeImage(targetSize: CGSize(width: 35, height: 35)).withTintColor(.white)
                uvIndexImage.backgroundColor = .particulateBadColorNight
                uvIndexDescription.text = "● 햇볕에 노출 시 1～2시간 내에도 피부 화상을 입을 수 있어 위험함\n● 한낮에는 그늘에 머물러야 함\n● 외출 시 긴 소매 옷, 모자, 선글라스 이용\n● 자외선 차단제를 정기적으로 발라야 함"
            case 8...10:
                uvIndexNumber.text = String(uvIndexDataReceiver)
                uvIndexImage.image = UIImage(named: "veryBad")?.resizeImage(targetSize: CGSize(width: 35, height: 35)).withTintColor(.white)
                uvIndexImage.backgroundColor = .particulateVeryBadColorNight
                uvIndexDescription.text = "● 햇볕에 노출 시 수십 분 이내에도 피부 화상을 입을 수 있어 매우 위험함\n● 오전 10시부터 오후 3시까지 외출을 피하고 실내나 그늘에 머물러야 함\n● 외출 시 긴 소매 옷, 모자, 선글라스 이용\n● 자외선 차단제를 정기적으로 발라야 함"
            case 11...:
                uvIndexNumber.text = String(uvIndexDataReceiver)
                uvIndexImage.image = UIImage(named: "dangerous")?.resizeImage(targetSize: CGSize(width: 35, height: 35)).withTintColor(.white)
                uvIndexImage.backgroundColor = .systemPurple
                uvIndexDescription.text = "● 햇볕에 노출 시 수십 분 이내에도 피부 화상을 입을 수 있어 가장 위험함\n● 가능한 실내에 머물러야 함\n● 외출 시 긴 소매 옷, 모자, 선글라스 이용\n● 자외선 차단제를 정기적으로 발라야 함"
            default: break
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        uvIndexImage.layer.cornerRadius = 35 / 2
        uvIndexImage.layer.masksToBounds = true
    }
    
    // View 자체에 그라디언트 효과를 적용하기 위해 필요한 변수
    override public class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
}

extension UVIndexView: ViewDrawable {
    func configureUI() {
        setAutolayout()
        setupGradient()
        backgroundColor = UIColor.gradientBlue.withAlphaComponent(0.9)
    }
    
    func setAutolayout() {
        [headerStackView, uvIndexNumber, uvIndexStatus, uvIndexImage, uvIndexDescription].forEach { addSubview($0) }
        
        headerStackView.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading).offset(15)
            make.top.equalTo(snp.top).offset(12)
        }
        
        uvIndexImage.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading).offset(15)
            make.top.equalTo(headerStackView.snp.bottom).offset(15)
        }
        
        uvIndexStatus.snp.makeConstraints { make in
            make.leading.equalTo(uvIndexImage.snp.trailing).offset(10)
            make.top.equalTo(headerStackView.snp.bottom).offset(17)
        }
        
        uvIndexNumber.snp.makeConstraints { make in
            make.leading.equalTo(uvIndexStatus.snp.trailing).offset(5)
            make.top.equalTo(headerStackView.snp.bottom).offset(14.5)
        }
        
        uvIndexDescription.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading).offset(15)
            make.trailing.equalTo(snp.trailing).offset(-10)
            make.top.equalTo(uvIndexImage.snp.bottom).offset(15)
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
