//
//  LoginViewModel.swift
//  
//
//  Created by Shunya Yamada on 2021/07/23.
//

import Combine
import Foundation

// MARK: - Protocols

protocol LoginViewModelInputs {
    /// ログインボタンが押された時.
    func loginButtonTapped()
}

protocol LoginViewModelOutputs {
    /// 画面遷移のイベントを流す `Publisher`.
    var flowContext: AnyPublisher<FlowContextable, Never> { get }
}

protocol LoginViewModelType {
    var inputs: LoginViewModelInputs { get }
    var outputs: LoginViewModelOutputs { get }
}

// MARK: - ViewModel

final class LoginViewModel: LoginViewModelInputs, LoginViewModelOutputs {
    
    // MARK: Dependencies
    
    private let model: LoginModelProtocol
    
    // MARK: Properties
    
    private let flowSubject: PassthroughSubject<FlowContextable, Never>
    
    // MARK: Outputs
    
    let flowContext: AnyPublisher<FlowContextable, Never>
    
    // MARK: Initializer
    
    init(model: LoginModelProtocol = LoginModel()) {
        self.model = model
        self.flowSubject = PassthroughSubject<FlowContextable, Never>()
        self.flowContext = self.flowSubject
            .merge(with: model.authCompletedPublisher.map { FlowContext(transitionType: .dismiss, destination: nil) }.eraseToAnyPublisher())
            .eraseToAnyPublisher()
    }
    
    // MARK: Inputs
    
    func loginButtonTapped() {
        if model.isSignedIn() {
            return
        }
        model.signUp()
    }
}

extension LoginViewModel: LoginViewModelType {
    var inputs: LoginViewModelInputs { self }
    var outputs: LoginViewModelOutputs { self }
}
