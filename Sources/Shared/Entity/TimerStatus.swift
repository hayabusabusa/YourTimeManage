//
//  TimerStatus.swift
//  
//
//  Created by Shunya Yamada on 2021/07/19.
//

import Foundation

/// タイマーの状態を保存するための構造体.
public struct TimerStatus: Codable {
    /// タイマーの秒数.
    public let seconds: Int
    /// タイマーが動いていたかどうか.
    public let isValid: Bool
    /// バックグラウンドに入ったタイミングの `Date`.
    public let enterBackgroundDate: Date
    
    public init(seconds: Int, isValid: Bool, enterBackgroundDate: Date) {
        self.seconds = seconds
        self.isValid = isValid
        self.enterBackgroundDate = enterBackgroundDate
    }
}
