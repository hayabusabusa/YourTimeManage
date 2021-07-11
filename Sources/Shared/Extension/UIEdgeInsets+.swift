//
//  UIEdgeInsets+.swift
//  
//
//  Created by Shunya Yamada on 2021/07/05.
//

import UIKit

public extension UIEdgeInsets {
    
    /// 縦、横同じ値で `UIEdgeInset` を初期化する.
    static func all(_ value: CGFloat) -> Self {
        return .init(top: value, left: value, bottom: value, right: value)
    }
    
    /// 縦、横それぞれ別の値で `UIEdgeInsets` を初期化する.
    static func symetric(horizontal: CGFloat, vertical: CGFloat) -> Self {
        return .init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
}
