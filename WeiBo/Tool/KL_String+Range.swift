//
//  KL_String+Range.swift
//  WeiBo
//
//  Created by karl on 2018/03/21.
//  Copyright © 2018年 Karl. All rights reserved.
//

import Foundation
extension String {
    public subscript(bounds: CountableRange<Int>) -> String {
        let string = self[index(startIndex, offsetBy: bounds.lowerBound) ..< index(startIndex, offsetBy: bounds.upperBound)]
        return String(string)
    }
    
    public subscript(bounds: CountableClosedRange<Int>) -> String {
        let string = self[index(startIndex, offsetBy: bounds.lowerBound) ... index(startIndex, offsetBy: bounds.upperBound)]
        return String(string)
    }
    
    public subscript(index: Int) -> String {
        let character = self[self.index(startIndex, offsetBy: index)]
        return String(character)
    }
    
    public subscript(subString: String) -> NSRange {
        guard let range = range(of: subString) else {
            return NSRange(location: 0, length: 0)
        }
        return NSRange(range, in: self)
    }
}
