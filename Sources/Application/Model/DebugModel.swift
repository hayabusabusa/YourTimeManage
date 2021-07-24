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
    func sigOut()
    func crash()
    func migration()
}

final class DebugModel: DebugModelProtocol {
    
    private let authProvider: AuthProviderProtocol
    private let migrationProvider: MigrationProvider
    
    private var cancellables = Set<AnyCancellable>()
    private let errorSubject: PassthroughSubject<Error, Never>
    private let sectionsSubject: CurrentValueSubject<[DebugSection], Never>
    private let isMigrationCompletedSubject: PassthroughSubject<Void, Never>
    
    let errorPublisher: AnyPublisher<Error, Never>
    let sectionsPublisher: AnyPublisher<[DebugSection], Never>
    let isMigrationCompletedPublisher: AnyPublisher<Void, Never>
    
    init(authProvider: AuthProviderProtocol = AuthProvider.shared,
         migrationProvider: MigrationProvider = MigrationProvider.shared) {
        self.authProvider = authProvider
        self.migrationProvider = migrationProvider
        
        self.errorSubject = .init()
        self.sectionsSubject = .init([])
        self.isMigrationCompletedSubject = .init()
        
        errorPublisher = errorSubject.eraseToAnyPublisher()
        sectionsPublisher = sectionsSubject.eraseToAnyPublisher()
        isMigrationCompletedPublisher = isMigrationCompletedSubject.eraseToAnyPublisher()
    }
    
    func getSections() {
        let uid = authProvider.currentUser?.uid
        sectionsSubject.send([
            .loginStatus(uid: uid),
            .login,
            .logout,
            .migration,
            .timer,
            .restoreTimer,
            .crash,
        ])
    }
    
    func sigOut() {
        guard authProvider.currentUser != nil else {
            return
        }
        authProvider.signOut()
            .sink(receiveCompletion: { [unowned self] completion in
                switch completion {
                case .failure(let error):
                    self.errorSubject.send(error)
                case .finished:
                    self.getSections()
                }
            }, receiveValue: { _ in
                // Void
            })
            .store(in: &cancellables)
    }
    
    func crash() {
        fatalError("デバッグのためにクラッシュ.")
    }
    
    func migration() {
        migrationProvider.execute { [weak self] result in
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
