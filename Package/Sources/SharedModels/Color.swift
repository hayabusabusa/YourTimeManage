//
//  Color.swift
//  Package
//
//  Created by Shunya Yamada on 2025/12/10.
//

import Foundation

/// Firestore に保存している色に関する情報.
public struct Color: Sendable, Hashable, Codable {
    /// 16進数のカラーコード.
    public var hex: String
    /// iOS でサポートされている色名.
    public var systemColorName: SystemColorName?

    public init(
        hex: String,
        systemColorName: SystemColorName?
    ) {
        self.hex = hex
        self.systemColorName = systemColorName
    }
}

public extension Color {
    /// `SwiftUI.Color` でサポートされている色名.
    enum SystemColorName: String, Sendable, Codable {
        case red
        case orange
        case yellow
        case green
        case mint
        case teal
        case cyan
        case blue
        case indigo
        case purple
        case pink
        case brown
        case black
        case white
        case gray
    }
}
