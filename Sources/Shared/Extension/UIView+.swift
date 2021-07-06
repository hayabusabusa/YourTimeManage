//
//  UIView+.swift
//  
//
//  Created by Shunya Yamada on 2021/07/04.
//

import UIKit

public extension UIView {
    
    /// 対象の View をサブビューとして追加して Auto Layout で固定する.
    /// - Parameters:
    ///   - view: サブビューとして追加したい View
    ///   - insets: 固定する際の
    func embed(in view: UIView, insets: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            rightAnchor.constraint(equalTo: view.rightAnchor, constant: insets.right),
            leftAnchor.constraint(equalTo: view.leftAnchor, constant: insets.left),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom)
        ])
    }
}
