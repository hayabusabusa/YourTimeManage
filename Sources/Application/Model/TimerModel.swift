//
//  TimerModel.swift
//  YourTimeManage
//
//  Created by Shunya Yamada on 2021/07/10.
//

import Combine
import Domain
import Foundation
import Shared

protocol TimerModelProtocol {
    /// タイマーの秒数を流す `Publisher`.
    var secondsPublisher: AnyPublisher<Int, Never> { get }
    /// タイマーを開始する.
    func startTimer()
    /// タイマーを一時停止する.
    func stopTimer()
    /// タイマーをリセットする.
    func resetTimer()
    /// 保存していたタイマーの状態があれば反映させる.
    func restoreTimerIfNeeded()
    /// タイマーの状態を保存する.
    func saveTimerStatus()
    /// 保存したタイマーの状態を読み込む.
    func loadTimerStatus()
}

final class TimerModel: TimerModelProtocol {
    
    private let userDefaultsProvider: UserDefaultsProviderProtocol
    private let timerStatus: TimerStatus?
    private let secondsSubject: CurrentValueSubject<Int, Never>
    private let isValidSubject: CurrentValueSubject<Bool, Never>
    private var cancelables = Set<AnyCancellable>()
    
    let secondsPublisher: AnyPublisher<Int, Never>
    
    init(userDefaultsProvider: UserDefaultsProviderProtocol = UserDefaultsProvider.shared,
         timerStatus: TimerStatus? = nil,
         interval: TimeInterval = 1.0) {
        self.userDefaultsProvider = userDefaultsProvider
        self.timerStatus = timerStatus
        self.secondsSubject = CurrentValueSubject<Int, Never>(0)
        self.secondsPublisher = secondsSubject.eraseToAnyPublisher()
        self.isValidSubject = CurrentValueSubject<Bool, Never>(false)
        
        isValidSubject
            .removeDuplicates()
            .flatMapLatest { isValid -> AnyPublisher<Date, Never> in
                return isValid
                    ? Timer.publish(every: interval, on: .main, in: .default).autoconnect().eraseToAnyPublisher()
                    : Empty<Date, Never>(completeImmediately: true).eraseToAnyPublisher()
            }
            .map { [unowned self] _ in self.secondsSubject.value + 1 }
            .bind(to: secondsSubject)
            .store(in: &cancelables)
    }
    
    func startTimer() {
        isValidSubject.send(true)
    }
    
    func stopTimer() {
        isValidSubject.send(false)
    }
    
    func resetTimer() {
        secondsSubject.send(0)
    }
    
    func restoreTimerIfNeeded() {
        guard let timerStatus = timerStatus else {
            return
        }
        secondsSubject.send(timerStatus.seconds)
        isValidSubject.send(timerStatus.isValid)
        // 読み込みが完了したら前回のタイマーの状態を削除する.
        userDefaultsProvider.removeObject(forKey: .timerStatus)
    }
    
    func saveTimerStatus() {
        let timerStatus = TimerStatus(seconds: secondsSubject.value, isValid: isValidSubject.value, enterBackgroundDate: Date())
        userDefaultsProvider.setEncodable(value: timerStatus, forKey: .timerStatus)
    }
    
    func loadTimerStatus() {
        guard let timerStatus = userDefaultsProvider.decodableObject(type: TimerStatus.self, forKey: .timerStatus) else {
            return
        }
        // 今よりも前の時間なのでマイナスの値になる.
        let interval = timerStatus.enterBackgroundDate.timeIntervalSinceNow
        secondsSubject.send(timerStatus.seconds - Int(interval))
        isValidSubject.send(timerStatus.isValid)
        // 読み込みが完了したら前回のタイマーの状態を削除する.
        userDefaultsProvider.removeObject(forKey: .timerStatus)
    }
}
