//
//  LoginViewController.swift
//  
//
//  Created by Shunya Yamada on 2021/07/23.
//

import Combine
import Shared
import UIComponent
import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: SubViews
    
    private lazy var loginButton: Button = {
        let button = Button(style: .small)
        button.setTitle("ログイン", for: .normal)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var signUpButton: Button = {
        let button = Button(style: .small)
        button.setTitle("新規登録", for: .normal)
        return button
    }()
    
    private lazy var resendPasswordButton: Button = {
        let button = Button(style: .small)
        button.setTitle("パスワードをお忘れの場合", for: .normal)
        return button
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical,
                                    alignment: .fill,
                                    spacing: 12.0,
                                    distribution: .equalSpacing,
                                    subviews: [loginButton,
                                               signUpButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: Properties
    
    private let viewModel: LoginViewModelType
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Lifecycle
    
    init(viewModel: LoginViewModelType = LoginViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubViews()
        bindViewModel()
    }
    
    @objc
    private func loginButtonTapped() {
        viewModel.inputs.loginButtonTapped()
    }
}

// MARK: - Configurations

extension LoginViewController {
    
    private func configureSubViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(buttonsStackView)
        NSLayoutConstraint.activate([
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
        ])
    }
    
    private func bindViewModel() {
        viewModel.outputs.flowContext
            .sink(receiveValue: { [unowned self] context in
                    context.move(from: self)
            })
            .store(in: &cancellables)
    }
}
