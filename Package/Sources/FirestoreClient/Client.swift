//
//  Client.swift
//  Package
//
//  Created by Shunya Yamada on 2025/11/30.
//

import Dependencies
import DependenciesMacros
import Foundation
import SharedModels

/// Firestore の操作を行うクライアント.
@DependencyClient
public struct FirestoreClient: Sendable {
    public var addSession: @Sendable (_ session: Session, _ date: Date) async throws -> Void
    public var getSessions: @Sendable (_ date: Date) async throws -> [Session]
    public var getCategories: @Sendable (_ uid: String) async throws -> [SharedModels.Category]
}

// MARK: - Dependencies

extension FirestoreClient: TestDependencyKey {
    public static var previewValue: FirestoreClient {
        .init { _, _ in
            // 何もしない.
        } getSessions: { _ in
            []
        } getCategories: { _ in
            []
        }
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
