//
//  KLPartModel.swift
//  WeiBo
//
//  Created by karl on 2018/03/22.
//  Copyright © 2018年 Karl. All rights reserved.
//

import UIKit

enum KLPartType:String, Codable {
    case none
    case at
    case link
    case topic
    case emoji
}

class KLPartModel: NSObject, Codable {
    var range = NSRange(location: 0, length: 0)
    var partType = KLPartType.none
    var text = ""
    var emotionInfo: KLEmotionInfo?
}

class KLEmotionInfo: NSObject, Codable {
    var emotionName = ""
    var rect = CGRect.zero
}



