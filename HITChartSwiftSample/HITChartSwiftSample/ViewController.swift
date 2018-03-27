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
    
    private let data = [
        (date: "2018/02/23", close: 10145.00, open: 9826.50, high: 10395.00, low: 9583.90, volume: 59.07, change: 3.20),
        (date: "2018/02/24", close: 9666.30, open: 10144.00, high: 10499.00, low: 9350.30, volume: 55.70, change: -4.72),
        (date: "2018/02/25", close: 9557.40, open: 9666.30, high: 9840.00, low: 9284.30, volume: 30.52, change: -1.13),
        (date: "2018/02/26", close: 10321.00, open: 9583.00, high: 10437.00, low: 9359.90, volume: 45.94, change: 7.99),
        (date: "2018/02/27", close: 10569.00, open: 10320.00, high: 10880.00, low: 10133.00, volume: 39.72, change: 2.40),
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
        (date: "2018/03/23", close: 8440.00, open: 8703.80, high: 8720.00, low: 8333.40, volume: 60.51, change: -3.06)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // data format
        /// absMax
        let max = abs(data.map{ $0.change }.max() ?? 0)
        let min = abs(data.map{ $0.change }.min() ?? 0)
        let absMax = max > min ? Int(max) : Int(min)
        
        /// date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+9:00")
        let dates: [Date] = data.map { return dateFormatter.date(from: $0.date) ?? Date() }
        
        /// title
        let title = data.map { "BTC/USD closing price: \($0.close) change: \($0.change)%  volume: \($0.volume)" }
        
        // init chart
        let chart = HITYieldCurveChartView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width))
        chart.center = view.center
        chart.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        view.addSubview(chart)
        chart.draw(absMax, values: data.map{ $0.change }, dates: dates, titles: title)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeMultiChart(_:)))
        chart.addGestureRecognizer(tapGesture)
    }
    
    @objc func closeMultiChart(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        view.removeFromSuperview()
    }
}

