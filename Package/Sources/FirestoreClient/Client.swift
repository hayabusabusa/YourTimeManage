//
//  Client.swift
//
//
//  Created by Shunya Yamada on 2024/09/08.
//

import Dependencies
import Foundation

/// Firestore の操作を行うクライアント.
public struct FirestoreClient {}

// MARK: - Dependencies

extension FirestoreClient: TestDependencyKey {
    public static var previewValue: FirestoreClient {
        .init()
    }

    public static var testValue: FirestoreClient {
        .init()
    }
}

extension DependencyValues {
    public var firestoreClient: FirestoreClient {
        get { self[FirestoreClient.self] }
        set { self[FirestoreClient.self] = newValue }
    }
}
