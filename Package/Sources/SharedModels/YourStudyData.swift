//
//  YourStudyData.swift
//  Package
//
//  Created by Shunya Yamada on 2025/12/04.
//

import Foundation

/// 旧アプリで使用していた勉強のデータ.
///
/// `NSCoding` を利用して保存していたため、以下のようにクラス名の紐付けを行なってデータの復元を行う。
///
/// ```Swift
/// // モジュール名が変わるため `setClass(_:forClassName:)` でクラス名を紐付けしておく.
/// NSKeyedUnarchiver.setClass(YourStudyData.self, forClassName: YourStudyData.className)
/// // 復元を実施.
/// let unarchivedData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [YourStudyData]
/// ```
///
/// - warning: 以前保存していたデータを読み込むためだけに使用するため、**このクラスはマイグレーション以外で使用しない**.
public final class YourStudyData: NSObject, NSCoding {
    /// 旧クラスと新クラスの型を紐づけるために `NSKeyedUnarchiver.setClass(_:forClassName:)` に指定するクラス名.
    public static let className = "YourTimeManage.YourStudyData"

    /// `yyyy-MM-dd` 形式の日付.
    public let date: String?
    public let title: String?
    public let hour: Int
    public let minute: Int
    public let memo: String?

    public init(
        date: String?,
        title: String?,
        hour: Int,
        minute: Int,
        memo: String?
    ) {
        self.date = date
        self.title = title
        self.hour = hour
        self.minute = minute
        self.memo = memo
    }

    public required init?(coder: NSCoder) {
        date = coder.decodeObject(forKey: "studyDate") as? String
        title = coder.decodeObject(forKey: "studyTitle") as? String
        hour = coder.decodeInteger(forKey: "studyHour")
        minute = coder.decodeInteger(forKey: "studyMinute")
        memo = coder.decodeObject(forKey: "studyMemo") as? String
    }

    public func encode(with coder: NSCoder) {
        coder.encode(date, forKey: "studyDate")
        coder.encode(title, forKey: "studyTitle")
        coder.encode(hour, forKey: "studyHour")
        coder.encode(minute, forKey: "studyMinute")
        coder.encode(memo, forKey: "studyMemo")
    }
}
