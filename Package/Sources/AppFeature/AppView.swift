//
//  AppView.swift
//  Package
//
//  Created by Shunya Yamada on 2025/11/30.
//

import SwiftUI

public struct AppView: View {
    @State private(set) var viewModel: AppViewModel

    public var body: some View {
        Text("Hello, World!")
    }

    public init(viewModel: AppViewModel) {
        self.viewModel = viewModel
    }
}
