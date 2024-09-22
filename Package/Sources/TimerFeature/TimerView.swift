//
//  TimerView.swift
//
//
//  Created by Shunya Yamada on 2024/07/13.
//

import AuthClient
import ComposableArchitecture
import Dependencies
import FirestoreClient
import SharedModels
import SwiftUI

// MARK: - Reducer

@Reducer
public struct TimerFeature {
    public struct State: Equatable {
        /// タイマーが有効かどうか.
        public var isTimerActive = false
        /// 経過秒数.
        public var secondsElapsed = 0

        public init(
            isTimerActive: Bool = false,
            secondsElapsed: Int = 0
        ) {
            self.isTimerActive = isTimerActive
            self.secondsElapsed = secondsElapsed
        }
    }

    public enum Action {
        /// `ScenePhase` の値が変わった時の `Action`.
        case didChangeScenePhase(ScenePhase)
        /// 画面を開いた時の `Action`.
        case onAppear
        /// 画面を閉じた時の `Action`.
        case onDisappear
        /// 保存ボタンタップ時の `Action`.
        case saveButtonTapped
        /// タイマー開始のボタンタップ時の `Action`.
        case startButtonTapped
        /// タイマー停止のボタンタップ時の `Action`.
        case stopButtonTapped
        /// タイマー動作中の `Action`.
        case timerTicked
    }

    private enum CancelID {
        /// タイマー用のキャンセル ID.
        case timer
    }

    @Dependency(\.authClient) var authClient
    @Dependency(\.continuousClock) var clock
    @Dependency(\.date) var dateGenerator
    @Dependency(\.firestoreClient) var firestoreClient

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .didChangeScenePhase(let scenePhase):
                if case .active = scenePhase {
                    // フォアグラウンド復帰時にタイマー起動中だったら復元させる
                    restoreTimerIfNeeded()
                } else if case .background = scenePhase {
                    // バックグラウンド以降時にタイマー起動中ならタイマーの状態を保存する
                    storeTimerIfNeeded(isTimerActive: state.isTimerActive)
                }

                return .none
            case .onAppear:
                return .run { send in
                    // TODO: ここでは認証処理を行わないので後で消す.
                    guard !authClient.isSignIn() else {
                        return
                    }
                    _ = try? await authClient.signInAsAnonymousUser()
                }

            case .onDisappear:
                return .cancel(id: CancelID.timer)

            case .saveButtonTapped:
                return .run { [secondsElapsed = state.secondsElapsed] send in
                    // TODO: ここでは保存処理を行わないので後で消す.
                    guard let userID = authClient.uid() else {
                        return
                    }

                    let now = self.dateGenerator.now
                    let study = Study(
                        id: nil,
                        title: now.description,
                        seconds: secondsElapsed,
                        createdDate: now,
                        updatedDate: nil,
                        note: nil,
                        tags: []
                    )
                    let request = FirestoreClient.AddStudyRequest(
                        userID: userID,
                        study: study
                    )
                    try? await firestoreClient.addStudy(request)
                }

            case .startButtonTapped:
                state.isTimerActive = true
                return .run { send in
                    for await _ in self.clock.timer(interval: .seconds(1)) {
                        await send(.timerTicked)
                    }
                }
                .cancellable(id: CancelID.timer, cancelInFlight: true)

            case .stopButtonTapped:
                state.isTimerActive = false
                return .cancel(id: CancelID.timer)

            case .timerTicked:
                state.secondsElapsed += 1
                return .none
            }
        }
    }

    public init() {}
}

private extension TimerFeature {
    func storeTimerIfNeeded(isTimerActive: Bool) {
        guard !isTimerActive else { return }
        // TODO: UserDefaults に保存する
    }

    func restoreTimerIfNeeded() {
        // TODO: UserDefaults から読み込む
    }
}

// MARK: - View

public struct TimerView: View {
    private let formatter = DateComponentsFormatter()
    @Environment(\.scenePhase) private var scenePhase

    let store: StoreOf<TimerFeature>

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                VStack {
                    Text(formate(viewStore.secondsElapsed))
                        .font(Font(UIFont.monospacedDigitSystemFont(ofSize: 40, weight: .bold)))
                        .background {
                            // NOTE: アニメーションのオンオフをコントロールできるか分からないので一旦コメントアウト
    //                        WaveAnimationView(
    //                            size: 220,
    //                            color: Color(.red)
    //                        )
                        }
                    Text("サブテキスト")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color.gray)

                    Spacer()
                        .frame(height: 40)

                    Button {
                        if viewStore.isTimerActive {
                            viewStore.send(.stopButtonTapped)
                        } else {
                            viewStore.send(.startButtonTapped)
                        }
                    } label: {
                        Image(systemName: viewStore.isTimerActive ? "pause.fill" : "play.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .padding()
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.circle)
                }

                Spacer()

                Button {
//                    viewStore.send(.saveButtonTapped)
                } label: {
                    Text("記録する")
                        .bold()
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .controlSize(.large)
            }
            .padding()
            .onAppear {
                viewStore.send(.onAppear)
            }
            .onChange(of: scenePhase) { _, newValue in
                viewStore.send(.didChangeScenePhase(newValue))
            }
            .onDisappear {
                viewStore.send(.onDisappear)
            }
        }
    }

    public init(store: StoreOf<TimerFeature>) {
        self.store = store
    }
}

private extension TimerView {
    func formate(_ secondsElapsed: Int) -> String {
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: TimeInterval(secondsElapsed))!
    }
}

#Preview {
    TimerView(
        store: Store(
            initialState: TimerFeature.State()
        ) {
            TimerFeature()
        }
    )
}
