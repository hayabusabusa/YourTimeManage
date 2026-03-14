//
//  Live.swift
//  Package
//
//  Created by Shunya Yamada on 2025/11/30.
//

@_exported import FirebaseClient
import Dependencies
import FirebaseCore
import Foundation
import GoogleMobileAds

extension FirebaseClient: DependencyKey {
    public static var liveValue: FirebaseClient {
        .init {
            FirebaseApp.configure()
            MobileAds.shared.start()
        }
    }
}
