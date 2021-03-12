//
//  StudyEntity.swift
//  Model
//
//  Created by Shunya Yamada on 2021/03/12.
//

import Foundation

public struct StudyEntity: Codable {
    public let date: String?
    public let title: String?
    public let seconds: Int
    public let memo: String?
    
    public init(date: String?, title: String?, seconds: Int, memo: String?) {
        self.date = date
        self.title = title
        self.seconds = seconds
        self.memo = memo
    }
}

extension StudyEntity {
    public init(from old: OldStudyEntity) {
        date = old.date
        title = old.title
        seconds = old.hour * 3600 + old.minute * 60
        memo = old.memo
    }
}
