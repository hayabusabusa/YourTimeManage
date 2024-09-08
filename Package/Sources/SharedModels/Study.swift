//
//  Study.swift
//
//
//  Created by Shunya Yamada on 2024/09/08.
//

import Foundation

/// Firestore に保存する勉強のデータ.
public struct Study: Identifiable, Equatable, Sendable, Codable {
    /// Firestore のドキュメント ID.
    public let id: String?
    /// タイトル.
    public let title: String
    /// 勉強した時間( 秒数 ).
    public let seconds: Int
    /// 作成日時.
    public let createdDate: Date
    /// 更新日時.
    public let updatedDate: Date?
    /// メモなどの補足情報.
    public let note: String?
    /// タグ情報.
    public let tags: [String]

    public init(
        id: String,
        title: String,
        seconds: Int,
        createdDate: Date,
        updatedDate: Date?,
        note: String?, 
        tags: [String]
    ) {
        self.id = id
        self.title = title
        self.seconds = seconds
        self.createdDate = createdDate
        self.updatedDate = updatedDate
        self.note = note
        self.tags = tags
    }
}
