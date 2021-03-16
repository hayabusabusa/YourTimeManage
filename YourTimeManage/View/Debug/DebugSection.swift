//
//  DebugSection.swift
//  YourTimeManage
//
//  Created by Shunya Yamada on 2021/03/16.
//

import Foundation

enum DebugSection: CaseIterable {
    case view
    case util
    
    var rows: [DebugType] {
        switch self {
        case .view: return [.charts]
        case .util: return [.crash, .migration]
        }
    }
}

extension DebugSection {
    enum DebugType: CaseIterable {
        case charts
        case migration
        case crash
        
        var title: String {
            switch self {
            case .charts: return "📊 チャート一覧"
            case .migration: return "♻️ マイグレーションを試す"
            case .crash: return "❗️ クラッシュさせる"
            }
        }
    }
}
