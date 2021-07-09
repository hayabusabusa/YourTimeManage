//
//  Combine+.swift
//  
//
//  Created by Shunya Yamada on 2021/07/10.
//

import Combine

public extension Publisher where Self.Failure == Never {
    
    func bind<T: Subject>(to subject: T) -> AnyCancellable where Self.Output == T.Output {
        return sink { output in
            subject.send(output)
        }
    }
}
