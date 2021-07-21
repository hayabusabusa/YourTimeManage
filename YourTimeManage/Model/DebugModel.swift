//
//  DebugModel.swift
//  YourTimeManage
//
//  Created by Shunya Yamada on 2021/03/16.
//

import Combine
import Domain

protocol DebugModelProtocol {
    var errorPublisher: AnyPublisher<Error, Never> { get }
    var sectionsPublisher: AnyPublisher<[DebugSection], Never> { get }
    var isMigrationCompletedPublisher: AnyPublisher<Void, Never> { get }
    func getSections()
    func crash()
    func v200Migration()
}

final class DebugModel: DebugModelProtocol {
    
    private let migrationProvider: MigrationProvider
    private let errorSubject: PassthroughSubject<Error, Never>
    private let sectionsSubject: CurrentValueSubject<[DebugSection], Never>
    private let isMigrationCompletedSubject: PassthroughSubject<Void, Never>
    
    let errorPublisher: AnyPublisher<Error, Never>
    let sectionsPublisher: AnyPublisher<[DebugSection], Never>
    let isMigrationCompletedPublisher: AnyPublisher<Void, Never>
    
    init(migrationProvider: MigrationProvider = MigrationProvider.shared) {
        self.migrationProvider = migrationProvider
        self.errorSubject = .init()
        self.sectionsSubject = .init([])
        self.isMigrationCompletedSubject = .init()
        
        errorPublisher = errorSubject.eraseToAnyPublisher()
        sectionsPublisher = sectionsSubject.eraseToAnyPublisher()
        isMigrationCompletedPublisher = isMigrationCompletedSubject.eraseToAnyPublisher()
    }
    
    func getSections() {
        sectionsSubject.send(DebugSection.allCases)
    }
    
    func crash() {
        fatalError("デバッグのためにクラッシュ.")
    }
    
    func v200Migration() {
        let v200Migrator = V200Migrator()
        migrationProvider.execute(with: [v200Migrator]) { [weak self] result in
            switch result {
            case .success:
                self?.isMigrationCompletedSubject.send(())
            case .failure(let error):
                self?.errorSubject.send(error)
                self?.isMigrationCompletedSubject.send(())
            }
        }
    }
}
