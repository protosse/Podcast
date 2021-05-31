//
//  GradientLineView.swift
//  Podcast
//
//  Created by liuliu on 2021/5/31.
//

import UIKit

class GradientLineView: UIView {
    
    var gradientColors: [CGColor] = [] {
        didSet {
            lineContentLayer.colors = gradientColors
        }
    }

    var gradientAnimateColors: [CGColor] = []
    
    lazy var lineContentLayer = CAGradientLayer().then {
        $0.anchorPoint = .zero
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.addSublayer(lineContentLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lineContentLayer.frame = self.bounds
    }
    
    func startAnimate() {
        self.lineContentLayer.colors = gradientAnimateColors
        self.lineContentLayer.add(slidingAnimation(), forKey: "gradientAnimation")
    }
    
    func stopAnimate() {
        self.lineContentLayer.colors = gradientColors
        self.lineContentLayer.removeAllAnimations()
    }
    
    private func slidingAnimation() -> CAAnimation {
        let startPointAnim = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.startPoint))
        startPointAnim.fromValue = CGPoint(x: -1, y: 0.5)
        startPointAnim.toValue = CGPoint(x:1, y: 0.5)
        
        let endPointAnim = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.endPoint))
        endPointAnim.fromValue = CGPoint(x: 0, y: 0.5)
        endPointAnim.toValue = CGPoint(x:2, y: 0.5)
        
        let animGroup = CAAnimationGroup()
        animGroup.animations = [startPointAnim, endPointAnim]
        animGroup.duration = 1.5
        animGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        animGroup.repeatCount = .infinity
        
        return animGroup
    }
}
