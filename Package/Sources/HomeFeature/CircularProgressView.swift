//
//  CircularProgressView.swift
//
//
//  Created by Shunya Yamada on 2024/10/14.
//

import SwiftUI

struct CircularProgressView: View {
    var color: Color
    var progress: CGFloat
    var lineWidth: CGFloat = 8
    var size: CGFloat = 40

    var body: some View {
        ZStack {
            // MARK: Background
            Circle()
                .stroke(
                    color.opacity(0.3),
                    lineWidth: lineWidth
                )

            // MARK: Foreground
            Circle()
                // 0 ~ 1 の範囲になるように調整
                .trim(
                    from: 0,
                    to: min(progress, 1.0)
                )
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
        }
        .frame(
            width: size,
            height: size
        )
    }
}

#Preview {
    CircularProgressView(
        color: .blue,
        progress: 0.75
    )
}
