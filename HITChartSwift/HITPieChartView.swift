//
//  HITPieChartView.swift
//  HITChartSwift
//
//  Created by bunu on 2018/05/28.
//  Copyright © 2018年 hitsubunnu. All rights reserved.
//

import UIKit

open class HITPieChartView: UIView {
    @IBInspectable var background: UIColor = UIColor.white
    @IBInspectable var duration: CGFloat = 1

    public func draw(_ data: [(value: CGFloat, color: UIColor)], strokeWidth: CGFloat, animation isAnimation: Bool = false) {
        self.layer.sublayers?.removeAll()
        setupBackground()
        let values = data.map{ $0.value }
        let colors = data.map{ $0.color }
        let width = bounds.width
        let height = bounds.height
        let radius = (width - strokeWidth)/2
        let center = CGPoint(x: width/2, y: height/2)
        let angleUnit: CGFloat = 360 * 0.01 * CGFloat.pi / 180
        var tempAngle: CGFloat = -100 / 4 * angleUnit
        var tempBeginTime: CFTimeInterval = 0

        for (index, value) in values.enumerated() {
            let startAngle = tempAngle
            tempAngle += value * angleUnit
            let endAngle = tempAngle
            let pathArc = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = pathArc.cgPath
            shapeLayer.lineWidth = strokeWidth
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.strokeColor = colors[index].cgColor
            
            if isAnimation {
                let animation = CABasicAnimation(keyPath: "strokeEnd")
                animation.duration = CFTimeInterval(duration * 0.01 * value)
                animation.beginTime = CACurrentMediaTime() + tempBeginTime
                tempBeginTime += animation.duration
                
                animation.fromValue = 0
                animation.toValue = 1
                animation.fillMode = "backwards"
                
                shapeLayer.add(animation, forKey: "strokeEnd")
            }
            
            self.layer.addSublayer(shapeLayer)
        }
    }
    
    private func setupBackground() {
        backgroundColor = background
    }
}
