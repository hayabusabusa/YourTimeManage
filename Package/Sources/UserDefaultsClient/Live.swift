//
//  Live.swift
//  Package
//
//  Created by Shunya Yamada on 2025/12/04.
//

import Dependencies
import Foundation

extension UserDefaultsClient: DependencyKey {
    public static var liveValue: UserDefaultsClient {
        let userDefaults = UserDefaults.standard
        return .init { key in
            userDefaults.bool(forKey: key)
        } data: { key in
            userDefaults.data(forKey: key)
        } setValue: { value, key in
            userDefaults.set(value, forKey: key)
        } removeValue: { key in
            userDefaults.removeObject(forKey: key)
        }
    }
}

/// `UserDefaults` はスレッドセーフの記載があるため `Sendable` のチェックを外す.
/// `The UserDefaults class is thread-safe.`
extension UserDefaults: @unchecked @retroactive Sendable {}
