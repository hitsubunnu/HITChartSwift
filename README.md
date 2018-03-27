# HITChartSwift
A bitcoin and stock chart lib for iOS. Written in Swift.

yield curve chart:
![](https://github.com/hitsubunnu/HITChartSwift/blob/master/images/yieldcurve.gif)

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
    pod 'HITChartSwift', :git => 'https://github.com/hitsubunnu/HITChartSwift.git'

## Usage

### Source Code Way

#### Import HITChartSwift to your source file
```
import HITChartSwift
```

```
let chart = YieldCurveChartView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width))
view.addSubview(chart)
chart.draw(absMax, values: data.map{ $0.change }, dates: dates, titles: title)
```
See [HITChartSwiftSample](https://github.com/hitsubunnu/HITChartSwift/blob/master/HITChartSwiftSample/HITChartSwiftSample/ViewController.swift)

### Interface Builder Way

####Setup custom class to YieldCurveChartView 

![](https://github.com/hitsubunnu/HITChartSwift/blob/master/images/ib-1.png)

####Setup options

![](https://github.com/hitsubunnu/HITChartSwift/blob/master/images/ib-2.png)

### License

HITChartSwift is released under the MIT license. See LICENSE for details.
