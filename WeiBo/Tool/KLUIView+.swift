//
//  KLUIView+.swift
//  WeiBo
//
//  Created by karl on 2018/03/22.
//  Copyright © 2018年 Karl. All rights reserved.
//

import UIKit
extension UIView {
    var x: CGFloat {
        set{
            frame = CGRect(x: newValue, y: y, width: width, height: height)
        } get {
            return frame.origin.x
        }
    }
    
    var y: CGFloat {
        set{
            frame = CGRect(x: x, y: newValue, width: width, height: height)
        } get {
            return frame.origin.y
        }
    }
    
    var width: CGFloat {
        set{
            frame = CGRect(x: x, y: y, width: newValue, height: height)
        } get {
            return frame.width
        }
    }
    
    var height: CGFloat {
        set{
            frame = CGRect(x: x, y: y, width: width, height: newValue)
        } get {
            return frame.height
        }
    }
    
    var size: CGSize {
        set{
            frame.size = newValue
        } get {
            return frame.size
        }
    }
    
    var origin: CGPoint {
        set{
            frame.origin = newValue
        } get {
            return frame.origin
        }
    }
}
