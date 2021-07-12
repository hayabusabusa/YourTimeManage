//
//  TimerModel.swift
//  YourTimeManage
//
//  Created by Shunya Yamada on 2021/07/10.
//

import Combine
import Foundation
import Shared

protocol TimerModelProtocol {
    /// タイマーの秒数を流す `Publisher`.
    var secondsPublisher: AnyPublisher<Int, Never> { get }
    /// タイマーを開始する.
    func startTimer()
    /// タイマーを一時停止する.
    func resumeTimer()
    /// タイマーをリセットする.
    func resetTimer()
}

final class TimerModel: TimerModelProtocol {
    
    private let secondsSubject: CurrentValueSubject<Int, Never>
    private let isValidSubject: CurrentValueSubject<Bool, Never>
    private var cancelables = Set<AnyCancellable>()
    
    let secondsPublisher: AnyPublisher<Int, Never>
    
    init(interval: TimeInterval = 1.0) {
        let secondsSubject = CurrentValueSubject<Int, Never>(0)
        
        self.secondsSubject = secondsSubject
        self.isValidSubject = .init(false)
        
        self.secondsPublisher = secondsSubject.eraseToAnyPublisher()
        
        isValidSubject
            .flatMap { isValid -> AnyPublisher<Date, Never> in
                return isValid
                    ? Timer.publish(every: interval, on: .main, in: .default).autoconnect().eraseToAnyPublisher()
                    : Empty<Date, Never>(completeImmediately: true).eraseToAnyPublisher()
            }
            .map { _ in secondsSubject.value + 1 }
            .bind(to: secondsSubject)
            .store(in: &cancelables)
    }
    
    func startTimer() {
        isValidSubject.send(true)
    }
    
    func resumeTimer() {
        isValidSubject.send(false)
    }
    
    func resetTimer() {
        secondsSubject.send(0)
    }
}
