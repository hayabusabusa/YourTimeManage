//
//  RootViewModel.swift
//  
//
//  Created by Shunya Yamada on 2021/07/31.
//

import Combine
import Foundation

// MARK: - Protocol

protocol RootViewModelInputs {
    /// 画面が表示された時.
    func viewDidLoad()
}

protocol RootViewModelOutputs {
    /// 画面遷移のイベントを流す `Publisher`.
    var flowContext: AnyPublisher<FlowContextable, Never> { get }
}

protocol RootViewModelType {
    var inputs: RootViewModelInputs { get }
    var outputs: RootViewModelOutputs { get }
}

// MARK: - ViewModel

final class RootViewModel: RootViewModelInputs, RootViewModelOutputs {
    
    // MARK: Dependency
    
    private let model: RootModelProtocol
    
    // MARK: Properties
    
    private let flowContextSubject: PassthroughSubject<FlowContextable, Never>
    
    // MARK: Outputs
    
    let flowContext: AnyPublisher<FlowContextable, Never>
    
    // MARK: Initializer
    
    init(model: RootModelProtocol = RootModel()) {
        self.model = model
        self.flowContextSubject = PassthroughSubject<FlowContextable, Never>()
        self.flowContext = self.flowContextSubject.eraseToAnyPublisher()
    }
    
    // MARK: Inputs
    
    func viewDidLoad() {
        flowContextSubject.send(RootFlowContext(destination: .debug))
    }
}

extension RootViewModel: RootViewModelType {
    var inputs: RootViewModelInputs { self }
    var outputs: RootViewModelOutputs { self }
}
