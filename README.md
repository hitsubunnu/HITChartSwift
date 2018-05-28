# HITChartSwift
A bitcoin and stock chart lib for iOS. Written in Swift.

## Line chart
closing price chart:
<img src="https://github.com/hitsubunnu/HITChartSwift/blob/master/images/close.gif" width="812">

## Candlestick chart
<img src="https://github.com/hitsubunnu/HITChartSwift/blob/master/images/candlestick.gif" width="812">

## Pie chart
<img src="https://github.com/hitsubunnu/HITChartSwift/blob/master/images/pie.gif" width="375">

## Requirements
- iOS 9.0+
- Swift 4

## Sample Project

Build and run the <i>HITChartSwiftSample</i> project in Xcode.

```
git clone git@github.com:hitsubunnu/HITChartSwift.git

cd HITChartSwift

open HITChartSwift.xcworkspace
```

## Installation
<a href="http://cocoapods.org/" target="_blank">CocoaPods</a> is the recommended method of installing HITChartSwift.

### The Pod Way

Simply add the following line to your <code>Podfile</code>:

    platform :ios, '9.0'
    pod 'HITChartSwift'

## Usage 
See [HITChartSwiftSample](https://github.com/hitsubunnu/HITChartSwift/blob/master/HITChartSwiftSample/HITChartSwiftSample/ViewController.swift)

### Source Code Way

#### Import HITChartSwift to your source file
```
import HITChartSwift
```

#### Line Chart
See [Sample](https://github.com/hitsubunnu/HITChartSwift/blob/master/HITChartSwiftSample/HITChartSwiftSample/ViewController.swift#L75)

data format:
```
(date: "2018/02/28", close: 10315.00, open: 10583.00, high: 11063.00, low: 10270.00, volume: 43.89, change: -2.40),
(date: "2018/03/01", close: 10925.00, open: 10316.00, high: 11087.00, low: 10224.00, volume: 33.87, change: 5.91)
```

initialize chart:
```
let chart = HITLineChartView(frame: CGRect(x: 0, y: 0, width: 812, height: 375))
view.addSubview(chart)
chart.draw(absMaxPercentage, 
            values: data.map{ $0.change }, 
            label: (max: "+\(absMaxPercentage)%", center: "", min: "-\(absMaxPercentage)%"),
            dates: dates, 
            titles: titles)
```

#### Candlestick Chart
See [Sample](https://github.com/hitsubunnu/HITChartSwift/blob/master/HITChartSwiftSample/HITChartSwiftSample/ViewController.swift#L107)

data format:
```
(date: "2018/02/28", close: 10315.00, open: 10583.00, high: 11063.00, low: 10270.00, volume: 43.89, change: -2.40),
(date: "2018/03/01", close: 10925.00, open: 10316.00, high: 11087.00, low: 10224.00, volume: 33.87, change: 5.91)
```

initialize chart:
```
let chart = HITCandlestickChartView(frame: CGRect(x: 0, y: 0, width: 812, height: 375))
view.addSubview(chart)
chart.draw(absMaxPercentage,
            values: data.map{ (close: $0.close, open: $0.open, high: $0.high, low: $0.low) },
            label: (max: "+\(absMaxPercentage)%", center: "", min: "-\(absMaxPercentage)%"),
            dates: dates,
            titles: titles)
```

#### Pie Chart
See [Sample](https://github.com/hitsubunnu/HITChartSwift/blob/master/HITChartSwiftSample/HITChartSwiftSample/ViewController.swift#L122)

```
let chart = HITPieChartView(frame: CGRect(x: 0, y: 0, width: 375, height: 375))
view.addSubview(chart)
chart.draw([(value: 50, color: UIColor.red), (value: 20, color: UIColor.blue), (value: 30, color: UIColor.yellow) ],
            strokeWidth: 100,
            animation: true)
```

### Interface Builder Way

Setup custom class to HITLineChartView 

![](https://github.com/hitsubunnu/HITChartSwift/blob/master/images/ib-1.png)

Setup options

![](https://github.com/hitsubunnu/HITChartSwift/blob/master/images/ib-2.png)

### License

HITChartSwift is released under the MIT license. See LICENSE for details.
