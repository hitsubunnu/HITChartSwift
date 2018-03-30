//
//  HITLineChartView.swift
//  HITChartSwift
//
//  Created by hitsubunnu on 2018/03/22.
//  Copyright © 2018年 hitsubunnu. All rights reserved.
//

import UIKit

open class HITLineChartView: UIView {
    @IBInspectable var background: UIColor = UIColor.white
    @IBInspectable var lineColor: UIColor = UIColor.color("0x0099aa")
    @IBInspectable var titleColor: UIColor = UIColor.color("0x0099aa")
    @IBInspectable var indicatorColor: UIColor = UIColor.color("0x0099aa")
    @IBInspectable var backgroundLineColor: UIColor = UIColor.color("0xe6e6e6")
    @IBInspectable var textColor: UIColor = UIColor.color("0x333333")
    @IBInspectable var hapticFeedbackEnable: Bool = true

    private let kWidthRatio: CGFloat = 0.8
    private let kHeightRatio: CGFloat = 5/9
    private let kStrokeEndAnimetionKeyPath = "strokeEnd"
    private let kOpacityAnimetionKeyPath = "opacity"
    private let kPositionAnimetionKeyPath = "position"
    private let kSettleDateLimit = 5
    private let kStartMargin: CGFloat = 80.0
    private let kHeightMargin: CGFloat = 4.0
    private let kIconRadius: CGFloat = 3.0
    private let kIndicatorTextWidth: CGFloat = 90.0
    private let kIndicatorTextHeight: CGFloat = 16.0
    
    private var absMax = 0
    private var values = [Double]()
    private var dates = [Date]()
    private var titles = [String]()
    private var previousIndex = 0
    private var cgPoints = [CGPoint]()
    
    private let titleText = CATextLayer()
    private let indicator = CAShapeLayer()
    private let indicatorIcon = CAShapeLayer()
    private let indicatorText = CATextLayer()
    
    public func draw(_ absMax: Int, values: [Double], label: (max: String, center: String, min: String), dates: [Date], titles: [String]) {
        self.layer.sublayers?.removeAll()
        self.absMax = absMax
        self.values = values
        self.dates = dates
        self.titles = titles
        self.previousIndex = values.count - 1
        
        setupBackground(max: label.max, center: label.center, min: label.min)
        setupTitle()
        setupSettleDate(dates)
        drawChart(values: values)
        setupIndicator()
        setupIndicatorIcon()
        setupIndicatorText()
        setupGestureRecognizer()
    }
    
    private func setupBackground(max: String, center: String, min: String) {
        backgroundColor = background
        
        let width = bounds.width
        let height = bounds.height
        let x = (width - width * kWidthRatio) / 2
        let lineWidth = width * kWidthRatio
        
        // max
        let yMax = (height - height * kHeightRatio) / 2
        setupBackgroundLine(x: x, y: yMax, width: lineWidth)
        setupBackgroundText(x: x, y: yMax, string: max)
        
        // center
        let yCenter = height / 2
        setupBackgroundCenterLine(x: x, y: yCenter, width: lineWidth)
        setupBackgroundText(x: x, y: yCenter, string: center)

        // min
        let yMin = (height + height * kHeightRatio) / 2
        setupBackgroundLine(x: x, y: yMin, width: lineWidth)
        setupBackgroundText(x: x, y: yMin, string: min)
    }
    
