//
//  ViewController.swift
//  HITChartSwiftSample
//
//  Created by bunu on 2018/03/22.
//  Copyright © 2018年 hitsubunnu. All rights reserved.
//

import UIKit
import HITChartSwift

class ViewController: UIViewController {
    @IBOutlet weak var displayView: UIView!
    
    private let data = [
        (date: "2018/02/28", close: 10315.00, open: 10583.00, high: 11063.00, low: 10270.00, volume: 43.89, change: -2.40),
        (date: "2018/03/01", close: 10925.00, open: 10316.00, high: 11087.00, low: 10224.00, volume: 33.87, change: 5.91),
        (date: "2018/03/02", close: 11025.00, open: 10908.00, high: 11189.00, low: 10766.00, volume: 28.86, change: 0.92),
        (date: "2018/03/03", close: 11440.00, open: 11024.00, high: 11526.00, low: 11024.00, volume: 30.65, change: 3.76),
        (date: "2018/03/04", close: 11501.00, open: 11454.00, high: 11544.00, low: 11061.00, volume: 28.07, change: 0.53),
        (date: "2018/03/05", close: 11416.00, open: 11497.00, high: 11696.00, low: 11390.00, volume: 27.56, change: -0.74),
        (date: "2018/03/06", close: 10720.00, open: 11403.00, high: 11403.00, low: 10578.00, volume: 44.24, change: -6.10),
        (date: "2018/03/07", close: 9902.90, open: 10779.00, high: 10899.00, low: 9422.09, volume: 75.22, change: -7.62),
        (date: "2018/03/08", close: 9300.00, open: 9910.70, high: 10109.00, low: 9037.00, volume: 67.75, change: -6.09),
        (date: "2018/03/09", close: 9217.00, open: 9301.90, high: 9420.50, low: 8351.00, volume: 98.20, change: -0.89),
        (date: "2018/03/10", close: 8762.00, open: 9216.20, high: 9500.00, low: 8691.10, volume: 52.54, change: -4.94),
        (date: "2018/03/11", close: 9528.00, open: 8764.40, high: 9726.10, low: 8429.00, volume: 70.48, change: 8.74),
        (date: "2018/03/12", close: 9121.00, open: 9528.00, high: 9894.70, low: 8776.80, volume: 67.58, change: -4.27),
        (date: "2018/03/13", close: 9135.00, open: 9130.20, high: 9479.00, low: 8827.70, volume: 61.54, change: 0.15),
        (date: "2018/03/14", close: 8186.60, open: 9135.20, high: 9400.10, low: 7923.80, volume: 78.81, change: -10.38),
        (date: "2018/03/15", close: 8252.90, open: 8181.30, high: 8416.70, low: 7666.30, volume: 82.58, change: 0.81),
        (date: "2018/03/16", close: 8251.00, open: 8250.10, high: 8602.70, low: 7903.20, volume: 56.34, change: -0.02),
        (date: "2018/03/17", close: 7851.00, open: 8250.00, high: 8350.10, low: 7729.50, volume: 48.97, change: -4.85),
        (date: "2018/03/18", close: 8200.20, open: 7832.00, high: 8285.60, low: 7240.00, volume: 88.92, change: 4.45),
        (date: "2018/03/19", close: 8600.10, open: 8209.00, high: 8689.90, low: 8100.00, volume: 73.28, change: 4.88),
        (date: "2018/03/20", close: 8899.70, open: 8600.20, high: 9025.00, low: 8309.60, volume: 54.28, change: 3.48),
        (date: "2018/03/21", close: 8900.10, open: 8899.80, high: 9175.20, low: 8755.70, volume: 42.86, change: 0.00),
        (date: "2018/03/22", close: 8706.44, open: 8888.60, high: 9088.00, low: 8453.10, volume: 54.42, change: -2.18),
        (date: "2018/03/23", close: 8908.00, open: 8703.80, high: 8910.00, low: 8272.80, volume: 44.91, change: 2.32),
        (date: "2018/03/24", close: 8535.00, open: 8911.40, high: 9040.20, low: 8463.00, volume: 44.21, change: -4.19),
        (date: "2018/03/25", close: 8445.10, open: 8525.00, high: 8673.90, low: 8373.00, volume: 30.69, change: -1.05),
        (date: "2018/03/26", close: 8119.10, open: 8445.00, high: 8496.40, low: 7839.09, volume: 56.38, change: -3.86),
        (date: "2018/03/27", close: 7784.50, open: 8128.00, high: 8209.00, low: 7727.00, volume: 50.41, change: -4.12),
        (date: "2018/03/28", close: 7870.00, open: 7784.50, high: 8118.00, low: 7725.00, volume: 42.74, change: 1.10)
    ]

