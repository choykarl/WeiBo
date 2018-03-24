//
//  KLStatusesModel.swift
//  WeiBo
//
//  Created by karl on 2018/03/20.
//  Copyright © 2018年 Karl. All rights reserved.
//

import Foundation
import UIKit
import CoreText

private let dateFormatter = DateFormatter()
class KLStatusesModel: NSObject, Codable {
    var cellHeight: CGFloat?
    private var created_at = ""
    private var source = ""
    var text = ""
    var reposts_count = 0
    var comments_count = 0
    var user: KLUserModel!
    let ctFrameModel = KLCTFrameModel()
    var partModels: [KLPartModel]!
    var specialPartModels: [KLPartModel]!
    
    var showSource: String! {
        return source[source["\">"].upperBound ..< source["</"].lowerBound]
    }
    
    // "Wed Mar 21 22:40:34 +0800 2018"
    var showTime: String! {
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z yyyy"
        guard let date = dateFormatter.date(from: created_at) else {
            return ""
        }
        return date.simpleString
    }
}



