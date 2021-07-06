//
//  Study.swift
//  
//
//  Created by Shunya Yamada on 2021/07/04.
//

import Foundation

public struct Study: Codable {
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
