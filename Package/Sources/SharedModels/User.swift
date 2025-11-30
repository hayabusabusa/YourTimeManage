//
//  User.swift
//  Package
//
//  Created by Shunya Yamada on 2025/11/30.
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
