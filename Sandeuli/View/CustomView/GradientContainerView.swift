//
//  GradientContainerView.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/07.
//

import UIKit

final class GradientContainerView: UIView {
    
    private var gradientLayer: CAGradientLayer?
    
    func setGradientLayer(colors: [CGColor], startPoint: CGPoint, endPoint: CGPoint) {
        if let gradientLayer = gradientLayer {
            gradientLayer.removeFromSuperlayer()
        }
        
        let newGradientLayer = CAGradientLayer()
        newGradientLayer.frame = bounds
        
        // opacity 조절
        let startColor = colors[0].withAdjustedAlpha(0.7)
        let endColor = colors[1].withAdjustedAlpha(0.3)
        
        newGradientLayer.colors = [startColor, endColor]
        newGradientLayer.startPoint = startPoint
        newGradientLayer.endPoint = endPoint
        layer.insertSublayer(newGradientLayer, at: 0)
        gradientLayer = newGradientLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = bounds
    }
}


extension CGColor {
    func withAdjustedAlpha(_ alpha: CGFloat) -> CGColor {
        let components = self.components ?? []
        let colorWithAdjustedAlpha: CGColor?
        
        switch self.numberOfComponents {
        case 0, 1:
            colorWithAdjustedAlpha = nil
        case 2:
            let opaqueColor = UIColor(white: components[0], alpha: 1)
            colorWithAdjustedAlpha = opaqueColor.withAlphaComponent(alpha).cgColor
        case 3, 4:
            let opaqueColor = UIColor(red: components[0], green: components[1], blue: components[2], alpha: 1)
            colorWithAdjustedAlpha = opaqueColor.withAlphaComponent(alpha).cgColor
        default:
            colorWithAdjustedAlpha = nil
        }
        
        return colorWithAdjustedAlpha ?? self
    }
}
