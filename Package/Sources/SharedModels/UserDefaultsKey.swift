//
//  UserDefaultsKey.swift
//
//
//  Created by Shunya Yamada on 2024/09/22.
//

import Foundation

/// `UserDefaults` にデータを保存する際に利用するキー.
public enum UserDefaultsKey: String {
    /// タイマーが起動中かどうかのフラグ.
    case isTimerActive
    /// タイマーの経過秒数.
    case secondsElapsed
}
