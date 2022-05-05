//
//  MenuViewController+Section.swift
//  UIPreview
//
//  Created by Shunya Yamada on 2022/04/01.
//

import UIKit

extension MenuViewController {
    
    enum Section {
        case all
    }
    
    enum Item: CaseIterable {
        case buttons
        case barChart
        
        var destination: UIViewController {
            switch self {
            case .buttons:
                return ButtonsViewController()
            case .barChart:
                return BarChartViewController()
            }
        }
        
        var title: String {
            switch self {
            case .buttons:
                return "ボタン一覧"
            case .barChart:
                return "棒グラフ"
            }
        }
        
        var iconImage: UIImage {
            switch self {
            case .buttons:
                return .init(systemName: "rectangle.fill")!
            case .barChart:
                return .init(systemName: "chart.bar.fill")!
            }
        }
    }
}
