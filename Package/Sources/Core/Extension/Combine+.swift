//
//  Combine+.swift
//  
//
//  Created by Shunya Yamada on 2022/04/11.
//

import Combine

public extension Publisher where Self.Failure == Never {

    func bind<T: Subject>(to subject: T) -> AnyCancellable where Self.Output == T.Output {
        return sink { output in
            subject.send(output)
        }
    }

    func flatMapLatest<T: Publisher>(_ transform: @escaping (Output) -> T) -> Publishers.SwitchToLatest<T, Publishers.Map<Self, T>> where T.Failure == Failure {
        return map(transform).switchToLatest()
    }
}
