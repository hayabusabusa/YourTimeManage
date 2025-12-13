//
//  Client.swift
//  Package
//
//  Created by Shunya Yamada on 2025/12/04.
//

import Dependencies
import DependenciesMacros
import Foundation
import SharedModels

/// `UserDefaults` を利用した処理を行うクライアント.
@DependencyClient
public struct UserDefaultsClient: Sendable {
    /// 保存されている `Bool` の値を返す.
    ///
    /// - note: 指定したキーに紐づく値が存在しない場合はデフォルト値として `false` を返す.
    public var bool: @Sendable (_ key: String) -> Bool = { _ in false }
    /// 保存されている `Data` の値を返す.
    public var data: @Sendable (_ key: String) -> Data?
    /// 値を保存する.
    public var setValue: @Sendable (_ value: Any, _ key: String) -> Void
    /// 保存されている値を削除する.
    public var removeValue: @Sendable (_ key: String) -> Void
}

public extension UserDefaultsClient {
    /// 保存されている `Decodable` 準拠の値を返す.
    /// - Parameter key: 保存の際に指定するキー.
    /// - Returns: 保存されている `Decodable` 準拠の値.
    func decodable<T: Decodable>(forKey key: String) -> T? {
        guard let data = data(key: key),
              let decoded = try? JSONDecoder().decode(T.self, from: data) else {
            return nil
        }
        return decoded
    }
    
    /// `Encodable` 準拠の値を保存する.
    /// - Parameters:
    ///   - value: 保存する値.
    ///   - key: 保存の際に指定したキー.
    func setEncodable<T: Encodable>(
        _ value: T,
        forKey key: String
    ) {
        guard let data = try? JSONEncoder().encode(value) else {
            return
        }
        setValue(
            value: data,
            key: key
        )
    }

    /// 旧アプリで利用していたデータを読み込む.
    var legacyData: [YourStudyData] {
        NSKeyedUnarchiver.setClass(
            YourStudyData.self,
            forClassName: YourStudyData.className
        )
        guard let stored = data(key: .legacyList),
              let unarchived = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(stored) as? [YourStudyData] else {
            return []
        }
        return unarchived
    }
    
    /// 旧アプリで利用していたデータを保存する.
    /// - Parameter data: 保存するデータ一覧.
    func setLegacyData(_ data: [YourStudyData]) {
        var stored = legacyData
        stored.append(contentsOf: data)

        guard let archived = try? NSKeyedArchiver.archivedData(withRootObject: stored, requiringSecureCoding: false) else {
            return
        }
        setValue(
            value: archived,
            key: .legacyList
        )
    }
    
    /// 保存していたタイマーの状態を取得する.
    var timerState: TimerState? {
        decodable(forKey: .timerState)
    }
    
    /// タイマーの状態を保存する.
    /// - Parameter timerState: タイマーの状態.
    func setTimerState(_ timerState: TimerState) {
        setEncodable(
            timerState,
            forKey: .timerState
        )
    }

    /// 保存していたタイマーの状態を削除する.
    func removeTimerState() {
        removeValue(.timerState)
    }
}

// MARK: - Dependencies

extension UserDefaultsClient: TestDependencyKey {
    public static var previewValue: UserDefaultsClient {
        .init { _ in
            false
        } data: { _ in
            Data()
        } setValue: { value, key in
            // 何もしない.
        } removeValue: { key in
            // 何もしない.
        }
    }

    public static var testValue: UserDefaultsClient {
        .init()
    }
}

extension DependencyValues {
    public var userDefaultsClient: UserDefaultsClient {
        get { self[UserDefaultsClient.self] }
        set { self[UserDefaultsClient.self] = newValue }
    }
}

// MARK: - Keys

private extension String {
    /// 以前のアプリで使用していた保存したデータ一覧を取得するためのキー.
    static let legacyList = "yourList"
    /// 依存のアプリで使用していた目標を取得するためのキー.
    static let legacyTarget = "yourTarget"
    ///　依存のアプリで使用していた目標時間を取得するためのキー.
    static let legacyTargetTime = "yourTargetTime"
    /// タイマーの状態を取得するキー.
    static let timerState = "timerState"
}
