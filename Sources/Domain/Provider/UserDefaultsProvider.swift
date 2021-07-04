//
//  UserDefaultsProvider.swift
//  Domain
//
//  Created by Shunya Yamada on 2021/03/15.
//

import Foundation

public protocol UserDefaultsProviderProtocol: AnyObject {
    /// 基本的な型のオブジェクトを `UserDefaults` に保存する.
    /// - Parameters:
    ///   - value: 保存したいオブジェクト
    ///   - key: 保存するキー
    func set(value: Any, forKey key: UserDefaultsProvider.Key)
    
    /// `Enum` を `UserDefaults` に保存する.
    /// - Parameters:
    ///   - value: 保存したい `Enum`
    ///   - key: 保存するキー
    func setEnum<T: RawRepresentable>(value: T, forKey key: UserDefaultsProvider.Key)
    
    /// `Encodable` 準拠のオブジェクトを `UserDefaults` に保存する
    /// - Parameters:
    ///   - value: 保存したい `Encodable` 準拠のオブジェクト
    ///   - key: 保存するキー
    func setEncodable<T: Encodable>(value: T, forKey key: UserDefaultsProvider.Key)
    
    /// 保存したオブジェクトを読み込む
    /// - Parameters:
    ///   - type: 読み込みたいオブジェクトの型
    ///   - key: 保存の際に使用したキー
    /// - Returns: 読み込んだオブジェクト( `Optional` )
    func object<T>(type: T.Type, forKey key: UserDefaultsProvider.Key) -> T?
    
    /// 保存した `Enum` を読み込む
    /// - Parameters:
    ///   - type: 読み込みたい `Emum` の型
    ///   - key: 保存の際に使用したキー
    /// - Returns: 読み込んだ `Enum`( `Optional` )
    func enumObject<T: RawRepresentable>(type: T.Type, forKey key: UserDefaultsProvider.Key) -> T?
    
    /// 保存した `Decodable` 準拠のオブジェクトを読み込む
    /// - Parameters:
    ///   - type: 読み込みたい `Decodable` 準拠のオブジェクトの型
    ///   - key: 保存の際に使用したキー
    /// - Returns: 読み込んだオブジェクト( `Optional` )
    func decodableObject<T: Decodable>(type: T.Type, forKey key: UserDefaultsProvider.Key) -> T?
    
    /// 保存したオブジェクトを削除する
    /// - Parameter key: 削除したいオブジェクトのキー
    func removeObject(forKey key: UserDefaultsProvider.Key)
}

public final class UserDefaultsProvider {
    
    // MARK: Singletone
        
    public static let shared: UserDefaultsProvider = .init()
    
    // MARK: Properties
    
    private let userDefaults: UserDefaults
    
    public enum Key: String {
        /// 以前のアプリで使用していた保存したデータ一覧を取得するためのキー
        case oldList = "yourList"
        /// 依存のアプリで使用していた目標を取得するためのキー
        case oldTarget = "yourTarget"
        ///　依存のアプリで使用していた目標時間を取得するためのキー
        case oldTargetTime = "yourTargetTime"
    }
    
    // MARK: Initializer
    
    private init() {
        userDefaults = UserDefaults.standard
    }
    
    // MARK: Save
    
    public func set(value: Any, forKey key: Key) {
        userDefaults.set(value, forKey: key.rawValue)
    }
    
    public func setEnum<T: RawRepresentable>(value: T, forKey key: Key) {
        userDefaults.set(value.rawValue, forKey: key.rawValue)
    }
    
    public func setEncodable<T: Encodable>(value: T, forKey key: Key) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        userDefaults.set(data, forKey: key.rawValue)
    }
    
    // MARK: Load
    
    public func object<T>(type: T.Type, forKey key: Key) -> T? {
        return userDefaults.object(forKey: key.rawValue) as? T
    }
    
    public func enumObject<T: RawRepresentable>(type: T.Type, forKey key: Key) -> T? {
        guard let rawValue = userDefaults.object(forKey: key.rawValue) as? T.RawValue else { return nil }
        return T.init(rawValue: rawValue)
    }
    
    public func decodableObject<T: Decodable>(type: T.Type, forKey key: Key) -> T? {
        guard let data = userDefaults.data(forKey: key.rawValue) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
    
    // MARK: Remove
    
    public func removeObject(forKey key: Key) {
        userDefaults.removeObject(forKey: key.rawValue)
    }
}
