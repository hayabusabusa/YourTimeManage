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
    var isMigrationCompleted: AnyPublisher<Void, Never> { get }
    var flowContext: AnyPublisher<FlowContextable, Never> { get }
}

protocol DebugViewModelType {
    var inputs: DebugViewModelInputs { get }
    var outpus: DebugViewModelOutputs { get }
}

final class DebugViewModel: DebugViewModelInputs, DebugViewModelOutputs {
    
    private let model: DebugModelProtocol
    private let flowContextSubject: PassthroughSubject<FlowContextable, Never>
    
    let error: AnyPublisher<String, Never>
    let sections: AnyPublisher<[DebugSection], Never>
    let isMigrationCompleted: AnyPublisher<Void, Never>
    let flowContext: AnyPublisher<FlowContextable, Never>
    
    init(model: DebugModelProtocol = DebugModel()) {
        self.model = model
        self.error = model.errorPublisher.map { $0.localizedDescription }.eraseToAnyPublisher()
        self.sections = model.sectionsPublisher
        self.isMigrationCompleted = model.isMigrationCompletedPublisher
        self.flowContextSubject = PassthroughSubject<FlowContextable, Never>()
        self.flowContext = flowContextSubject.eraseToAnyPublisher()
    }
    
    func viewDidLoad() {
        model.getSections()
    }
    
    func didSelectRow(in section: DebugSection) {
        switch section {
        case .migration:
            model.v200Migration()
        case .crash:
            model.crash()
        case .timer:
            let model = TimerModel()
            let viewModel = TimerViewModel(model: model)
            flowContextSubject.send(FlowContext(transitionType: .present(isFullScreen: true), destination: .timer(with: viewModel)))
        case .restoreTimer:
            // 面倒なのでここで読み込む.
            guard let timerStatus = UserDefaultsProvider.shared.decodableObject(type: TimerStatus.self, forKey: .timerStatus) else {
                return
            }
            let model = TimerModel(timerStatus: timerStatus)
            let viewModel = TimerViewModel(model: model)
            flowContextSubject.send(FlowContext(transitionType: .present(isFullScreen: true), destination: .timer(with: viewModel)))
        }
    }
}

extension DebugViewModel: DebugViewModelType {
    var inputs: DebugViewModelInputs { return self }
    var outpus: DebugViewModelOutputs { return self }
}
