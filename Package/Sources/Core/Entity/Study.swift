//
//  Study.swift
//  
//
//  Created by Shunya Yamada on 2022/04/03.
//

import Foundation

/// 勉強のデータ.
public struct Study: Codable {
    /// 勉強した日付.
    public let date: Date
    /// 勉強のデータのタイトル.
    public let title: String
    /// 勉強した時間( 秒換算 ).
    public let seconds: Int
    /// 勉強のデータに追加したメモ.
    public let memo: String?
    
    public init(
        date: Date,
        title: String,
        seconds: Int,
        memo: String?
    ) {
        self.date = date
        self.title = title
        self.seconds = seconds
        self.memo = memo
    }
}
