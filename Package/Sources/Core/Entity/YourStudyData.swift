//
//  YourStudyData.swift
//  
//
//  Created by Shunya Yamada on 2022/04/03.
//

import Foundation

/// 旧アプリで使用していた勉強のデータ.
/// - Note: 以前保存していたデータを読み込むためだけに使用するため、**このクラスはマイグレーション以外で使用しない**.
public final class YourStudyData: NSObject, NSCoding {
    /// 旧クラスと新クラスの型を紐づけるために `NSKeyedUnarchiver.setClass(_:forClassName:)` に指定するクラス名.
    public static let className = "YourTimeManage.YourStudyData"

    /// `yyyy-MM-dd` 形式の日付.
    public let date: String?
    public let title: String?
    public let hour: Int
    public let minute: Int
    public let memo: String?
    
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
