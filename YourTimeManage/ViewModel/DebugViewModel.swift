//
//  DebugViewModel.swift
//  YourTimeManage
//
//  Created by Shunya Yamada on 2021/03/16.
//

import Foundation
import Combine

protocol DebugViewModelInputs {
    func viewDidLoad()
    func didSelectRow(in section: DebugSection)
}

protocol DebugViewModelOutputs {
    var error: AnyPublisher<String, Never> { get }
    var sections: AnyPublisher<[DebugSection], Never> { get }
    var isMigrationCompleted: AnyPublisher<Void, Never> { get }
}

protocol DebugViewModelType {
    var inputs: DebugViewModelInputs { get }
    var outpus: DebugViewModelOutputs { get }
}

final class DebugViewModel: DebugViewModelInputs, DebugViewModelOutputs {
    
    private let model: DebugModelProtocol
    
    let error: AnyPublisher<String, Never>
    let sections: AnyPublisher<[DebugSection], Never>
    let isMigrationCompleted: AnyPublisher<Void, Never>
    
    init(model: DebugModelProtocol = DebugModel()) {
        self.model = model
        self.error = model.errorPublisher.map { $0.localizedDescription }.eraseToAnyPublisher()
        self.sections = model.sectionsPublisher
        self.isMigrationCompleted = model.isMigrationCompletedPublisher
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
        default:
            break
        }
    }
}

extension DebugViewModel: DebugViewModelType {
    var inputs: DebugViewModelInputs { return self }
    var outpus: DebugViewModelOutputs { return self }
}
