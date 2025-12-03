//
//  TimerViewModel.swift
//  Package
//
//  Created by Shunya Yamada on 2025/12/01.
//

import Dependencies
import Foundation
import Observation

@MainActor
@Observable
public final class TimerViewModel {
    /// タイマー処理用の実装.
    @ObservationIgnored
    @Dependency(\.continuousClock)
    private var clock
    /// `Date` 作成用の実装.
    @ObservationIgnored
    @Dependency(\.date)
    private var dateGenerator
    /// タイマーによる定期処理のタスクをキャンセルするために保持する.
    @ObservationIgnored
    private var task: Task<Void, Never>?

    /// 経過秒数.
    private(set) var secondsElapsed = 0
    /// タイマーが開始しているかどうか.
    private(set) var isTimerActive = false

    public init() {}
    
    /// タイマーの開始 or 停止ボタンタップ時に実行するメソッド.
    func timerButtonTapped() {
        isTimerActive.toggle()
        
        if isTimerActive {
            startTimer()
        } else {
            stopTimer()
        }
    }
    
    /// 記録ボタンタップ時に実行するメソッド.
    func saveButtonTapped() {}

    /// `ScenePhase` 変更時のメソッド.
    /// - Parameter isActive: `ScenePhase` の状態がアクティブかどうか.
    func didChangeScenePhase(isActive: Bool) {}
}

// MARK: - Private

private extension TimerViewModel {
    /// タイマーの処理を開始する.
    func startTimer() {
        task = Task {
            for await _ in clock.timer(interval: .seconds(1)) {
                secondsElapsed += 1
            }
        }
    }
    
    /// タイマーの処理を停止する.
    func stopTimer() {
        task?.cancel()
        task = nil
    }
}
