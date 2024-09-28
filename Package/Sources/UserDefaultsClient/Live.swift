//
//  Live.swift
//
//
//  Created by Shunya Yamada on 2024/09/22.
//

import Dependencies
import Foundation

extension UserDefaultsClient: DependencyKey {
    public static var liveValue: UserDefaultsClient {
        Self.live()
    }

    private static func live() -> UserDefaultsClient {
        let userDefaults = UserDefaults.standard
        let jsonDecoder = JSONDecoder()
        let jsonEncoder = JSONEncoder()

        return .init { key in
            userDefaults.bool(forKey: key)
        } integer: { key in
            userDefaults.integer(forKey: key)
        } data: { key in
            userDefaults.data(forKey: key)
        } date: { key in
            guard let data = userDefaults.data(forKey: key),
                  let date = try? jsonDecoder.decode(Date.self, from: data) else {
                return nil
            }
            return date
        } setValue: { arguments in
            userDefaults.set(arguments.value, forKey: arguments.key)
        } setEncodableValue: { arguments in
            guard let data = try? jsonEncoder.encode(arguments.value) else {
                return
            }
            userDefaults.set(data, forKey: arguments.key)
        } removeValue: { key in
            userDefaults.removeObject(forKey: key)
        }
    }
}

/// `UserDefaults` はスレッドセーフの記載があるため `Sendable` のチェックを外す.
/// `The UserDefaults class is thread-safe.`
extension UserDefaults: @unchecked Sendable {}
