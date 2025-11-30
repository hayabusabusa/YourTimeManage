//
//  AppViewModel.swift
//  Package
//
//  Created by Shunya Yamada on 2025/11/30.
//

import Dependencies
import FirebaseClient
import Foundation
import Observation

/// アプリのライフサイクルイベントを受け取る `ViewModel`.
@MainActor
@Observable
public final class AppViewModel {
    @ObservationIgnored
    @Dependency(\.firebaseClient)
    private var firebaseClient

    public init() {}

    /// `AppDelegate.application(_:didFinishLaunchingWithOptions:)` が実行された時のメソッド.
    public func didFinishLaunchingWithOptions() {
        firebaseClient.configure()
    }
}
