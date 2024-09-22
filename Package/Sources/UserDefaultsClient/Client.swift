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
    /// `UserDefaults` にデータを保存する.
    public var setValue: @Sendable (SetValueArguments) -> Void
    /// `UserDefaults` に保存されているデータを削除する.
    public var removeValue: @Sendable (String) -> Void

    public init(
        bool: @Sendable @escaping (String) -> Bool,
        integer: @Sendable @escaping (String) -> Int?,
        setValue: @Sendable @escaping (SetValueArguments) -> Void,
        removeValue: @Sendable @escaping (String) -> Void
    ) {
        self.bool = bool
        self.integer = integer
        self.setValue = setValue
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
}

// MARK: - Dependencies

extension UserDefaultsClient: TestDependencyKey {
    public static var previewValue: UserDefaultsClient {
        .init { _ in
            false
        } integer: { _ in
            nil
        } setValue: { _ in
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
        } setValue: { _ in
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
