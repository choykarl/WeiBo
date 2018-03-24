//
//  KLCTFrameManager.swift
//  WeiBo
//
//  Created by karl on 2018/03/21.
//  Copyright © 2018年 Karl. All rights reserved.
//

import CoreText
import Foundation
import UIKit

func parseStatusesModelCTFrame(_ models: [KLStatusesModel]) {
    for model in models {
        print("\(model.user.screen_name): \(model.text)\n")
        parseSimpleString(model)
        parseStatuesContent(model)
        model.cellHeight = 58 + 10 +  model.ctFrameModel.contentSize.height
    }
}

private func parseSimpleString(_ model: KLStatusesModel) {
    let name = NSMutableAttributedString(string: model.user.screen_name)
    let (nameCtFrame, nameSuggestSize) = parseAttributedString(name)
    model.ctFrameModel.nameCtFrame = nameCtFrame
    model.ctFrameModel.nameSize = nameSuggestSize
    
    let sourceString = model.showTime + "  来自" + model.showSource
    let source = NSMutableAttributedString(string: sourceString)
    source.addAttributes([.foregroundColor: UIColor.gray, .font: UIFont.systemFont(ofSize: 12)], range: NSRange(location: 0, length: sourceString.count))
    let (sourceCtFrame, sourceSuggestSize) = parseAttributedString(source)
    model.ctFrameModel.sourceCtFrame = sourceCtFrame
    model.ctFrameModel.sourceSize = sourceSuggestSize
}

private func parseStatuesContent(_ model: KLStatusesModel) {
    let attributed = NSMutableAttributedString()
//    model.text = "这次Vans为即将到来的夏天准备又推出了款非常亮眼的联名系列。以两双经典的Era鞋款，共有粉和蓝两个颜色可选，和普通款比较不同的是，这两双鞋使用软绵绵的灯芯绒打造，看起来就超舒服，也非常有夏天悠闲的感觉。这样质感满满的联名款，这么少女的鞋款男生就不要想啦。"
    func createPartModel(_ partType: KLPartType, range: Range<String.Index>) -> KLPartModel {
        let partModel = KLPartModel()
        partModel.partType = partType
        if partType == .at {
            let tempRange = NSRange(range, in: model.text)
            let nsRange = NSRange(location: tempRange.location, length: tempRange.length)
            partModel.text = String(model.text[Range(nsRange, in: model.text)!])
            partModel.range = nsRange
        } else {
            partModel.text = String(model.text[range])
            partModel.range = NSRange(range, in: model.text)
        }
        return partModel
    }
    
    var partModoels = [KLPartModel]()
    func enumerateMatches(_ pattern: String, partType: KLPartType) {
        try? model.text.enumerateMatches(pattern: pattern, range: NSRange(location: 0, length: model.text.count)) { (range, _) in
            let partModel = createPartModel(partType, range: range)
            partModoels.append(partModel)
        }
    }
    let topicPattern = "#.*?#"
    let atPattern = "@.*?[ :：]"
    let emojiPattern = "\\[.*?\\]"
    enumerateMatches(topicPattern, partType: .topic)
    enumerateMatches(atPattern, partType: .at)
    enumerateMatches(emojiPattern, partType: .emoji)
    
    try? model.text.enumerateSeparatedByRegex(pattern: "\(topicPattern)|\(atPattern)|\(emojiPattern)", range: NSRange(location: 0, length: model.text.count)) { (range, _) in
        let partModel = KLPartModel()
        partModel.partType = .none
        partModel.text = String(model.text[range])
        partModel.range = NSRange(range, in: model.text)
        partModoels.append(partModel)
    }
    
    model.partModels = partModoels.sorted(by: {$0.range.location < $1.range.location})
    model.specialPartModels = model.partModels.filter({$0.partType != .none})
    
    for partModel in model.partModels {
        switch partModel.partType {
        case .none:
            let tempAttributed = NSMutableAttributedString(string: partModel.text)
            tempAttributed.addAttributes([.font : UIFont.systemFont(ofSize: 18)], range: NSRange(location: 0, length: partModel.text.count))
            attributed.append(tempAttributed)
        case .at:
            let tempAttributed = NSMutableAttributedString(string: partModel.text)
            tempAttributed.addAttributes([.foregroundColor: UIColor.blue, .font : UIFont.systemFont(ofSize: 18)], range: NSRange(location: 0, length: partModel.text.count))
            attributed.append(tempAttributed)
        case .link, .topic:
            let tempAttributed = NSMutableAttributedString(string: partModel.text)
            tempAttributed.addAttributes([.foregroundColor: UIColor.blue, .font : UIFont.systemFont(ofSize: 18)], range: NSRange(location: 0, length: partModel.text.count))
            attributed.append(tempAttributed)
        case .emoji:
            break
        }
    }
    
    for partModel in model.partModels {
        if partModel.partType == .emoji {
            partModel.emotionInfo = KLEmotionInfo()
            partModel.emotionInfo?.emotionName = partModel.text
            let emotionAttributedString = parseEmotionAttributedString(partModel)
            if partModel.range.location > attributed.length {
                attributed.insert(emotionAttributedString, at: attributed.length)
            } else {
                attributed.insert(emotionAttributedString, at: partModel.range.location)
            }
        }
    }
    
    
    let paragraphStyle = NSMutableParagraphStyle()
//    paragraphStyle.firstLineHeadIndent = 14
//    paragraphStyle.headIndent = 14
//    paragraphStyle.tailIndent = -14
    paragraphStyle.lineSpacing = 5
    attributed.addAttributes([.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: attributed.string.count))
    
    let (ctFrame, size) = parseAttributedString(attributed)
    model.ctFrameModel.contentCtFrame = ctFrame
    model.ctFrameModel.contentSize = size
    parseImageData(frame: ctFrame)
}

