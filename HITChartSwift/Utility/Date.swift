//
//  Date.swift
//  HITChartSwift
//
//  Created by hitsubunnu on 2018/03/22.
//  Copyright © 2018年 hitsubunnu. All rights reserved.
//

import Foundation

extension Date {
    /**
     @brief Convert date to yyyy/mm/dd
     */
    func yyyy_mm_dd() -> String {
        let year  = Calendar.current.component(.year, from: self)
        let month = Calendar.current.component(.month, from: self)
        let day   = Calendar.current.component(.day, from: self)
        return "\(year)/\(month)/\(day)"
    }
}
