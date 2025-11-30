//
//  AppDelegate.swift
//  App
//
//  Created by Shunya Yamada on 2024/02/04.
//

import AppFeature
import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {
    let viewModel = AppViewModel()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        viewModel.didFinishLaunchingWithOptions()
        return true
    }
}
