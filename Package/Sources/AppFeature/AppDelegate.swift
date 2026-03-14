//
//  AppDelegate.swift
//  App
//
//  Created by Shunya Yamada on 2024/02/04.
//

import UIKit

public final class AppDelegate: NSObject, UIApplicationDelegate {
    public let viewModel = AppViewModel()

    public override init() {}

    public func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        viewModel.didFinishLaunchingWithOptions()
        return true
    }
}
