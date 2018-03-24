//
//  KLEmotionManager.swift
//  WeiBo
//
//  Created by karl on 2018/03/23.
//  Copyright © 2018年 Karl. All rights reserved.
//

import UIKit

class KLEmotionManager: NSObject {
    static let shared = KLEmotionManager()
    private(set) var emotions = [KLEmotion]()
    private var emotionDict = [String: KLEmotion]()
    
    private override init() {
        super.init()
        createEmotions()
    }
    
    private func createEmotions() {
        guard let path = Bundle.main.path(forResource: "EmotionsInfo", ofType: "plist") else {
            return
        }
        guard let dict = NSDictionary(contentsOfFile: path), let array = dict["emoticons"] else {
            return
        }
        guard let data = try? JSONSerialization.data(withJSONObject: array, options: .prettyPrinted) else {
            return
        }
        guard let emotionArray = try? JSONDecoder().decode([KLEmotion].self, from: data) else {
            return
        }
        emotions = emotionArray
    }
}

extension KLEmotionManager {
    func emotion(_ key: String) -> KLEmotion? {
        if let emotion = emotionDict[key] {
            return emotion
        }
        
        for emotion in emotions {
            if emotion.cht == key {
                emotionDict[key] = emotion
                return emotion
            }
        }
        return nil
    }
}
