//
//  Client.swift
//
//
//  Created by Shunya Yamada on 2024/09/22.
//

import Foundation
import Dependencies

/// `UserDefaults` の操作を行うクライアント.
public struct UserDefaultsClient {
    /// `UserDefaults` に保存している `Bool` の値を読み込む.
    public var bool: @Sendable (String) -> Bool
    /// `UserDefaults` に保存している `Int` の値を読み込む.
    public var integer: @Sendable (String) -> Int?
    /// `UserDefaults` に保存している `Data` の値を読み込む.
    public var data: @Sendable (String) -> Data?
    /// `UserDefaults` に保存している `Date` の値を読み込む.
    public var date: @Sendable (String) -> Date?
    /// `UserDefaults` にデータを保存する.
    public var setValue: @Sendable (SetValueArguments) -> Void
    /// `UserDefaults` に `Encodable` 準拠のデータを保存する.
    public var setEncodableValue: @Sendable (SetEncodableValueArguments) -> Void
    /// `UserDefaults` に保存されているデータを削除する.
    public var removeValue: @Sendable (String) -> Void

    public init(
        bool: @Sendable @escaping (String) -> Bool,
        integer: @Sendable @escaping (String) -> Int?,
        data: @Sendable @escaping (String) -> Data?,
        date: @Sendable @escaping (String) -> Date?,
        setValue: @Sendable @escaping (SetValueArguments) -> Void,
        setEncodableValue: @Sendable @escaping (SetEncodableValueArguments) -> Void,
        removeValue: @Sendable @escaping (String) -> Void
    ) {
        self.bool = bool
        self.integer = integer
        self.data = data
        self.date = date
        self.setValue = setValue
        self.setEncodableValue = setEncodableValue
        self.removeValue = removeValue
    }
}

public extension UserDefaultsClient {
    /// `UserDefaultsClient.setValue` を実行する時の引数.
    struct SetValueArguments {
        /// 保存の際に利用するキー.
        public let key: String
        /// 保存する値.
        public let value: Any

        public init(
            key: String,
            value: Any
        ) {
            self.key = key
            self.value = value
        }
    }

    /// `UserDefaultsClient.setEncodableValue` を実行する時の引数.
    struct SetEncodableValueArguments {
        /// 保存の際に利用するキー.
        public let key: String
        /// 保存する値.
        public let value: any Encodable

        public init(
            key: String,
            value: any Encodable
        ) {
            self.key = key
            self.value = value
        }
    }

    /// タイマーが起動中かどうかを返す.
    var isTimerActive: Bool {
        bool(.isTimerActive)
    }

    /// タイマーが起動中かどうかを保存する.
    func setIsTimerActive(_ value: Bool) {
        setValue(
            .init(
                key: .isTimerActive,
                value: value
            )
        )
    }

    /// タイマーが起動中かどうかのデータを削除する.
    func removeIsTimerActive() {
        removeValue(.isTimerActive)
    }

    /// タイマーの経過秒数を返す.
    var secondsElapsed: Int? {
        integer(.secondsElapsed)
    }

    /// タイマーの経過秒数を保存する.
    func setSecondsElapsed(_ value: Int) {
        setValue(
            .init(
                key: .secondsElapsed,
                value: value
            )
        )
    }

    /// タイマーの経過秒数のデータを削除する.
    func removeSecondsElapsed() {
        removeValue(.secondsElapsed)
    }

    /// タイマー用のバックグラウンドに移行したタイミングの `Date` を返す.
    var didEnterBackgroundDateForTimer: Date? {
        date(.didEnterBackgroundDateForTimer)
    }

    /// タイマー用のバックグラウンドに移行したタイミングの `Date` を保存する.
    func setDidEnterBackgroundDateForTimer(_ value: Date) {
        setEncodableValue(
            .init(
                key: .didEnterBackgroundDateForTimer,
                value: value
            )
        )
    }

    /// タイマー用のバックグラウンドに移行したタイミングの `Date` を削除する..
    func removeDidEnterBackgroundDateForTimer() {
        removeValue(.didEnterBackgroundDateForTimer)
    }
}

// MARK: - Dependencies

extension UserDefaultsClient: TestDependencyKey {
    public static var previewValue: UserDefaultsClient {
        .init { _ in
            false
        } integer: { _ in
            nil
        } data: { _ in
            nil
        } date: { _ in
            nil
        } setValue: { _ in
            // 何もしない
        } setEncodableValue: { _ in
            // 何もしない
        } removeValue: { _ in
            // 何もしない
        }
    }

    public static var testValue: UserDefaultsClient {
        .init { _ in
            unimplemented("\(Self.self)\(#function)")
        } integer: { _ in
            unimplemented("\(Self.self)\(#function)")
        } data: { _ in
            unimplemented("\(Self.self)\(#function)")
        } date: { _ in
            unimplemented("\(Self.self)\(#function)")
        } setValue: { _ in
            unimplemented("\(Self.self)\(#function)")
        } setEncodableValue: { _ in
            unimplemented("\(Self.self)\(#function)")
        } removeValue: { _ in
            unimplemented("\(Self.self)\(#function)")
        }
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
    /// タイマーが起動中かどうかのフラグを保存するキーの値.
    static let isTimerActive = "isTimerActive"
    /// タイマーの経過秒数を保存するキーの値.
    static let secondsElapsed = "secondsElapsed"
    /// タイマー用のバックグラウンドに移行したタイミングの `Date` を保存するキーの値.
    static let didEnterBackgroundDateForTimer = "didEnterBackgroundDateForTimer"
}
