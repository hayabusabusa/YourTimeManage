//
//  User.swift
//
//
//  Created by Shunya Yamada on 2024/05/26.
//

import Foundation

/// ログイン済みのユーザーを表すモデル.
public struct User: Identifiable, Equatable, Sendable, Codable {
    /// Firebase Auth でサインインした際の `uid`.
    public var id: String

    public init(id: String) {
        self.id = id
    }
}
