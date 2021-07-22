//
//  User.swift
//  
//
//  Created by Shunya Yamada on 2021/07/23.
//

import Foundation

/// ログインしたユーザーのデータ.
public struct User: Codable {
    /// ユーザー ID.
    public let id: String
    /// 作成日.
    public let createdAt: Date
    
    public init(id: String, createdAt: Date) {
        self.id = id
        self.createdAt = createdAt
    }
}
