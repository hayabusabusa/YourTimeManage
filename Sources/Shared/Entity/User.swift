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
    /// 目標.
    public let goal: String?
    /// 目標時間.
    public let goalSeconds: Int?
    /// 最後に勉強した時間.
    public let lastStudiedAt: Date?
    /// 今日勉強した時間のトータル.
    public let todayStudyingSeconds: Int
    
    public init(id: String, createdAt: Date, goal: String?, goalSeconds: Int?, lastStudiedAt: Date?, todayStudyingSeconds: Int) {
        self.id = id
        self.createdAt = createdAt
        self.goal = goal
        self.goalSeconds = goalSeconds
        self.lastStudiedAt = lastStudiedAt
        self.todayStudyingSeconds = todayStudyingSeconds
    }
}