    private var absMaxPercentage = 0
    private var dates = [Date]()
    private var titles = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        formatData()
    }
    
    private func formatData() {
        /// absMaxPercentage
        let maxChange = abs(data.map{ $0.change }.max() ?? 0.0).rounded(.up)
        let minChange = abs(data.map{ $0.change }.min() ?? 0.0).rounded(.up)
        absMaxPercentage = Int(maxChange > minChange ? maxChange : minChange)

        /// date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+9:00")
        dates = data.map { return dateFormatter.date(from: $0.date) ?? Date() }
        
        /// title
        titles = data.map { "BTC/USD closing price: \($0.close) change: \($0.change)%  volume: \($0.volume)" }
        
        tapPieChart(self)
    }
    
    @IBAction func tapLineChart(_ sender: Any) {
        let chart = HITLineChartView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: displayView.bounds.height))
        displayView.addSubview(chart)
        let max = String((data.map{ $0.close }.max() ?? 0.0).rounded(.up))
        let min = String((data.map{ $0.close }.min() ?? 0.0).rounded(.down))
        chart.draw(absMaxPercentage,
                   values: data.map{ $0.change },
                   label: (max: max, center: "", min: min),
                   dates: dates,
                   titles: titles)
        
        addCloseEvent(chart)
    }
    
    @IBAction func tapLineChartLandscape(_ sender: Any) {
        let chart = HITLineChartView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width))
        chart.center = view.center
        chart.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        view.addSubview(chart)
        let max = String((data.map{ $0.close }.max() ?? 0.0).rounded(.up))
        let min = String((data.map{ $0.close }.min() ?? 0.0).rounded(.down))
        chart.draw(absMaxPercentage,
                   values: data.map{ $0.change },
                   label: (max: max, center: "", min: min),
                   dates: dates,
                   titles: titles)
        
        addCloseEvent(chart)
    }

    @IBAction func tapYieldCurveChart(_ sender: Any) {
        let chart = HITLineChartView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width))
        chart.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        chart.center = view.center
        view.addSubview(chart)
        chart.draw(absMaxPercentage,
                   values: data.map{ $0.change },
                   label: (max: "+\(absMaxPercentage)%", center: "0%", min: "-\(absMaxPercentage)%"),
                   dates: dates,
                   titles: titles)
        
        addCloseEvent(chart)
    }

    @IBAction func tapCandlestickChart(_ sender: Any) {
        let chart = HITCandlestickChartView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: displayView.bounds.height))
        displayView.addSubview(chart)
        chart.draw(absMaxPercentage,
                   values: data.map{ (close: $0.close, open: $0.open, high: $0.high, low: $0.low) },
                   label: (max: "+\(absMaxPercentage)%", center: "", min: "-\(absMaxPercentage)%"),
                   dates: dates,
                   titles: titles)
        
        addCloseEvent(chart)
    }
    
    @IBAction func tapCandlestickChartLandscape(_ sender: Any) {
        let chart = HITCandlestickChartView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width))
        chart.center = view.center
        chart.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        view.addSubview(chart)
        chart.draw(absMaxPercentage,
                   values: data.map{ (close: $0.close, open: $0.open, high: $0.high, low: $0.low) },
                   label: (max: "+\(absMaxPercentage)%", center: "", min: "-\(absMaxPercentage)%"),
                   dates: dates,
                   titles: titles)
        
        addCloseEvent(chart)
    }
    
    @IBAction func tapPieChart(_ sender: Any) {
        let chart = HITPieChartView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        displayView.addSubview(chart)
        chart.center.x = displayView.center.x
        chart.draw([(value: 50, color: UIColor.red), (value: 20, color: UIColor.blue), (value: 30, color: UIColor.yellow) ],
                   strokeWidth: 80,
                   animation: true)
        
        addCloseEvent(chart)
    }
    
    private func addCloseEvent(_ chart: UIView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeChart(_:)))
        chart.addGestureRecognizer(tapGesture)
    }
    
    @objc func closeChart(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        view.removeFromSuperview()
    }
}

