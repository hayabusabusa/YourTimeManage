//
//  UIColor+.swift
//  
//
//  Created by Shunya Yamada on 2021/07/23.
//

import UIKit

public extension UIColor {
    
    // モジュールは Library になるので、リソースを持つことができない.
    // xcassets から色を読み込むのはメインアプリにバンドルされているものを利用することで解決できるので
    // バンドルを `Bundle.main` を指定して読み込むようにする.
    
    static let test = UIColor(named: "TEST", in: .main, compatibleWith: nil)
}
