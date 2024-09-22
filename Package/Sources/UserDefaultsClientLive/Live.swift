//
//  Live.swift
//
//
//  Created by Shunya Yamada on 2024/09/22.
//

@_exported import UserDefaultsClient

import Dependencies
import Foundation

extension UserDefaultsClient: DependencyKey {
    public static var liveValue: UserDefaultsClient {
        Self.live()
    }

    private static func live() -> UserDefaultsClient {
        let userDefaults = UserDefaults.standard

        return .init { key in
            userDefaults.bool(forKey: key)
        } integer: { key in
            userDefaults.integer(forKey: key)
        } setValue: { arguments in
            userDefaults.set(arguments.value, forKey: arguments.key)
        } removeValue: { key in
            userDefaults.removeObject(forKey: key)
        }
    }
}

/// `UserDefaults` はスレッドセーフの記載があるため `Sendable` のチェックを外す.
/// `The UserDefaults class is thread-safe.`
extension UserDefaults: @unchecked Sendable {}
