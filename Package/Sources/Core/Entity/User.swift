//
//  User.swift
//  
//
//  Created by Shunya Yamada on 2022/04/03.
//

import Foundation

/// ログインしたユーザーのデータ.
public struct User: Codable {
    /// ユーザー ID.
    public let id: String
    /// 作成日.
    public let createdAt: Date
    /// 目標.
    public let goal: String?
    /// 目標時間.
    public let goalSeconds: Int?
    /// 最後に勉強した時間.
    public let lastStudiedAt: Date?
    
    public init(
        id: String,
        createdAt: Date,
        goal: String?,
        goalSeconds: Int?,
        lastStudiedAt: Date?
    ) {
        self.id = id
        self.createdAt = createdAt
        self.goal = goal
        self.goalSeconds = goalSeconds
        self.lastStudiedAt = lastStudiedAt
    }
}
