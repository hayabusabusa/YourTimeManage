//
//  TimerViewController.swift
//  YourTimeManage
//
//  Created by Shunya Yamada on 2021/07/11.
//

import UIKit
import SwiftUI

final class TimerViewController: UIViewController {
    
    // MARK: SubViews
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var stopButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: Properties
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubViews()
        configureNavigation()
    }
    
    @objc
    private func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Configurations

extension TimerViewController {
    
    private func configureSubViews() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "閉じる", style: .done, target: self, action: #selector(didTapCloseButton))
    }
}
