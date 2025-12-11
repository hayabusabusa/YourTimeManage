//
//  Session.swift
//  Package
//
//  Created by Shunya Yamada on 2025/12/10.
//

import Foundation

/// タイマーを利用して計測した記録のデータ.
public struct Session: Sendable, Equatable, Identifiable, Codable {
    /// Firestore のドキュメント ID.
    public var id: String?
    /// 記録した時間.
    public var elapsedSecond: Int
    /// 開始日時.
    public var startDate: Date
    /// 終了日時.
    public var endDate: Date
    /// 作成日時.
    public var createdDate: Date
    /// カテゴリー.
    public var category: Category
    /// 任意のメモ.
    public var note: String?
    /// 利用した教材.
    public var material: Material?

    public init(
        id: String?,
        elapsedSecond: Int,
        startDate: Date,
        endDate: Date,
        createdDate: Date,
        category: Category,
        note: String?,
        material: Material?
    ) {
        self.id = id
        self.elapsedSecond = elapsedSecond
        self.startDate = startDate
        self.endDate = endDate
        self.createdDate = createdDate
        self.category = category
        self.note = note
        self.material = material
    }
}
