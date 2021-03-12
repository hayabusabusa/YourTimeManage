//
//  OldStudyEntity.swift
//  Model
//
//  Created by Shunya Yamada on 2021/03/11.
//

import Foundation

public final class OldStudyEntity: NSObject, NSCoding {
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
