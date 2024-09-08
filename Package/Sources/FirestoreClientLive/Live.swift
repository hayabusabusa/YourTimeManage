//
//  Live.swift
//
//
//  Created by Shunya Yamada on 2024/09/08.
//

@_exported import FirestoreClient

import Dependencies
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation
import SharedModels

extension FirestoreClient: DependencyKey {
    public static var liveValue: FirestoreClient {
        Self.live()
    }

    private static func live() -> Self {
        let db = Firestore.firestore()
        let encoder = Firestore.Encoder()
        let decoder = Firestore.Decoder()

        return .init(
            addStudy: { request in
                // Firestore 側に `id` のプロパティを持たせたくないのでエンコード後の値から `id` を消す.
                var encoded = try encoder.encode(request.study)
                encoded.removeValue(forKey: "id")

                let path = FirestorePath.studies(userID: request.userID)

                try await db.collection(path)
                    .addDocument(data: encoded)
            }
        )
    }
}
