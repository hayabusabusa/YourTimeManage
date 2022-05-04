//
//  TimerModel.swift
//  
//
//  Created by Shunya Yamada on 2022/05/04.
//

import Combine
import Core
import Foundation

struct TimerModel {
    /// カウントの秒数を流す `Publisher`.
    var count: () -> AnyPublisher<Int, Never>

    /// タイマーが有効かどうかのフラグを流す `Publisher`.
    var isValid: () -> AnyPublisher<Bool, Never>

    /// 購読破棄用の `Cancellable`.
    var cancellables: Set<AnyCancellable>

    /// タイマーを開始させる.
    var startTimer: () -> Void

    /// タイマーを停止させる.
    var stopTimer: () -> Void

    /// タイマーの秒数をリセットする.
    var resetTimer: () -> Void
}

extension TimerModel {
    static func live(
        interval: TimeInterval = 1.0,
    ) -> Self {
        let isValidSubject = CurrentValueSubject<Bool, Never>(false)
        let countSubject = CurrentValueSubject<Int, Never>(0)
        var cancellables = Set<AnyCancellable>()

        isValidSubject
            .removeDuplicates()
            .flatMapLatest {
                $0
                    ? Timer.publish(every: interval, on: .main, in: .default).autoconnect().eraseToAnyPublisher()
                    : Empty<Date, Never>().eraseToAnyPublisher()
            }
            .sink { value in
                countSubject.send(countSubject.value + 1)
            }
            .store(in: &cancellables)

        return Self.init(
            count: {
                return countSubject.eraseToAnyPublisher()
            },
            isValid: {
                return isValidSubject.eraseToAnyPublisher()
            },
            cancellables: cancellables,
            startTimer: {
                isValidSubject.send(true)
            },
            stopTimer: {
                isValidSubject.send(false)
            },
            resetTimer: {
                countSubject.send(0)
            }
        )
    }
}
