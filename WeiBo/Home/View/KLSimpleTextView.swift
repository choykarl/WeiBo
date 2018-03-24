//
//  KLSimpleTextView.swift
//  WeiBo
//
//  Created by karl on 2018/03/21.
//  Copyright © 2018年 Karl. All rights reserved.
//

import UIKit
import CoreText

class KLSimpleTextView: UIView {

    var ctFrame: CTFrame? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.white.setFill()
        UIRectFill(rect)
        guard let ctFrame = ctFrame else { return }
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.textMatrix = CGAffineTransform.identity
        context.translateBy(x: 0, y: self.bounds.height)
        context.scaleBy(x: 1, y: -1)
        CTFrameDraw(ctFrame, context)
    }

}
