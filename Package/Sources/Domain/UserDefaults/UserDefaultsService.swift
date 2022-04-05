//
//  UserDefaultsService.swift
//  
//
//  Created by Shunya Yamada on 2022/04/03.
//

import Foundation

public struct UserDefaultsService {
    
    public enum Key: String {
        /// 以前のアプリで使用していた保存したデータ一覧を取得するためのキー
        case oldList = "yourList"
        /// 依存のアプリで使用していた目標を取得するためのキー
        case oldTarget = "yourTarget"
        ///　依存のアプリで使用していた目標時間を取得するためのキー
        case oldTargetTime = "yourTargetTime"
    }
    
    /// 基本的な型のオブジェクトを `UserDefaults` に保存する.
    public var setValue: (_ value: Any, _ key: Key) -> Void
    
    /// 保存したオブジェクトを読み込む.
    public var object: (_ key: Key) -> Any?
    
    /// 保存したオブジェクトを削除する.
    public var removeObject: (_ key: Key) -> Void
    
    /// `Encodable` 準拠のオブジェクトを `UserDefaults` に保存する
    func setEncodable<T: Encodable>(value: T, forKey key: Key) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        self.setValue(data, key)
    }
    
    /// 保存したオブジェクトを読み込む.
    func decodableObject<T: Decodable>(type: T.Type, forKey key: Key) -> T? {
        guard let data = self.object(key) as? Data else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
}

public extension UserDefaultsService {
    
    static var live: Self {
        return .init(
            setValue: { value, key in
                UserDefaults.standard.set(value, forKey: key.rawValue)
            },
            object: { key in
                return UserDefaults.standard.object(forKey: key.rawValue)
            },
            removeObject: { key in
                UserDefaults.standard.removeObject(forKey: key.rawValue)
            }
        )
    }
    
    static var noop = Self.init(
        setValue: { _, _ in  },
        object: { _ in return nil },
        removeObject: { _ in }
    )
}
