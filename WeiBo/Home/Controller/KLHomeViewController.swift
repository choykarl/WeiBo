//
//  KLHomeViewController.swift
//  WeiBo
//
//  Created by karl on 2018/03/19.
//  Copyright © 2018年 Karl. All rights reserved.
//

import UIKit

class KLHomeViewController: KLBaseViewController {

    private var tableView: KLHomeTableView!
    private var models: [KLStatusesModel]! {
        didSet {
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "首页"
        tableView = KLHomeTableView(frame: view.bounds, style: .plain)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
//        if #available(iOS 11.0, *) {
//            tableView.contentInsetAdjustmentBehavior = .never
//        }
        view.addSubview(tableView)
        
        KLNetworkEngine.getStatuses { (models) in
            self.models = models
        }
    }
}

extension KLHomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? KLHomeTableViewCell
        if cell == nil {
            cell = KLHomeTableViewCell(style: .default, reuseIdentifier: "cell", model: model)
        } else {
            cell?.setModel(model)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return models[indexPath.row].cellHeight ?? 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
