//
//  KLNetworkEngine.swift
//  WeiBo
//
//  Created by karl on 2018/03/19.
//  Copyright © 2018年 Karl. All rights reserved.
//

import UIKit
import Alamofire

private func +=(l: [String: Any]?, r: [String: Any]) -> [String: Any] {
    guard var param = l else {
        return r
    }
    for (k, v) in r {
        param[k] = v
    }
    return param
}

class KLNetworkEngine: NSObject {
    
    private static var baseParam: [String: Any] {
        return ["access_token" : "\(AcessToken)"]
    }
    
    static func get(url: String, param: [String: Any]? = nil, completion: @escaping (DataResponse<Any>) -> ()) {
        Alamofire.request(url, parameters: param += baseParam).responseJSON { (data) in
            completion(data)
        }
    }
}
