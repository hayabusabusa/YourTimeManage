//
//  AddSessionView.swift
//  Package
//
//  Created by Shunya Yamada on 2025/12/13.
//

import SwiftUI

public struct AddSessionView: View {
    @State private var viewModel: AddSessionViewModel

    public var body: some View {
        Text("Hello, World!")
    }

    public init(viewModel: AddSessionViewModel) {
        self.viewModel = viewModel
    }
}