    private func setupBackgroundLine(x: CGFloat, y: CGFloat, width: CGFloat) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: x, y: y))
        path.addLine(to: CGPoint(x: x + width, y: y))
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.strokeColor = backgroundLineColor.cgColor
        layer.contentsScale = UIScreen.main.scale
        
        self.layer.addSublayer(layer)
    }

    private func setupBackgroundCenterLine(x: CGFloat, y: CGFloat, width: CGFloat) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: x, y: y))
        path.addLine(to: CGPoint(x: x + width, y: y))
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.strokeColor = backgroundLineColor.cgColor
        layer.lineWidth = 1
        layer.lineJoin = kCALineJoinRound
        layer.lineDashPattern = [NSNumber(value: 2)]
        layer.contentsScale = UIScreen.main.scale
        
        self.layer.addSublayer(layer)
    }
    
    private func setupBackgroundText(x: CGFloat, y: CGFloat, string: String) {
        let text = CATextLayer()
        let textWidth: CGFloat = 44.0
        let textHeight: CGFloat = 12.0
        let xText = x - textWidth
        let yText = y - textHeight / 2
        text.string = string
        text.foregroundColor = textColor.cgColor
        text.fontSize = Dimens.Txt.s.rawValue
        text.font = UIFont.systemFont(ofSize: Dimens.Txt.s.rawValue)
        text.frame = CGRect(x: xText, y: yText, width: textWidth, height: textHeight)
        text.contentsScale = UIScreen.main.scale
        text.alignmentMode = kCAAlignmentLeft
        
        self.layer.addSublayer(text)
    }
    
    private func setupSettleDate(_ settleDate: [Date]) {
        guard settleDate.count > 1 else { return }
        let choosedSettleDate = chooseSettleDate(settleDate)
        
        let width = bounds.width
        let layerWidth: CGFloat = 60
        let layerHeight: CGFloat = 12
        let xStart: CGFloat = (width * (1 - kWidthRatio) - layerWidth ) / 2
        let k = width * kWidthRatio / CGFloat(settleDate.count - 1)
        var x = xStart
        let y = bounds.height - layerHeight * 2
        
        for choosedDate in choosedSettleDate {
            x = k * CGFloat(choosedDate.index) + xStart
            let layer = CATextLayer()
            layer.string = choosedDate.date.yyyy_mm_dd()
            layer.foregroundColor = textColor.cgColor
            layer.fontSize = Dimens.Txt.s.rawValue
            layer.font = UIFont.systemFont(ofSize: Dimens.Txt.s.rawValue)
            layer.frame = CGRect(x: x, y: y, width: layerWidth, height: layerHeight)
            layer.contentsScale = UIScreen.main.scale
            layer.alignmentMode = kCAAlignmentCenter
            self.layer.addSublayer(layer)
        }
    }
    
    /**
     * @brief Base on the days of data, choose settle date.
     *
     * @remarks count <= kSettleDateLimit: display count day
     * @remarks kSettleDateLimit < count && count < kSettleDateLimit*4: display 2 day // for design
     * @remarks count >= kSettleDateLimit*4: display kSettleDateLimit day
     *
     */
    private func chooseSettleDate(_ settleDate: [Date]) -> [(index: Int, date: Date)] {
        let count = settleDate.count
        var reversedChoosedSettleDate = [(index: Int, date: Date)]()
        if count <= kSettleDateLimit {
            for (index, date) in settleDate.enumerated() {
                reversedChoosedSettleDate.append((index: index, date: date))
            }
            return reversedChoosedSettleDate
        } else if count < kSettleDateLimit * 4 {
            reversedChoosedSettleDate.append((index: 0, date: settleDate[0]))
            reversedChoosedSettleDate.append((index: count - 1 , date: settleDate[count-1]))
            return reversedChoosedSettleDate
        }
        
        var num = kSettleDateLimit - 1
        let flag = Int(count / num)
        reversedChoosedSettleDate.append((index: count - 1, date: settleDate[count - 1]))
        while num > 1 {
            num -= 1
            reversedChoosedSettleDate.append((index: flag * num , date: settleDate[flag * num]))
        }
        reversedChoosedSettleDate.append((index: 0, date: settleDate[0]))
        return reversedChoosedSettleDate.reversed()
    }
    
    private func drawChart(values: [Double]) {
        guard values.count > 0 else { return }
        
        let width = bounds.width
        var x = width * (1 - kWidthRatio) / 2
        let y = getY(pointY: values.first)
        let k = width * kWidthRatio / CGFloat(values.count - 1)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: x, y: y))
        cgPoints.append(CGPoint(x: x, y: y))
        if values.count > 1 {
            for pointY in values[1..<values.count] {
                x += k
                let y = getY(pointY: pointY)
                path.addLine(to: CGPoint(x: x, y: y))
                cgPoints.append(CGPoint(x: x, y: y))
            }
        }
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = lineColor.cgColor
        layer.contentsScale = UIScreen.main.scale
        layer.add(setupChartAnimation(), forKey: kStrokeEndAnimetionKeyPath)
        
        self.layer.addSublayer(layer)
    }
    
    /**
     * @brief base on absMax, seek Y coordinate
     */
    private func getY(pointY: Double?) -> CGFloat {
        let height = bounds.height
        let halfChartHeight: CGFloat =  kHeightRatio * height / 2
        let heightMargin: CGFloat = (1 - kHeightRatio) * height / 2
        guard let pointY = pointY else { return halfChartHeight + heightMargin }
        guard absMax != 0 else { return halfChartHeight + heightMargin }
        
        if pointY >= 0.0 {
            return (1 - CGFloat(pointY) / CGFloat(absMax)) * halfChartHeight + heightMargin
        } else {
            return CGFloat(-pointY) / CGFloat(absMax) * halfChartHeight + height / 2
        }
    }
    
    private func setupChartAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: kStrokeEndAnimetionKeyPath)
        animation.duration = 1
        animation.fromValue = 0
        animation.toValue = 1
        return animation
    }
    
    private func setupTitle() {
        let width = bounds.width
        let height = bounds.height
        let x: CGFloat = (width - width * kWidthRatio) / 2
        let y: CGFloat = (height - height*kHeightRatio)/4 - Dimens.Txt.l.rawValue/2
        let textWidth: CGFloat = width*kWidthRatio
        let textHeight: CGFloat = 20.0
        
        setupTitleText(titles.last)
        titleText.foregroundColor = titleColor.cgColor
        titleText.fontSize = Dimens.Txt.l.rawValue
        titleText.font = UIFont.boldSystemFont(ofSize: Dimens.Txt.l.rawValue)
        titleText.frame = CGRect(x: x, y: y, width: textWidth, height: textHeight)
        titleText.contentsScale = UIScreen.main.scale
        titleText.alignmentMode = kCAAlignmentLeft
        self.layer.addSublayer(titleText)
    }
    
    private func setupTitleText(_ text: String?) {
        guard let text = text else { return }
        titleText.string = text
    }

    private func setupIndicator() {
        guard let endPoint = cgPoints.last else { return }
        
        let x = endPoint.x
        let y = endPoint.y
        let absMinY = bounds.height/2 + bounds.height*kHeightRatio/2
        let margin: CGFloat = 10
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: x, y: y))
        path.addLine(to: CGPoint(x: x, y: absMinY + margin))
        
        indicator.path = path.cgPath
        indicator.fillColor = UIColor.clear.cgColor
        indicator.strokeColor = indicatorColor.cgColor
        indicator.contentsScale = UIScreen.main.scale
        indicator.lineWidth = 0.5
        indicator.lineJoin = kCALineJoinRound
        indicator.lineDashPattern = [NSNumber(value: 2)]
        indicator.add(setupEndingAnimation(), forKey: kOpacityAnimetionKeyPath)
        
        self.layer.addSublayer(indicator)
    }
    
    private func setupIndicatorIcon() {
        guard let endPoint = cgPoints.last else { return }
        
        let path = UIBezierPath(arcCenter: CGPoint(x: endPoint.x, y: endPoint.y), radius: kIconRadius, startAngle: 0.0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        indicatorIcon.path = path.cgPath
        indicatorIcon.fillColor = indicatorColor.cgColor
        indicatorIcon.contentsScale = UIScreen.main.scale
        indicatorIcon.opacity = 0.0
        indicatorIcon.add(setupEndingAnimation(), forKey: kOpacityAnimetionKeyPath)
        
        self.layer.addSublayer(indicatorIcon)
    }
    
    private func setupIndicatorText() {
        guard let endPoint = cgPoints.last else { return }
        
        let xText = endPoint.x - kIndicatorTextWidth / 2
        let absMinY = bounds.height/2 + bounds.height*kHeightRatio/2
        let margin: CGFloat = 10
        indicatorText.string = dates.last?.yyyy_mm_dd()
        indicatorText.alignmentMode = kCAAlignmentCenter
        indicatorText.foregroundColor = UIColor.white.cgColor
        indicatorText.backgroundColor = indicatorColor.cgColor
        indicatorText.fontSize = Dimens.Txt.s.rawValue
        indicatorText.font = UIFont.boldSystemFont(ofSize: 9)
        indicatorText.frame = CGRect(x: xText, y: absMinY + margin, width: kIndicatorTextWidth, height: kIndicatorTextHeight)
        indicatorText.contentsScale = UIScreen.main.scale
        indicatorText.alignmentMode = kCAAlignmentCenter
        indicatorText.add(setupEndingAnimation(), forKey: kOpacityAnimetionKeyPath)
        
        self.layer.addSublayer(indicatorText)
    }
    
    private func setupEndingAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: kOpacityAnimetionKeyPath)
        animation.duration = 1.0
        animation.beginTime = CACurrentMediaTime() + 1.0
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeBoth
        return animation
    }
    
    private func moveTo(_ index: Int) {
        setupTitleText(titles[index])
        moveIndicatorTo(index)
        previousIndex = index
    }
    
    private func moveIndicatorTo(_ index: Int) {
        let cgPoint = cgPoints[index]
        let xText = cgPoint.x - kIndicatorTextWidth / 2
        let absMinY = bounds.height / 2 + bounds.height * kHeightRatio / 2
        let margin: CGFloat = 10
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: cgPoint.x, y: cgPoint.y))
        path.addLine(to: CGPoint(x: cgPoint.x, y: absMinY + margin))
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: cgPoint.x, y: cgPoint.y), radius: kIconRadius, startAngle: 0.0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        indicatorIcon.path = circlePath.cgPath
        indicator.path = path.cgPath
        indicatorText.frame = CGRect(x: xText, y: absMinY + margin, width: kIndicatorTextWidth, height: kIndicatorTextHeight)
        indicatorText.string = dates[index].yyyy_mm_dd()
        if #available(iOS 10.0, *), hapticFeedbackEnable {
            UISelectionFeedbackGenerator().selectionChanged()
        }
        CATransaction.commit()
    }

    private func setupGestureRecognizer() {
        let gesture = UIPanGestureRecognizer(target: self, action:  #selector(touchEvent))
        self.addGestureRecognizer(gesture)
    }
    
    @objc func touchEvent(sender: UIPanGestureRecognizer) {
        guard cgPoints.count > 1 else { return }
        
        let x = sender.location(in: self).x
        let width = bounds.width
        let k = width * kWidthRatio / CGFloat(cgPoints.count - 1)
        guard sender.state == .changed, k/2 < abs(x - cgPoints[previousIndex].x) else { return }
        
        if x <= cgPoints[0].x + k/2  {
            moveTo(0)
        } else if x >= cgPoints[cgPoints.count - 1].x - k/2 {
            moveTo(cgPoints.count - 1)
        }
        
        let index = AlgorithmSearch.nearestNeighbor(cgPoints.map {$0.x}, searchItem: x)
        guard previousIndex != index, index > 0, index < cgPoints.count - 1 else { return }
        
        moveTo(index)
    }

}
