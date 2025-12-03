//
//  TimerView.swift
//  Package
//
//  Created by Shunya Yamada on 2025/12/01.
//

import SwiftUI

public struct TimerView: View {
    /// ViewModel.
    @State private var viewModel: TimerViewModel
    /// バックグラウンド、フォアグラウンド復帰を検知するための `ScenePahse` の購読.
    @Environment(\.scenePhase) private var scenePhase
    /// 秒数のフォーマット用の Formatter.
    private let formatter = DateComponentsFormatter()

    public var body: some View {
        VStack {
            VStack {
                Text(formate(viewModel.secondsElapsed))
                    .font(
                        Font(
                            UIFont.monospacedDigitSystemFont(
                                ofSize: 40,
                                weight: .bold
                            )
                        )
                    )
                    .background {
//                            WaveAnimationView(
//                                size: 220,
//                                color: Color(.red)
//                            )
                    }
                Text("サブテキスト")
                    .font(.caption)
                    .foregroundStyle(Color.gray)

                Spacer()
                    .frame(height: 40)

                Button {
                    viewModel.timerButtonTapped()
                } label: {
                    Image(systemName: viewModel.isTimerActive ? "pause.fill" : "play.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(
                            width: 20,
                            height: 20
                        )
                        .padding(20)
                        .foregroundStyle(.blue)
                        .background(
                            Circle()
                                .stroke(.blue, lineWidth: 1)
                        )
                }
            }
            .frame(maxHeight: .infinity)

            Button {
                viewModel.saveButtonTapped()
            } label: {
                Text("記録する")
                    .bold()
                    .padding()
                    .foregroundStyle(Color(.white))
            }
            .frame(maxWidth: .infinity)
            .buttonBorderShape(.capsule)
            .glassEffect(.regular.tint(.blue).interactive())
        }
        .padding(16)
        .onChange(of: scenePhase) { _, newValue in
            viewModel.didChangeScenePhase(isActive: newValue == .active)
        }
    }

    public init(viewModel: TimerViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - Private

private extension TimerView {
    /// 秒数をフォーマットした文字列にして返す.
    /// - Parameter secondsElapsed: 秒数.
    /// - Returns: `HH:mm:ss` のフォーマットにして返す.
    func formate(_ secondsElapsed: Int) -> String {
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: TimeInterval(secondsElapsed))!
    }
}

// MARK: - Preview

#Preview {
    TimerView(viewModel: .init())
}
