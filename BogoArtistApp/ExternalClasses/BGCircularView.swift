//
//  BGCircularView.swift
//  BogoArtistApp
//
//  Created by TheAppSmiths on 08/02/18.
//  Copyright © 2018 TheAppSmiths. All rights reserved.
//

import UIKit

class BGCircularView: UIView {

    var path: UIBezierPath!
    var pathColor = UIColor.clear
    var circleLayer: CAShapeLayer!
    var endAngle = 50

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {  // Drawing code
        drawMainArc()
    }
    
    func drawMainArc() {
        circleLayer = CAShapeLayer()
        
        path = UIBezierPath(arcCenter: CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2 + 5),
                             radius: self.frame.size.height/2,
                             startAngle: CGFloat(130.0).toRadians(),
                             endAngle: CGFloat(endAngle).toRadians(),
                             clockwise: true)
        
        circleLayer.path = path.cgPath
        circleLayer.lineWidth = 5
        circleLayer.strokeColor = pathColor.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeEnd = 0.0   // Don't draw the circle initially
        layer.addSublayer(circleLayer)
        self.animateCircle(duration: 3.0)
    }
    
    func animateCircle(duration: TimeInterval) {
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        // Set the animation duration appropriately
        animation.duration = duration
        
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 0
        animation.toValue = 1
        
        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        
        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        circleLayer.strokeEnd = 1.0
        
        // Do the actual animation
        circleLayer.add(animation, forKey: "animateCircle")
    }
    
}
