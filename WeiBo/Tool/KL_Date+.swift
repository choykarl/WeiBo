//
//  KL_Date+.swift
//  WeiBo
//
//  Created by karl on 2018/03/21.
//  Copyright © 2018年 Karl. All rights reserved.
//

import Foundation
private let dateFormatter = DateFormatter()
extension Date {
    var simpleString: String {
        let interval = -self.timeIntervalSinceNow
        if interval <= 60 {
            return "刚刚"
        } else if interval < 60 * 60 {
            return "\(Int(interval / 60))分钟"
        } else if interval < 24 * 60 * 60 {
            dateFormatter.dateFormat = "HH:mm"
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        }
        return dateFormatter.string(from: self)
    }
}
