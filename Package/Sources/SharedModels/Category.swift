//
//  Category.swift
//  Package
//
//  Created by Shunya Yamada on 2025/12/11.
//

import Foundation

/// セッションに設定するカテゴリー.
public struct Category: Sendable, Equatable, Identifiable, Codable {
    /// Firestore のドキュメント ID.
    public var id: String?
    /// タイトル
    public var title: String
    /// 設定した色.
    public var color: Color

    public init(
        id: String?,
        title: String,
        color: Color
    ) {
        self.id = id
        self.title = title
        self.color = color
    }
}
