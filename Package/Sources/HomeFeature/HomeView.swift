//
//  HomeView.swift
//  Package
//
//  Created by Shunya Yamada on 2025/12/14.
//

import SwiftUI

public struct HomeView: View {
    @State private var viewModel: HomeViewModel

    public var body: some View {
        Text("Home")
    }

    public init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
}
