//
//  TimerViewModel.swift
//  YourTimeManage
//
//  Created by Shunya Yamada on 2021/07/11.
//

import Combine
import Foundation

// MARK: - Protocols

protocol TimerViewModelInputs {
    /// スタートのボタンが押された時.
    func startButtonTapped()
    /// ストップのボタンが押された時.
    func stopButtonTapped()
}

protocol TimerViewModelOutputs {
    /// タイマーでカウントダウンしている秒数が、文字列にフォーマットされて流れてくる.
    var seconds: AnyPublisher<String?, Never> { get }
}

protocol TimerViewModelType {
    var inputs: TimerViewModelInputs { get }
    var outputs: TimerViewModelOutputs { get }
}

// MARK: - ViewModel

final class TimerViewModel: TimerViewModelInputs, TimerViewModelOutputs {
    
    // MARK: Dependencies
    
    private let model: TimerModelProtocol
    
    // MARK: Outputs
    
    let seconds: AnyPublisher<String?, Never>
    
    // MARK: Initializer
    
    init(model: TimerModelProtocol = TimerModel()) {
        self.model = model
        self.seconds = model.secondsPublisher
            .map { String(format: "%02d:%02i:%02i", $0 / 3600 % 60, $0 / 60 % 60, $0 % 60) }
            .eraseToAnyPublisher()
    }
    
    // MARK: Inputs
    
    func startButtonTapped() {
        model.startTimer()
    }
    
    func stopButtonTapped() {
        model.resumeTimer()
    }
}

extension TimerViewModel: TimerViewModelType {
    var inputs: TimerViewModelInputs { self }
    var outputs: TimerViewModelOutputs { self }
}
