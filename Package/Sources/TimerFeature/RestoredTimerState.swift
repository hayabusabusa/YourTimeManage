//
//  RestoredTimerState.swift
//
//
//  Created by Shunya Yamada on 2024/09/28.
//

import Foundation

/// `UserDefaults` に保存されていたデータから復元したタイマーの状態.
public struct RestoredTimerState: Equatable {
    /// タイマーが有効かどうか.
    public let isTimerActive: Bool
    /// 経過秒数.
    public let secondsElapsed: Int

    init(
        isTimerActive: Bool,
        secondsElapsed: Int
    ) {
        self.isTimerActive = isTimerActive
        self.secondsElapsed = secondsElapsed
    }
}
