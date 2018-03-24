//
//  KLAvatarView.swift
//  WeiBo
//
//  Created by karl on 2018/03/21.
//  Copyright © 2018年 Karl. All rights reserved.
//

import UIKit
class KLAvatarView: UIView {
    var image: UIImage? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.white.setFill()
        UIRectFill(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        if let image = image {
            let p = UIBezierPath(ovalIn: CGRect(x: 0.5, y: 0.5, width: rect.width - 1, height: rect.height - 1))
            UIColor.gray.setStroke()
            p.stroke()
            p.lineWidth = 1
            
            let imageRect = CGRect(x: 2, y: 2, width: rect.width - 4, height: rect.height - 4)
            context.addPath(UIBezierPath(roundedRect: imageRect, cornerRadius: imageRect.width / 2).cgPath)
            context.clip()
            image.draw(in: imageRect)
            context.drawPath(using: .fillStroke)
        }
    }
}
