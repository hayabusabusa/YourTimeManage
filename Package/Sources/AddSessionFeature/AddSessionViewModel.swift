//
//  AddSessionViewModel.swift
//  Package
//
//  Created by Shunya Yamada on 2025/12/13.
//

import Dependencies
import FirestoreClient
import Foundation
import Observation

@MainActor
@Observable
public final class AddSessionViewModel {
    /// firestore の操作を行うクライアン.
    @ObservationIgnored
    @Dependency(\.firestoreClient)
    private var firestoreClient

    public init() {}
}
