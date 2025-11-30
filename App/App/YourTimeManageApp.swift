//
//  YourTimeManageApp.swift
//  App
//
//  Created by Shunya Yamada on 2024/05/10.
//

import AppFeature
import SwiftUI

@main
struct YourTimeManageApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            AppView(viewModel: appDelegate.viewModel)
        }
    }
}
