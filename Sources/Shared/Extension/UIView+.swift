//
//  UIView+.swift
//  
//
//  Created by Shunya Yamada on 2021/07/04.
//

import UIKit

public extension UIView {
    
    /// 対象の View に自身をサブビューとして追加してもらって Auto Layout で固定する.
    /// - Parameters:
    ///   - view: サブビューに追加してもらう View
    ///   - insets: 固定する際の余白
    func embed(in view: UIView, insets: UIEdgeInsets = .zero) {
        view.addSubview(self)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom)
        ])
    }
    
    /// 任意のサイズに AutoLayout で固定する.
    /// - Parameters:
    ///   - size: 固定したいサイズの値.
    func sized(_ size: CGSize) {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: size.width),
            heightAnchor.constraint(equalToConstant: size.height),
        ])
    }
    
    /// 任意の幅、高さに AutoLayout で固定する.
    /// - Parameters:
    ///   - width: 固定したい幅の値.
    ///   - height: 固定したい高さの値.
    func sized(width: CGFloat? = nil, height: CGFloat? = nil) {
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