func parseEmotionAttributedString( _ partModel: KLPartModel) -> NSMutableAttributedString {
    let char: UniChar = 0xFFFC
    let content = String(repeating: Character(UnicodeScalar(char)!), count: partModel.range.length)
    let space = NSMutableAttributedString(string: content)

    space.addAttributes([NSAttributedStringKey.font : UIFont.systemFont(ofSize: 0.001)], range: NSRange(location: 0, length: partModel.range.length))
    var callbaces = CTRunDelegateCallbacks(version: kCTRunDelegateVersion1, dealloc: { (_) in
    }, getAscent: { (_) -> CGFloat in
        return 22
    }, getDescent: { (_) -> CGFloat in
        return 0
    }) { (_) -> CGFloat in
        return 22
    }
    let delegate = CTRunDelegateCreate(&callbaces, &partModel.emotionInfo)
    CFAttributedStringSetAttribute(space, CFRange(location: 0, length: 1), kCTRunDelegateAttributeName, delegate)
    return space
}

private func parseImageData(frame: CTFrame) {
    
    guard let lineArray = CTFrameGetLines(frame) as? [CTLine] else { return }
    var origins = [CGPoint](repeating: CGPoint.zero, count:lineArray.count)
    CTFrameGetLineOrigins(frame, CFRange(location: 0, length: 0), &origins)
    for (i, line) in lineArray.enumerated() {
        let linePoint = origins[i]
        guard let runArray = CTLineGetGlyphRuns(line) as? [CTRun] else { continue }
        for run in runArray {
            let attributes = CTRunGetAttributes(run) as Dictionary
            guard let delegate = attributes[kCTRunDelegateAttributeName] else {
                continue
            }
            
            // 获取代理绑定的数据
            let emotionInfo = CTRunDelegateGetRefCon(delegate as! CTRunDelegate).load(as: KLEmotionInfo.self)
            
            var ascent: CGFloat = 0
            var descent: CGFloat = 0
            
            let width = CGFloat(CTRunGetTypographicBounds(run, CFRange(location: 0, length: 0), &ascent, &descent, nil))
            let height = ascent + descent
            var offsetX: CGFloat = 0
            CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, &offsetX)
            let x = offsetX + linePoint.x
//            let y = linePoint.y - descent
            let y = linePoint.y - 5
            
            let bounds = CGRect(x: x, y: y, width: width, height: height)
            
            let path = CTFrameGetPath(frame)
            let pathRect = path.boundingBox
            let imageBounds = bounds.offsetBy(dx: pathRect.minX, dy: pathRect.minY)
            emotionInfo.rect = imageBounds
        }
    }
}

private func parseAttributedString(_ attributedString: NSMutableAttributedString) -> (CTFrame, CGSize) {
    let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
    
    let drawPathWidth = UIScreen.main.bounds.size.width
    let suggestSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(location: 0, length: 0), nil, CGSize(width: drawPathWidth, height: CGFloat(MAXFLOAT)), nil)
    
    let path = CGMutablePath()
    path.addRect(CGRect(x: 0, y: 0, width: suggestSize.width + 1, height: suggestSize.height))
    
    let frame = CTFramesetterCreateFrame(framesetter, CFRange(location: 0, length: 0), path, nil)
    return (frame, suggestSize)
}
