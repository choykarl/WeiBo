//
//  KLNetworkEngine.swift
//  WeiBo
//
//  Created by karl on 2018/03/19.
//  Copyright © 2018年 Karl. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

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
    
    static func get(url: String, param: [String: Any]? = nil, completion: @escaping (DataResponse<String>) -> ()) {
        Alamofire.request(url, parameters: param += baseParam).responseString { (data) in
            completion(data)
        }
    }
}

extension KLNetworkEngine {
    static func getStatuses(completion: @escaping ([KLStatusesModel]) ->()) {
        get(url: "https://api.weibo.com/2/statuses/home_timeline.json") { (data) in
            
            guard case let .success(s) = data.result else {
                return
            }
            guard let json = JSON(parseJSON: s).dictionary else {
                return
            }
            
            guard let statusesString = json["statuses"]?.rawString() else {
                return
            }
            let jsonData = Data(statusesString.utf8)
            let decoder = JSONDecoder()
            guard let models = try? decoder.decode([KLStatusesModel].self, from: jsonData) else {
                return
            }
           
            parseStatusesModelCTFrame(models)
            completion(models)
        }
    }
}
