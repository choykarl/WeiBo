//
//  KLCTFrameModel.swift
//  WeiBo
//
//  Created by karl on 2018/03/22.
//  Copyright © 2018年 Karl. All rights reserved.
//

import UIKit

class KLCTFrameModel: NSObject, Codable {
    var a = ""
    var nameCtFrame: CTFrame? = nil
    var nameSize = CGSize.zero
    var sourceCtFrame: CTFrame? = nil
    var sourceSize = CGSize.zero
    var contentCtFrame: CTFrame? = nil
    var contentSize = CGSize.zero
    enum CodingKeys: String, CodingKey {
        case a
    }
}
