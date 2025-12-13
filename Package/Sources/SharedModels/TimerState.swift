//
//  TimerState.swift
//  Package
//
//  Created by Shunya Yamada on 2025/12/12.
//

import Foundation

/// `UserDefaults` に保存するタイマーの状態.
public struct TimerState: Sendable, Equatable, Codable {
    /// タイマーが起動中かどうかのフラグ.
    public var isActive: Bool
    /// 経過秒数.
    public var secondsElapsed: Int
    /// バックグラウンドに移行した日時.
    public var didEnterBackgroundDate: Date

    public init(
        isActive: Bool,
        secondsElapsed: Int,
        didEnterBackgroundDate: Date
    ) {
        self.isActive = isActive
        self.secondsElapsed = secondsElapsed
        self.didEnterBackgroundDate = didEnterBackgroundDate
    }
}
