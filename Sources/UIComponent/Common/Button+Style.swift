//
//  Button+Style.swift
//  
//
//  Created by Shunya Yamada on 2021/07/19.
//

import UIKit

public extension Button {
    
    enum Style {
        case small
        
        func apply(for button: Button) {
            button.translatesAutoresizingMaskIntoConstraints = false
            switch self {
            case .small:
                button.cornerRadius = 15
                button.backgroundColor = .systemGray6
                button.contentEdgeInsets = .init(top: 4, left: 16, bottom: 4, right: 16)
                button.sized(height: 30)
            }
        }
    }
}
