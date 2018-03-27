//
//  UIColor.swift
//  HITChartSwift
//
//  Created by hitsubunnu on 2018/03/26.
//  Copyright © 2018年 hitsubunnu. All rights reserved.
//

import UIKit

extension UIColor {
    /**
     @brief Convert hex(Int) colors to UIColor
     
     @param hex:   sRGB(Int)
     @param alpha: Alpha
     */
    class func color(_ hex: Int, alpha: Double = 1.0) -> UIColor {
        let red = Double((hex & 0xFF0000) >> 16) / 255.0
        let green = Double((hex & 0xFF00) >> 8) / 255.0
        let blue = Double((hex & 0xFF)) / 255.0
        
        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
    
    /**
     @brief Convert hex(String) colors to UIColor
     
     @param hex:   sRGB(String)
     @param alpha: Alpha
     */
    class func color(_ hex: String, alpha: CGFloat = 1.0) -> UIColor {
        let hexColor = hex.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: hexColor)
        var color: UInt32 = 0
        if scanner.scanHexInt32(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat((color & 0x0000FF)) / 255.0
            return UIColor(red: r, green: g, blue: b, alpha: alpha)
        } else {
            return UIColor.clear
        }
    }
}
