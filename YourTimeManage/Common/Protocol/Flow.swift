//
//  Flow.swift
//  YourTimeManage
//
//  Created by Shunya Yamada on 2021/07/22.
//

import UIKit
import Shared

/// 通常の遷移の情報をまとめた構造体.
///
/// カスタムで遷移アニメーションなどを使いたい場合は `FlowContextable` に準拠したものを作成する.
struct FlowContext: FlowContextable {
    let transitionType: FlowTransitionType
    let destination: FlowDestination
}

/// 遷移の情報をまとめる `Protocol`.
protocol FlowContextable {
    /// 遷移方法.
    var transitionType: FlowTransitionType { get }
    /// 遷移先.
    var destination: FlowDestination { get }
    /// 遷移の処理を実行する.
    func move(from viewController: UIViewController)
}

extension FlowContextable {
    func move(from viewController: UIViewController) {
        let destinationViewController = destination.viewController
        switch transitionType {
        case .present(let isFullScreen):
            destinationViewController.modalPresentationStyle = isFullScreen ? .fullScreen : .automatic
            viewController.present(destinationViewController, animated: true, completion: nil)
        case .dismiss:
            viewController.dismiss(animated: true, completion: nil)
        case .push:
            viewController.navigationController?.pushViewController(destinationViewController, animated: true)
        case .pop:
            viewController.navigationController?.popViewController(animated: true)
        }
    }
}

/// 遷移方法を定義した `Enum`.
enum FlowTransitionType {
    /// `UIViewController.present(_:animated:completion:)` で遷移する.
    case present(isFullScreen: Bool)
    /// `UIViewController.dismiss(animated:completion:)` で画面を閉じる.
    case dismiss
    /// `UIViewController.navigationController?.pushViewController(_:animated:)` で遷移する.
    case push
    /// `UIViewController.navigationController?.popViewController(animated:)` で戻る.
    case pop
}

/// 遷移先を定義した `Enum`.
enum FlowDestination {
    /// タイマー画面.
    case timer(with: TimerViewModelType)
    
    var viewController: UIViewController {
        switch self {
        case .timer(let viewModel):
            let nvc = UINavigationController(rootViewController: TimerViewController(viewModel: viewModel))
            return nvc
        }
    }
}
