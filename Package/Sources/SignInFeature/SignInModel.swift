//
//  SignInModel.swift
//  
//
//  Created by Shunya Yamada on 2022/04/11.
//

import Combine
import Core
import Domain

struct SignInModel {
    /// サインインなどの処理が完了したかどうかを流す `Publisher`.
    private(set) var isCompleted: AnyPublisher<Bool, Never>

    /// 発生したエラーを流す `Publisher`.
    private(set) var error: AnyPublisher<Error, Never>

    /// サインインの処理を実行する.
    private(set) var signIn: () -> Void

    /// 購読済みの `Subscriber`
    private(set) var cancellables: Set<AnyCancellable>
}

extension SignInModel {

    static func live(
        authService: AuthService = .live,
        firestoreService: FirestoreService = .live()
    ) -> Self {
        let isCompletedSubject = CurrentValueSubject<Bool, Never>(false)
        let errorSubject = PassthroughSubject<Error, Never>()
        var cancellables = Set<AnyCancellable>()

        return .init(
            isCompleted: isCompletedSubject.eraseToAnyPublisher(),
            error: errorSubject.eraseToAnyPublisher(),
            signIn: {
                authService.isSignedIn()
                    .setFailureType(to: Error.self)
                    .flatMap { isSignedIn in
                        return isSignedIn
                            ? Future<Bool, Error> { $0(.success(true)) }.eraseToAnyPublisher()
                            // TODO: Firestore でユーザーのデータを作成する.
                            : authService.signInAnonymously()
                                .map { _ in true }
                                .eraseToAnyPublisher()
                    }
                    .sink { completion in
                        isCompletedSubject.send(false)
                    } receiveValue: { isCompleted in
                        isCompletedSubject.send(isCompleted)
                    }
                    .store(in: &cancellables)
            },
            cancellables: cancellables
        )
    }
}
