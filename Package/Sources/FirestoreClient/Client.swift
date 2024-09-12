//
//  Client.swift
//
//
//  Created by Shunya Yamada on 2024/09/08.
//

import Dependencies
import Foundation
import SharedModels

/// Firestore の操作を行うクライアント.
public struct FirestoreClient {
    /// `/users/{userID}/studies` にデータを追加する.
    public var addStudy: @Sendable (AddStudyRequest) async throws -> Void

    public init(addStudy: @escaping @Sendable (AddStudyRequest) async throws -> Void) {
        self.addStudy = addStudy
    }
}

public extension FirestoreClient {
    struct AddStudyRequest: Equatable {
        public let userID: String
        public let study: Study

        public init(
            userID: String,
            study: Study
        ) {
            self.userID = userID
            self.study = study
        }
    }
}

// MARK: - Dependencies

extension FirestoreClient: TestDependencyKey {
    public static var previewValue: FirestoreClient {
        .init(
            addStudy: { _ in }
        )
    }

    public static var testValue: FirestoreClient {
        .init(
            addStudy: { _ in unimplemented("\(Self.self)\(#function)") }
        )
    }
}

extension DependencyValues {
    public var firestoreClient: FirestoreClient {
        get { self[FirestoreClient.self] }
        set { self[FirestoreClient.self] = newValue }
    }
}
