//
//  UIViewController+.swift
//  
//
//  Created by Shunya Yamada on 2021/07/04.
//

import UIKit

public extension UIViewController {
    
    /// 対象の ViewController を ChildViewController として追加する.
    /// - Parameters:
    ///   - viewController: ChildViewController として追加したい ViewController
    ///   - insets: addSubView する際の余白
    func embed(in viewController: UIViewController, insets: UIEdgeInsets) {
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
        viewController.view.embed(in: view, insets: insets)
    }
}
