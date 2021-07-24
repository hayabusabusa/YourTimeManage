//
//  LoginModel.swift
//  
//
//  Created by Shunya Yamada on 2021/07/23.
//

import Combine
import Domain
import Foundation
import Shared

protocol LoginModelProtocol {
    /// ロード中かどうかのフラグを流す `Publisher`.
    var isLoadingPublisher: AnyPublisher<Bool, Never> { get }
    /// 認証が完了したタイミングでイベントを流す `Publisher`.
    var authCompletedPublisher: AnyPublisher<Void, Never> { get }
    /// エラーを流す `Publisher`.
    var errorPublisher: AnyPublisher<Error, Never> { get }
    /// サインインしたかどうかを返す.
    func isSignedIn() -> Bool
    /// サインインを実行する.
    func signUp()
    /// サインアウトを実行する.
    func signOut()
}

final class LoginModel: LoginModelProtocol {
    
    private let authProvider: AuthProviderProtocol
    private let firestoreProvider: FirestoreProviderProtocol
    
    private var cancellables = Set<AnyCancellable>()
    private let isLoadingSubject: PassthroughSubject<Bool, Never>
    private let authCompletedSubject: PassthroughSubject<Void, Never>
    private let errorSubject: PassthroughSubject<Error, Never>
    
    let isLoadingPublisher: AnyPublisher<Bool, Never>
    let authCompletedPublisher: AnyPublisher<Void, Never>
    let errorPublisher: AnyPublisher<Error, Never>

    init(authProvider: AuthProviderProtocol = AuthProvider.shared,
         firestoreProvider: FirestoreProviderProtocol = FirestoreProvider.shared) {
        self.authProvider = authProvider
        self.firestoreProvider = firestoreProvider
        self.isLoadingSubject = PassthroughSubject<Bool, Never>()
        self.isLoadingPublisher = self.isLoadingSubject.eraseToAnyPublisher()
        self.authCompletedSubject = PassthroughSubject<Void, Never>()
        self.authCompletedPublisher = self.authCompletedSubject.eraseToAnyPublisher()
        self.errorSubject = PassthroughSubject<Error, Never>()
        self.errorPublisher = self.errorSubject.eraseToAnyPublisher()
    }
    
    func isSignedIn() -> Bool {
        #if DEBUG
        debugPrint("[DEBUG] LOGGED IN USER: \(authProvider.currentUser?.description ?? "Not logged in.")")
        #endif
        return authProvider.currentUser != nil
    }
    
    func signUp() {
        isLoadingSubject.send(true)
        
        authProvider.signInAnonymously()
            .flatMap { [unowned self] result -> Future<Void, Error> in
                let user = User(id: result.user.uid, createdAt: Date())
                return self.firestoreProvider.setDocument(to: FirestoreProvider.Collection.users, path: result.user.uid, data: user)
            }
            .sink(receiveCompletion: { [unowned self] completion in
                switch completion {
                case .failure(let error):
                    self.isLoadingSubject.send(false)
                    self.errorSubject.send(error)
                case .finished:
                    self.isLoadingSubject.send(false)
                    self.authCompletedSubject.send(())
                }
            }, receiveValue: { _ in
                // Void
            })
            .store(in: &cancellables)
    }
    
    func signOut() {
        isLoadingSubject.send(true)
        
        authProvider.signOut()
            .sink(receiveCompletion: { [unowned self] completion in
                switch completion {
                case .failure(let error):
                    self.isLoadingSubject.send(false)
                    self.errorSubject.send(error)
                case .finished:
                    self.isLoadingSubject.send(false)
                    self.authCompletedSubject.send(())
                }
            }, receiveValue: { _ in
                // Void
            })
            .store(in: &cancellables)
    }
}
