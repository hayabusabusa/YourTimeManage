//
//  TimerViewModel.swift
//  Package
//
//  Created by Shunya Yamada on 2025/12/01.
//

import Dependencies
import Foundation
import Observation
import SharedModels
import UserDefaultsClient

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
    /// `UserDefaults` 操作用のクライアント.
    @ObservationIgnored
    @Dependency(\.userDefaultsClient)
    private var userDefaultsClient
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
            startTimerTask()
        } else {
            cancelTimerTask()
        }
    }
    
    /// 記録ボタンタップ時に実行するメソッド.
    func saveButtonTapped() {
        guard secondsElapsed > 0 else {
            return
        }
        do {
            try saveLegacyData(
                date: dateGenerator.now,
                secondsElapsed: secondsElapsed
            )
            isTimerActive = false
            secondsElapsed = 0
            cancelTimerTask()
        } catch {
            print(error)
        }
    }

    /// `ScenePhase` 変更時のメソッド.
    /// - Parameter isActive: `ScenePhase` の状態がアクティブかどうか.
    func didChangeScenePhase(isActive: Bool) {}
}

// MARK: - Private

private extension TimerViewModel {
    /// タイマーの処理を開始する.
    func startTimerTask() {
        task = Task {
            for await _ in clock.timer(interval: .seconds(1)) {
                secondsElapsed += 1
            }
        }
    }
    
    /// タイマーの処理を停止する.
    func cancelTimerTask() {
        task?.cancel()
        task = nil
    }
    
    /// 以前のアプリで利用していたデータを保存する.
    /// - Parameters:
    ///   - date: 日付.
    ///   - secondsElapsed: 秒数.
    @available(*, deprecated, message: "TODO: 確認用なのであとで削除する.")
    func saveLegacyData(
        date: Date,
        secondsElapsed: Int
    ) throws {
        let dateString = date.formatted(date: .numeric, time: .omitted)
        let title = date.formatted(date: .numeric, time: .standard)
        let data = YourStudyData(
            date: dateString,
            title: title,
            hour: secondsElapsed / 3600,
            minute: secondsElapsed,
            memo: nil
        )
        userDefaultsClient.setLegacyData([data])
    }
}
