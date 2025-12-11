//
//  Material.swift
//  Package
//
//  Created by Shunya Yamada on 2025/12/10.
//

import Foundation

/// セッション中に利用した教材などのデータ.
public struct Material: Sendable, Equatable, Identifiable, Codable {
    /// Firestore のドキュメント ID.
    public var id: String?
    /// タイトル.
    public var title: String
    /// サムネイル画像の URL.
    public var thumbnailURL: URL?
    /// 作成日時.
    public var createdDate: Date

    public init(
        id: String?,
        title: String,
        thumbnailURL: URL?,
        createdDate: Date
    ) {
        self.id = id
        self.title = title
        self.thumbnailURL = thumbnailURL
        self.createdDate = createdDate
    }
}
