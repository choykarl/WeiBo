//
//  KLHomeTableViewCell.swift
//  WeiBo
//
//  Created by karl on 2018/03/21.
//  Copyright © 2018年 Karl. All rights reserved.
//

import UIKit
import Kingfisher

class KLHomeTableViewCell: UITableViewCell {
    private var model: KLStatusesModel!
    private let avatarView = KLAvatarView()
    private var nameView: KLSimpleTextView!
    private var sourceView: KLSimpleTextView!
    private var statusesContentView: KLContentTextView!
    private let lineView = UIView()
    init(style: UITableViewCellStyle, reuseIdentifier: String?, model: KLStatusesModel) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        avatarView.frame = CGRect(x: 14, y: 15, width: 43, height: 43)
        contentView.addSubview(avatarView)
        
        nameView = KLSimpleTextView(frame: CGRect(origin: CGPoint(x: 70, y: 15), size: CGSize(width: UIScreen.main.bounds.width - 70, height: model.ctFrameModel.nameSize.height)))
        contentView.addSubview(nameView)
        
        sourceView = KLSimpleTextView(frame: CGRect(origin: CGPoint(x: nameView.frame.minX, y: nameView.frame.maxY + 10), size: CGSize(width: UIScreen.main.bounds.width - nameView.frame.minX, height: model.ctFrameModel.sourceSize.height)))
        contentView.addSubview(sourceView)
        
        statusesContentView = KLContentTextView(frame: CGRect(origin: CGPoint(x: 0, y: sourceView.frame.maxY + 10), size: model.ctFrameModel.contentSize))
        contentView.addSubview(statusesContentView)
        
        setModel(model)
        
        lineView.backgroundColor = UIColor.red
        
        addSubview(lineView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let model = model else {
            return
        }
        lineView.frame = CGRect(x: 0, y: model.cellHeight! - 0.5, width: width, height: 0.5)
        statusesContentView.size = CGSize(width: width, height: model.ctFrameModel.contentSize.height)
    }
    
    func setModel(_ model:KLStatusesModel) {
        self.model = model
        KingfisherManager.shared.downloader.downloadImage(with: URL(string: model.user.profile_image_url)!) { (image, error, url, data) in
            self.avatarView.image = image
        }
        nameView.ctFrame = model.ctFrameModel.nameCtFrame
        sourceView.ctFrame = model.ctFrameModel.sourceCtFrame
        statusesContentView.model = model
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
