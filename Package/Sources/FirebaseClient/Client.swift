//
//  Client.swift
//  Package
//
//  Created by Shunya Yamada on 2025/11/30.
//

import Dependencies
import DependenciesMacros
import Foundation

/// `Firebase` のセットアップ処理を行うクライアント.
@DependencyClient
public struct FirebaseClient: Sendable {
    /// `Firebase` の必須セットアップ処理を行う.
    ///
    /// セットアップについては [公式ドキュメント](https://firebase.google.com/docs/ios/setup?hl=ja) を参照.
    public var configure: @Sendable () -> Void
}

// MARK: - Dependencies

extension FirebaseClient: TestDependencyKey {
    public static var previewValue: FirebaseClient {
        .init {}
    }

    public static var testValue: FirebaseClient {
        .init()
    }
}

extension DependencyValues {
    public var firebaseClient: FirebaseClient {
        get { self[FirebaseClient.self] }
        set { self[FirebaseClient.self] = newValue }
    }
}
