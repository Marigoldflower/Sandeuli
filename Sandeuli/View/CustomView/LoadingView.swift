//
//  LoadingView.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/20.
//

import UIKit

final class LoadingView: UIView {
    
    // MARK: - UI Components
    var circleLayers: [CAShapeLayer] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension LoadingView: ViewDrawable {
    func configureUI() {
        makeLoadingView()
        setAutolayout()
    }
    
    func setAutolayout() {
        
    }
    
    private func makeLoadingView() {
        let numberOfCircles = 4
        let circleRadius: CGFloat = 20.0
        let duration: CFTimeInterval = 1.0
                
        for i in 0..<numberOfCircles {
            // 원 모양의 CAShapeLayer 생성
            let circlePath = UIBezierPath(arcCenter: .zero, radius: circleRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
            let circleLayer = CAShapeLayer()
            circleLayer.path = circlePath.cgPath
            
            // 위치 설정 (여기서는 화면 중앙에 배치)
            circleLayer.position = self.center
            
            // 색상 및 스타일 설정
            circleLayer.fillColor = UIColor.clear.cgColor
            circleLayer.strokeColor = UIColor.blue.cgColor // 원하는 색상으로 변경 가능
            
            // 회전 애니메이션 생성 및 추가
            let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotateAnimation.byValue = CGFloat.pi * 2
            rotateAnimation.duration = duration
            rotateAnimation.beginTime = CACurrentMediaTime() + (rotateAnimation.duration / Double(numberOfCircles) * Double(i))
            
            // 애니메이션이 완료된 후에도 계속 반복하도록 설정
            rotateAnimation.repeatCount = Float.infinity
            
            layer.add(rotateAnimation , forKey : nil )
            self.layer.addSublayer(circleLayer)
            self.circleLayers.append(circleLayer)
        }
    }
}
