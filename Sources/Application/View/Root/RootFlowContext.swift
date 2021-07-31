//
//  RootFlowContext.swift
//  
//
//  Created by Shunya Yamada on 2021/07/31.
//

import Shared
import UIKit

struct RootFlowContext: FlowContextable {
    var transitionType: FlowTransitionType = .push
    let destination: FlowDestination?
    
    func move(from viewController: UIViewController) {
        guard let destinationViewController = destination?.viewController else {
            return
        }
        // 既に追加されている ViewController を一度削除する.
        viewController.children.forEach { child in
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
        // 新しく ViewController を追加.
        viewController.embed(in: destinationViewController, insets: .zero)
    }
}
