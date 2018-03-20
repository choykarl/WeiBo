//
//  KLHomeViewController.swift
//  WeiBo
//
//  Created by karl on 2018/03/19.
//  Copyright © 2018年 Karl. All rights reserved.
//

import UIKit
import Alamofire

class KLHomeViewController: KLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "首页"
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        KLNetworkEngine.get(url: "https://api.weibo.com/2/statuses/public_timeline.json") { (data) in
            print(data)
        }
    }
}
