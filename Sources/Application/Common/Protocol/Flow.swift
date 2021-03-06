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
    let destination: FlowDestination?
}

/// 遷移の情報をまとめる `Protocol`.
protocol FlowContextable {
    /// 遷移方法.
    var transitionType: FlowTransitionType { get }
    /// 遷移先.
    var destination: FlowDestination? { get }
    /// 遷移の処理を実行する.
    func move(from viewController: UIViewController)
}

extension FlowContextable {
    func move(from viewController: UIViewController) {
        switch transitionType {
        case .present(let isFullScreen):
            guard let destinationViewController = destination?.viewController else {
                return
            }
            destinationViewController.modalPresentationStyle = isFullScreen ? .fullScreen : .automatic
            viewController.present(destinationViewController, animated: true, completion: nil)
        case .dismiss:
            viewController.dismiss(animated: true, completion: nil)
        case .push:
            guard let destinationViewController = destination?.viewController else {
                return
            }
            viewController.navigationController?.pushViewController(destinationViewController, animated: true)
        case .pop:
            viewController.navigationController?.popViewController(animated: true)
        case .alert(let title, let message, let actions, let style):
            let ac = UIAlertController(title: title, message: message, preferredStyle: style)
            actions.forEach { ac.addAction($0) }
            viewController.present(ac, animated: true, completion: nil)
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
    /// `UIAlertController` を `UIViewController.present(_:animated:completion:)` で表示する.
    case alert(title: String, message: String, actions: [UIAlertAction], style: UIAlertController.Style)
}

/// 遷移先を定義した `Enum`.
enum FlowDestination {
    /// タイマー画面.
    case timer(with: TimerViewModelType)
    /// ログイン画面.
    case login(with: LoginViewModelType)
    /// デバッグ画面.
    case debug
    
    var viewController: UIViewController {
        switch self {
        case .timer(let viewModel):
            let nvc = UINavigationController(rootViewController: TimerViewController(viewModel: viewModel))
            return nvc
        case .login(let viewModel):
            let vc = LoginViewController(viewModel: viewModel)
            return vc
        case .debug:
            return DebugViewController()
        }
    }
}
