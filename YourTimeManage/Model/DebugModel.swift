//
//  DebugModel.swift
//  YourTimeManage
//
//  Created by Shunya Yamada on 2021/03/16.
//

import Combine
import FirebaseCrashlytics

protocol DebugModelProtocol {
    var errorPublisher: AnyPublisher<String, Never> { get }
    var sectionsPublisher: AnyPublisher<[DebugSection], Never> { get }
    var isMigrationCompletedPublisher: AnyPublisher<Void, Never> { get }
    
    func getSections()
    func crashForDebug()
    func migration()
}

final class DebugModel: DebugModelProtocol {
    
    private let errorSubject: PassthroughSubject<String, Never>
    private let sectionsSubject: CurrentValueSubject<[DebugSection], Never>
    private let isMigrationCompletedSubject: PassthroughSubject<Void, Never>
    
    let errorPublisher: AnyPublisher<String, Never>
    let sectionsPublisher: AnyPublisher<[DebugSection], Never>
    let isMigrationCompletedPublisher: AnyPublisher<Void, Never>
    
    init() {
        errorSubject = .init()
        sectionsSubject = .init([])
        isMigrationCompletedSubject = .init()
        
        errorPublisher = errorSubject.eraseToAnyPublisher()
        sectionsPublisher = sectionsSubject.eraseToAnyPublisher()
        isMigrationCompletedPublisher = isMigrationCompletedSubject.eraseToAnyPublisher()
    }
    
    func getSections() {
        sectionsSubject.send(DebugSection.allCases)
    }
    
    func crashForDebug() {
        Crashlytics.crashlytics().log("[DEBUG] This error is debug.")
        fatalError("[DEBUG] This error is debug.")
    }
    
    func migration() {
        Migrator.execute(of: .v200) { [weak self] result in
            switch result {
            case .success:
                self?.isMigrationCompletedSubject.send(())
            case .failure(let error):
                Crashlytics.crashlytics().record(error: error)
                self?.errorSubject.send(error.localizedDescription)
            }
        }
    }
}
