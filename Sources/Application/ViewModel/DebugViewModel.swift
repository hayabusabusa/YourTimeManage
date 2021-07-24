//
//  DebugViewModel.swift
//  YourTimeManage
//
//  Created by Shunya Yamada on 2021/03/16.
//

import Foundation
import Combine
import Domain
import Shared

protocol DebugViewModelInputs {
    func viewDidLoad()
    func didSelectRow(in section: DebugSection)
}

protocol DebugViewModelOutputs {
    var error: AnyPublisher<String, Never> { get }
    var sections: AnyPublisher<[DebugSection], Never> { get }
    var message: AnyPublisher<String, Never> { get }
    var flowContext: AnyPublisher<FlowContextable, Never> { get }
}

protocol DebugViewModelType {
    var inputs: DebugViewModelInputs { get }
    var outpus: DebugViewModelOutputs { get }
}

final class DebugViewModel: DebugViewModelInputs, DebugViewModelOutputs {
    
    private let model: DebugModelProtocol
    private let messageSubject: PassthroughSubject<String, Never>
    private let flowContextSubject: PassthroughSubject<FlowContextable, Never>
    
    let error: AnyPublisher<String, Never>
    let sections: AnyPublisher<[DebugSection], Never>
    let message: AnyPublisher<String, Never>
    let flowContext: AnyPublisher<FlowContextable, Never>
    
    init(model: DebugModelProtocol = DebugModel()) {
        self.model = model
        self.error = model.errorPublisher.map { $0.localizedDescription }.eraseToAnyPublisher()
        self.sections = model.sectionsPublisher
        self.messageSubject = PassthroughSubject<String, Never>()
        self.message = messageSubject.merge(with: model.isMigrationCompletedPublisher.map { "マイグレーションが完了" }).eraseToAnyPublisher()
        self.flowContextSubject = PassthroughSubject<FlowContextable, Never>()
        self.flowContext = flowContextSubject.eraseToAnyPublisher()
    }
    
    func viewDidLoad() {
        model.getSections()
    }
    
    func didSelectRow(in section: DebugSection) {
        switch section {
        case .migration:
            model.migration()
        case .crash:
            model.crash()
        case .login:
            let viewModel = LoginViewModel()
            flowContextSubject.send(FlowContext(transitionType: .present(isFullScreen: false), destination: .login(with: viewModel)))
        case .timer:
            let viewModel = TimerViewModel()
            flowContextSubject.send(FlowContext(transitionType: .present(isFullScreen: true), destination: .timer(with: viewModel)))
        case .restoreTimer:
            // 面倒なのでここで読み込む.
            if let timerStatus = UserDefaultsProvider.shared.decodableObject(type: TimerStatus.self, forKey: .timerStatus) {
                let model = TimerModel(timerStatus: timerStatus)
                let viewModel = TimerViewModel(model: model)
                flowContextSubject.send(FlowContext(transitionType: .present(isFullScreen: true), destination: .timer(with: viewModel)))
            } else {
                messageSubject.send("保存されているタイマーの状態はありません")
            }
        }
    }
}

extension DebugViewModel: DebugViewModelType {
    var inputs: DebugViewModelInputs { return self }
    var outpus: DebugViewModelOutputs { return self }
}
