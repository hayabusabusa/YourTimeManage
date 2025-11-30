//
//  Client.swift
//  Package
//
//  Created by Shunya Yamada on 2025/11/30.
//

import Dependencies
import DependenciesMacros
import Foundation

/// Firestore の操作を行うクライアント.
@DependencyClient
public struct FirestoreClient: Sendable {
    public var add: @Sendable () async throws -> Void
}

// MARK: - Dependencies

extension FirestoreClient: TestDependencyKey {
    public static var previewValue: FirestoreClient {
        .init {}
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
