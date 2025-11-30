//
//  Client.swift
//  Package
//
//  Created by Shunya Yamada on 2025/11/30.
//

import Dependencies
import DependenciesMacros
import Foundation
import SharedModels

/// Firebase Auth の操作を行うクライアント.
@DependencyClient
public struct AuthClient: Sendable {
    /// サインイン済みのユーザーかどうかを返す.
    public var isSignIn: @Sendable () -> Bool = { false }
    /// ユーザー ID を返す.
    public var uid: @Sendable () -> String?
    /// 匿名認証でサインインする.
    public var signInAsAnonymousUser: @Sendable () async throws -> SharedModels.User
}

// MARK: - Dependencies

extension AuthClient: TestDependencyKey {
    public static var previewValue: AuthClient {
        .init {
            false
        } uid: {
            nil
        } signInAsAnonymousUser: {
            .init(id: "TEST")
        }
    }

    public static var testValue: AuthClient {
        .init()
    }
}

extension DependencyValues {
    public var authClient: AuthClient {
        get { self[AuthClient.self] }
        set { self[AuthClient.self] = newValue }
    }
}
