//
//  WaveAnimationView.swift
//
//
//  Created by Shunya Yamada on 2024/07/13.
//

import SwiftUI

/// `Circle` に波紋のアニメーションを付けた `View`.
struct WaveAnimationView: View {
    /// アニメーション開始時点の `Date`.
    private let date = Date()
    /// 円のサイズ.
    var size: CGFloat
    /// 円の色.
    var color: Color

    var body: some View {
        TimelineView(.animation) { context in
            let elapsedTime = date.distance(to: context.date)
            Circle()
                .frame(width: size, height: size)
                .foregroundStyle(color)
                .padding()
                .background()
                .drawingGroup()
                .visualEffect { content, proxy in
                    content
                        .distortionEffect(
                            Shaders.waveEffect(
                                size: proxy.size,
                                time: elapsedTime,
                                speed: 3,
                                strength: 3,
                                frequency: 8
                            ),
                            maxSampleOffset: CGSize(
                                width: 0,
                                height: 0
                            )
                        )
                }
        }
    }
}

/// `.metal` ファイルで定義した関数にアクセスするための実装.
/// - note: Swift Package だと `ShaderLibrary.func` でアクセスできないため、補完が効かないが `dynamicMemberLookup` で実装してメソッドで型付け.
@dynamicMemberLookup
private enum Shaders {
    /// 水が揺れるような効果のシェーダーを返す.
    /// - Parameters:
    ///   - size: `View` のサイズ.
    ///   - time: 経過時間.
    ///   - speed: 揺れる効果の速さ.
    ///   - strength: 効果をどのくらい顕著にするか、`1` から `5` あたりが適正.
    ///   - frequency: 頻度、`5` から  `25` あたりが適正.
    /// - Returns: シェーダー.
    static func waveEffect(
        size: CGSize,
        time: Double,
        speed: Double,
        strength: Double,
        frequency: Double
    ) -> Shader {
        Shaders.wave(
            .float2(size),
            .float(time),
            .float(speed),
            .float(strength),
            .float(frequency)
        )
    }

    static subscript(dynamicMember name: String) -> ShaderFunction {
        ShaderLibrary.bundle(.module)[dynamicMember: name]
    }
}
