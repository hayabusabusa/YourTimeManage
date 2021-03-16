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
    func didSelectRow(at type: DebugSection.DebugType)
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
        self.error = model.errorPublisher
        self.sections = model.sectionsPublisher
        self.isMigrationCompleted = model.isMigrationCompletedPublisher
    }
    
    func viewDidLoad() {
        model.getSections()
    }
    
    func didSelectRow(at type: DebugSection.DebugType) {
        switch type {
        case .charts: break
        case .crash: break
        case .migration:
            model.migration()
        }
    }
}

extension DebugViewModel: DebugViewModelType {
    var inputs: DebugViewModelInputs { return self }
    var outpus: DebugViewModelOutputs { return self }
}
