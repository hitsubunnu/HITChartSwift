//
//  HITCandlestickChartView
//  HITChartSwift
//
//  Created by hitsubunnu on 2018/03/22.
//  Copyright © 2018年 hitsubunnu. All rights reserved.
//

import UIKit

open class HITCandlestickChartView: UIView {
    @IBInspectable var background: UIColor = UIColor.white
    @IBInspectable var upColor: UIColor = UIColor.color("0x639a08")
    @IBInspectable var downColor: UIColor = UIColor.color("0xe60170")
    @IBInspectable var titleColor: UIColor = UIColor.color("0x0099aa")
    @IBInspectable var indicatorColor: UIColor = UIColor.color("0x0099aa")
    @IBInspectable var backgroundLineColor: UIColor = UIColor.color("0xe6e6e6")
    @IBInspectable var textColor: UIColor = UIColor.color("0x333333")
    @IBInspectable var hapticFeedbackEnable: Bool = true

    
    private let kCandlestickWidth: CGFloat = 10.0
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
    
    private var absMaxPercentage = 0
    private var max: Double = 0
    private var min: Double = 0
    private var values = [(close: Double, open: Double, high: Double, low: Double)]()
    private var dates = [Date]()
    private var titles = [String]()
    private var previousIndex = 0
    private var cgPoints = [CGPoint]()
    
    private let titleText = CATextLayer()
    private let indicator = CAShapeLayer()
    private let indicatorIcon = CAShapeLayer()
    private let indicatorText = CATextLayer()
    
    public func draw(_ absMax: Int,
                     values: [(close: Double, open: Double, high: Double, low: Double)],
                     label: (max: String, center: String, min: String),
                     dates: [Date],
                     titles: [String]) {
        
        self.layer.sublayers?.removeAll()
        self.absMaxPercentage = absMax
        self.max = values.map{ $0.high }.max() ?? 0.0
        self.min = values.map{ $0.low }.min() ?? 0.0
        self.values = values
        self.dates = dates
        self.titles = titles
        self.previousIndex = values.count - 1
        
        setupBackground(max: label.max, center: label.center, min: label.min)
        setupTitle()
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
        layer.lineJoin = CAShapeLayerLineJoin.round
        layer.lineDashPattern = [NSNumber(value: 2)]
        layer.contentsScale = UIScreen.main.scale
        
        self.layer.addSublayer(layer)
    }
    
    private func setupBackgroundText(x: CGFloat, y: CGFloat, string: String) {
        let text = CATextLayer()
        let textWidth: CGFloat = 30.0
        let textHeight: CGFloat = 12.0
        let xText = x - textWidth
        let yText = y - textHeight / 2
        text.string = string
        text.foregroundColor = textColor.cgColor
        text.fontSize = Dimens.Txt.s.rawValue
        text.font = UIFont.systemFont(ofSize: Dimens.Txt.s.rawValue)
        text.frame = CGRect(x: xText, y: yText, width: textWidth, height: textHeight)
        text.contentsScale = UIScreen.main.scale
        text.alignmentMode = CATextLayerAlignmentMode.left
        
        self.layer.addSublayer(text)
    }

    private func drawChart(values: [(close: Double, open: Double, high: Double, low: Double)]) {
        guard values.count > 0 else { return }
        
        let width = bounds.width
        var x = width * (1 - kWidthRatio) / 2

        for value in values {
            drawCandlestick(x: x, close: value.close, open: value.open, high: value.high, low: value.low)
            x += kCandlestickWidth + 1
        }
    }
    
    private func drawCandlestick(x: CGFloat, close: Double, open: Double, high: Double, low: Double) {
        let color = open < close ? upColor.cgColor : downColor.cgColor

        // low-high line
        let xLine = x + kCandlestickWidth / 2
        let yHigh = getY(high)
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: xLine, y: yHigh))
        linePath.addLine(to: CGPoint(x: xLine, y: getY(low)))
        cgPoints.append(CGPoint(x: xLine, y: yHigh))

        let lineLayer = CAShapeLayer()
        lineLayer.path = linePath.cgPath
        lineLayer.strokeColor = color
        lineLayer.lineWidth = 1
        layer.contentsScale = UIScreen.main.scale
        self.layer.addSublayer(lineLayer)

        // open-close rectangle
        let y = open < close ? getY(open) : getY(close)
        var height = open < close ?  getY(open) - getY(close) : getY(close) - getY(open)
        if height < 0.5 {
            height = 0.5
        }

        let rectPath = UIBezierPath(rect: CGRect(x: x, y: y, width: kCandlestickWidth, height: height))
        
        let rectLayer = CAShapeLayer()
        rectLayer.path = rectPath.cgPath
        rectLayer.fillColor = color
        layer.contentsScale = UIScreen.main.scale

        self.layer.addSublayer(rectLayer)
    }

    private func getChangePercentage(value: Double, close: Double, change: Double) -> Double {
        let prevChange = close + close * change * 0.01
        return (value - prevChange) / prevChange
    }
    
    /**
     * @brief base on absMax, seek Y coordinate
     */
    private func getY(_ pointY: Double?) -> CGFloat {
        let height = bounds.height
        let chartHeight: CGFloat =  kHeightRatio * height
        let heightMargin: CGFloat = (1 - kHeightRatio) * height / 2
        guard let pointY = pointY else { return chartHeight + heightMargin }
        guard max != min else {return chartHeight + heightMargin}

        return CGFloat( (max - pointY) / (max - min) ) * chartHeight + heightMargin
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
        titleText.alignmentMode = CATextLayerAlignmentMode.left
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
        indicator.lineJoin = CAShapeLayerLineJoin.round
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
        indicatorText.alignmentMode = CATextLayerAlignmentMode.center
        indicatorText.foregroundColor = UIColor.white.cgColor
        indicatorText.backgroundColor = indicatorColor.cgColor
        indicatorText.fontSize = Dimens.Txt.s.rawValue
        indicatorText.font = UIFont.boldSystemFont(ofSize: 9)
        indicatorText.frame = CGRect(x: xText, y: absMinY + margin, width: kIndicatorTextWidth, height: kIndicatorTextHeight)
        indicatorText.contentsScale = UIScreen.main.scale
        indicatorText.alignmentMode = CATextLayerAlignmentMode.center
        indicatorText.add(setupEndingAnimation(), forKey: kOpacityAnimetionKeyPath)
        
        self.layer.addSublayer(indicatorText)
    }
    
    private func setupEndingAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: kOpacityAnimetionKeyPath)
        animation.duration = 1.0
        animation.beginTime = CACurrentMediaTime() + 0.02
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.both
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
