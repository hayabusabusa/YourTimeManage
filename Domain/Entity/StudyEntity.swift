//
//  StudyEntity.swift
//  Domain
//
//  Created by Shunya Yamada on 2021/03/15.
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
